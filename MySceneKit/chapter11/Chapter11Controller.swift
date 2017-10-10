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
import UIKit
import SceneKit

class Chapter11Controller: UIViewController {
    var camera: GPUImageVideoCamera!
    var preview : GPUImageView!

    var ciImage: CIImage?
    lazy var trackHandler = AiyaTrackHandler()
    lazy var trackEffect = AiyaTrackEffect()
    var trackInput: AiyaTrackInput!
    
    let scnNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCamera()
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
        let scnView = SCNView()
        scnView.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        scnView.scene = SCNScene()
        scnView.backgroundColor = UIColor.clear
        view.addSubview(scnView)
        
        let scnPlane = SCNPlane(width: 20, height: 20)
        scnPlane.firstMaterial?.diffuse.contents = "panda.jpg"
        scnNode.geometry = scnPlane
        
        scnView.scene?.rootNode.addChildNode(scnNode)
        scnView.allowsCameraControl = true
    }
}

extension Chapter11Controller: GPUImageVideoCameraDelegate {
    func willOutputSampleBuffer(_ sampleBuffer: CMSampleBuffer!) {
        let faceData = trackEffect.getFaceData()
        
        let rotateX = CGFloat(faceData.faceRotation.0)
        let rotateY = CGFloat(faceData.faceRotation.1)
        let rotateZ = CGFloat(faceData.faceRotation.2)
        
        let translateX = CGFloat(faceData.faceTranslation.0)
        let translateY = CGFloat(faceData.faceTranslation.1)
        let translateZ = CGFloat(faceData.faceTranslation.2)
        
        let rotation = SCNAction.rotateTo(x: rotateX, y: -rotateY, z: rotateZ, duration: 0)
        scnNode.runAction(rotation, forKey: "rot")
    }
}
