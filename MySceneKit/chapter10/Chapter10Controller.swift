//
//  Chapter3Controller.swift
//  MySceneKit
//
//  Created by liqc on 2017/09/27.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit
import SceneKit

class Chapter10Controller: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSCNView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension Chapter10Controller {
    fileprivate func setupSCNView() {
        let scnView = SCNView(frame: view.frame)
        scnView.backgroundColor = UIColor.black
        scnView.allowsCameraControl = true
        view.addSubview(scnView)
        
        let scnScene = SCNScene()
        scnView.scene = scnScene
        
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3Make(0, 0, 50)
        scnScene.rootNode.addChildNode(cameraNode)
        
        let box = SCNBox(width: 10, height: 10, length: 10, chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = UIImage(named: "test2.jpg")
        let boxNode = SCNNode(geometry: box)
        boxNode.position = SCNVector3Make(0, 0, 0)
        scnScene.rootNode.addChildNode(boxNode)
        
        let rotation = SCNAction.rotate(by: 10, around: SCNVector3Make(0, 1, 0), duration: 2)
        let moveUp = SCNAction.move(to: SCNVector3Make(0, 15, 0), duration: 1)
        let moveDown = SCNAction.move(to: SCNVector3Make(0, -15, 0), duration: 1)
        
        let sequence = SCNAction.sequence([moveUp, moveDown])
        let group = SCNAction.group([sequence, rotation])
        let repeatAction = SCNAction.repeatForever(group)
        boxNode.runAction(repeatAction)
    }
}
