//
//  Chapter3Controller.swift
//  MySceneKit
//
//  Created by liqc on 2017/09/27.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit
import GPUImage
import Photos
import ReplayKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

class Chapter11Controller: UIViewController {
    @IBOutlet weak var cameraBtn: UIButton!
    
    var camera: GPUImageVideoCamera!
    var preview : GPUImageView!

    var ciImage: CIImage?
    lazy var trackHandler = AiyaTrackHandler()
    lazy var trackEffect = AiyaTrackEffect()
    var trackInput: AiyaTrackInput!

    lazy var headView = SCNView()
    lazy var headNode = SCNNode()
    
    lazy var beardView = SCNView()
    lazy var beardNode = SCNNode()
    
    lazy var glassView = SCNView()
    lazy var glassNode = SCNNode()
    
    var headSize: CGSize?
    var beardSize: CGSize?
    var glassSize: CGSize?
    
    var frames = [UIImage]()
    var animationTime : Float = 0
    
    // temp.
    let path = NSTemporaryDirectory() + "/tmp.mp4"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCamera()
        loadGif()
        setupHeaderView()
        setupBeardView()
        setupGlassView()
        view.bringSubview(toFront: cameraBtn)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        camera.startCapture()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        camera.stopCapture()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension Chapter11Controller {
    fileprivate func setupCamera() {
        trackInput = AiyaTrackInput(aiyaTrackEffect: trackEffect)
        
        camera = GPUImageVideoCamera(sessionPreset: AVCaptureSession.Preset.hd1280x720.rawValue, cameraPosition: .front)
        camera.outputImageOrientation = .portrait
        camera.horizontallyMirrorFrontFacingCamera = true
        camera.delegate = self
        
        preview = GPUImageView(frame: view.bounds)
        preview.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        view.addSubview(preview)
        
        camera.addTarget(trackInput)
        camera.addTarget(preview)
    }
    
    fileprivate func setupHeaderView() {
        headView.isHidden = true
        headView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        headView.scene = SCNScene()
        headView.backgroundColor = UIColor.clear
        preview.addSubview(headView)
        
        let scnPlane = SCNPlane(width: headView.frame.width, height: headView.frame.height)
        scnPlane.firstMaterial?.diffuse.contents = frames[0]
        headNode.geometry = scnPlane
        headNode.position = SCNVector3Make(0, 0, 0)
        headView.scene?.rootNode.addChildNode(headNode)
        
        let time = TimeInterval(animationTime / Float(frames.count))
        var count = 0
        let action = SCNAction.run { [weak self] node in
            guard let `self` = self else {return}
            self.headNode.geometry?.firstMaterial?.diffuse.contents = self.frames[count]
            if count < self.frames.count - 1 {
                count += 1
            } else {
                count = 0
            }
        }
        let waitAction = SCNAction.wait(duration: time)
        let actions = SCNAction.sequence([action, waitAction])
        let repeatActions = SCNAction.repeatForever(actions)
        headNode.runAction(repeatActions)
    }
    
    fileprivate func setupBeardView() {
        beardView.isHidden = true
        beardView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        beardView.scene = SCNScene()
        beardView.backgroundColor = UIColor.clear
        preview.addSubview(beardView)
        
        let beardImage = UIImage(named: "huxu.png")
        beardSize = beardImage?.size
        
        let scnPlane = SCNPlane(width: beardView.frame.width, height: beardView.frame.height)
        scnPlane.firstMaterial?.diffuse.contents = beardImage
        beardNode.geometry = scnPlane
        beardNode.position = SCNVector3Make(0, 0, 0)
        beardView.scene?.rootNode.addChildNode(beardNode)
    }
    
    fileprivate func setupGlassView() {
        glassView.isHidden = true
        glassView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        glassView.scene = SCNScene()
        glassView.backgroundColor = UIColor.clear
        preview.addSubview(glassView)
        
        let glassImage = UIImage(named: "glass.png")
        glassSize = glassImage?.size
        
        let scnPlane = SCNPlane(width: glassView.frame.width, height: glassView.frame.height)
        scnPlane.firstMaterial?.diffuse.contents = glassImage
        glassNode.geometry = scnPlane
        glassNode.position = SCNVector3Make(0, 0, 0)
        glassView.scene?.rootNode.addChildNode(glassNode)
    }
    
    fileprivate func toScreenX(_ detectX: Float) -> CGFloat {
        return screenWidth * CGFloat(detectX)
    }
    
    fileprivate func toScreenY(_ detectY: Float) -> CGFloat {
        return screenHeight * CGFloat(1 - detectY)
    }
    
    fileprivate func loadGif() {
        guard let filePath = Bundle.main.path(forResource: "panda", ofType: "jpg") else {return}
        let fileUrl = URL(fileURLWithPath: filePath)
        do {
            let data = try Data(contentsOf: fileUrl)
            guard let src = CGImageSourceCreateWithData(data as CFData, nil) else {return}
            let imageCount = CGImageSourceGetCount(src)
            
            for i in 0..<imageCount {
                guard let cgImage = CGImageSourceCreateImageAtIndex(src, i, nil) else {continue}
                guard let properties = CGImageSourceCopyPropertiesAtIndex(src, i, nil) as? [String: Any] else {continue}
                
                guard let frameProperties = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any] else {continue}
                guard let delayTime = frameProperties[kCGImagePropertyGIFUnclampedDelayTime as String] as? Float else {continue}
                animationTime += delayTime
                
                let image = UIImage(cgImage: cgImage)
                if i == 0 {
                    headSize = image.size
                }
                frames.append(image)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        print("animation time = \(animationTime)")
        print("count = \(frames.count)")
    }
    
    fileprivate func saveFileToCameraRoll() {
        DispatchQueue.global(qos: .utility).async {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: self.path))
            }) { (done, err) in
                if err != nil {
                    print("Error creating video file in library")
                    print(err.debugDescription)
                } else {
                    print("Done writing asset to the user's photo library")
                }
            }
        }
    }
}

