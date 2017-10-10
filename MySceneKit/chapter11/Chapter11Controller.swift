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

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

class Chapter11Controller: UIViewController {
    var camera: GPUImageVideoCamera!
    var preview : GPUImageView!

    var ciImage: CIImage?
    lazy var trackHandler = AiyaTrackHandler()
    lazy var trackEffect = AiyaTrackEffect()
    var trackInput: AiyaTrackInput!
    
    lazy var scnView = SCNView()
    lazy var scnNode = SCNNode()
    
    var stickerOriginalSize: CGSize?
    var frames = [UIImage]()
    var animationTime : Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCamera()
        loadGif()
        setupSCNView()
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
    
    fileprivate func setupSCNView() {
        scnView.isHidden = true
        scnView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        scnView.scene = SCNScene()
        scnView.backgroundColor = UIColor.clear
        view.addSubview(scnView)
        
        let scnPlane = SCNPlane(width: scnView.frame.width, height: scnView.frame.height)
        scnPlane.firstMaterial?.diffuse.contents = frames[4]
        scnNode.geometry = scnPlane
        scnNode.position = SCNVector3Make(0, 0, 0)
        scnView.scene?.rootNode.addChildNode(scnNode)
        
        let time = TimeInterval(animationTime / Float(frames.count))
        var count = 0
        let action = SCNAction.run { [weak self] node in
            guard let `self` = self else {return}
            self.scnNode.geometry?.firstMaterial?.diffuse.contents = self.frames[count]
            if count < self.frames.count - 1 {
                count += 1
            } else {
                count = 0
            }
        }
        let waitAction = SCNAction.wait(duration: time)
        let actions = SCNAction.sequence([action, waitAction])
        let repeatActions = SCNAction.repeatForever(actions)
        scnNode.runAction(repeatActions)
        
        scnView.allowsCameraControl = true
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
                    stickerOriginalSize = image.size
                }
                frames.append(image)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        print("animation time = \(animationTime)")
        print("count = \(frames.count)")
    }
}

extension Chapter11Controller: GPUImageVideoCameraDelegate {
    func willOutputSampleBuffer(_ sampleBuffer: CMSampleBuffer!) {
        if !trackEffect.trackSuccess() {
            DispatchQueue.main.async {
                self.scnView.isHidden = true
            }
            return
        }
        
        let faceData = trackEffect.getFaceData()
        
        let rotateX = CGFloat(faceData.faceRotation.0)
        let rotateY = CGFloat(faceData.faceRotation.1)
        let rotateZ = CGFloat(faceData.faceRotation.2)

        let centerX = toScreenX(faceData.featurePoints2D.68.0)
        let centerY = toScreenY(faceData.featurePoints2D.68.1)
        let width = toScreenX(faceData.featurePoints2D.24.0 - faceData.featurePoints2D.19.0)
        var height = width
        if let stickerOriginalSize = stickerOriginalSize {
            height = width * stickerOriginalSize.height / stickerOriginalSize.width
        }

        DispatchQueue.main.async {
            self.scnView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            self.scnView.center = CGPoint(x: centerX, y: centerY)
            self.scnView.isHidden = false
        }

        let rotation = SCNAction.rotateTo(x: rotateX, y: -rotateY, z: rotateZ, duration: 0)
        scnNode.runAction(rotation)
    }
}
