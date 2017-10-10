//
//  Chapter3Controller.swift
//  MySceneKit
//
//  Created by liqc on 2017/09/27.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit
import SceneKit
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCamera()
        setupSCNView()
        setupStickerSize()
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
        scnPlane.firstMaterial?.diffuse.contents = "panda.jpg"
        scnNode.geometry = scnPlane
        scnNode.position = SCNVector3Make(0, 0, 0)
        scnView.scene?.rootNode.addChildNode(scnNode)
        
        scnView.allowsCameraControl = true
    }
    
    fileprivate func setupStickerSize() {
        let image = UIImage(named: "panda.jpg")
        stickerOriginalSize = image?.size
    }
    
    fileprivate func toScreenX(_ detectX: Float) -> CGFloat {
        return screenWidth * CGFloat(detectX)
    }
    
    fileprivate func toScreenY(_ detectY: Float) -> CGFloat {
        return screenHeight * CGFloat(1 - detectY)
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