extension Chapter11Controller: GPUImageVideoCameraDelegate {
    func willOutputSampleBuffer(_ sampleBuffer: CMSampleBuffer!) {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            ciImage = CIImage(cvImageBuffer: pixelBuffer)
        }

        if !trackEffect.trackSuccess() {
            DispatchQueue.main.async {
                self.headView.isHidden = true
                self.beardView.isHidden = true
                self.glassView.isHidden = true
            }
            return
        }
        
        let faceData = trackEffect.getFaceData()
        
        let rotateX = CGFloat(faceData.faceRotation.0)
        let rotateY = CGFloat(faceData.faceRotation.1)
        let rotateZ = CGFloat(faceData.faceRotation.2)

        // head.
        let headCenterX = toScreenX(faceData.featurePoints2D.68.0)
        let headCenterY = toScreenY(faceData.featurePoints2D.68.1)
        let headWidth = toScreenX(faceData.featurePoints2D.24.0 - faceData.featurePoints2D.19.0)
        var headHeight = headWidth
        if let headSize = headSize {
            headHeight = headWidth * headSize.height / headSize.width
        }
        
        // beard.
        let beardCenterX = toScreenX(faceData.featurePoints2D.33.0)
        let beardCenterY = toScreenY(faceData.featurePoints2D.33.1 - (faceData.featurePoints2D.33.1 - faceData.featurePoints2D.51.1) / 2)
        let beardWidth = toScreenX(faceData.featurePoints2D.15.0 - faceData.featurePoints2D.1.0) * 2 / 3
        var beardHeight = beardWidth
        if let beardSize = beardSize {
            beardHeight = beardWidth * beardSize.height / beardSize.width
        }
        
        // glass.
        let glassCenterX = toScreenX(faceData.featurePoints2D.28.0)
        let glassCenterY = toScreenY(faceData.featurePoints2D.28.1)
        let glassWidth = toScreenX(faceData.featurePoints2D.16.0 - faceData.featurePoints2D.0.0 + 0.2)
        var glassHeight = glassWidth
        if let glassSize = glassSize {
            glassHeight = glassWidth * glassSize.height / glassSize.width
        }
        
        DispatchQueue.main.async {
            // head
            self.headView.frame = CGRect(x: 0, y: 0, width: headWidth, height: headHeight)
            self.headView.center = CGPoint(x: headCenterX, y: headCenterY)
            self.headView.isHidden = false
            
            // beard.
            self.beardView.frame = CGRect(x: 0, y: 0, width: beardWidth, height: beardHeight)
            self.beardView.center = CGPoint(x: beardCenterX, y: beardCenterY)
            self.beardView.isHidden = false
            
            // glass.
            self.glassView.frame = CGRect(x: 0, y: 0, width: glassWidth, height: glassHeight)
            self.glassView.center = CGPoint(x: glassCenterX, y: glassCenterY)
            self.glassView.isHidden = false
        }

        let rotation = SCNAction.rotateTo(x: rotateX, y: -rotateY, z: rotateZ, duration: 0)
        headNode.runAction(rotation)
        beardNode.runAction(rotation)
        glassNode.runAction(rotation)
    }
}

extension Chapter11Controller {
    @IBAction func startRecord() {
        print("111")
    }
    
    @IBAction func endRecord() {
        print("222")
    }
    
    @IBAction func doCamera() {
        guard let ciImage = ciImage else {return}
        let image0 = UIImage(ciImage: ciImage, scale: UIScreen.main.scale, orientation: UIImageOrientation.leftMirrored)
        let image1 = headView.snapshot()
        let image2 = beardView.snapshot()
        let image3 = glassView.snapshot()
        
        let size = CGSize(width: screenWidth, height: screenHeight)
        UIGraphicsBeginImageContext(size)
        
        image0.draw(in: view.frame)
        image1.draw(in: headView.frame, blendMode: CGBlendMode.normal, alpha: 1)
        image2.draw(in: beardView.frame, blendMode: CGBlendMode.normal, alpha: 1)
        image3.draw(in: glassView.frame, blendMode: CGBlendMode.normal, alpha: 1)
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        guard let next = UIStoryboard(name: "PictureConfirm", bundle: nil).instantiateInitialViewController() as? PictureConfirmController else {return}
        next.image = newImage
        navigationController?.pushViewController(next, animated: true)
    }
}
