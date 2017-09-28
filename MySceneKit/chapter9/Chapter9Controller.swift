//
//  Chapter3Controller.swift
//  MySceneKit
//
//  Created by liqc on 2017/09/27.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit
import SceneKit

class Chapter9Controller: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSCNView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension Chapter9Controller {
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
        scnView.scene?.rootNode.addChildNode(cameraNode)
        
        let box1 = SCNBox(width: 10, height: 10, length: 10, chamferRadius: 0)
        let box2 = SCNBox(width: 10, height: 10, length: 10, chamferRadius: 0)
        box1.firstMaterial?.diffuse.contents = UIImage(named: "test1")
        box2.firstMaterial?.diffuse.contents = UIImage(named: "test2")
        
        let boxNode1 = SCNNode(geometry: box1)
        let boxNode2 = SCNNode(geometry: box2)
        boxNode2.position = SCNVector3Make(0, 10, -20)
        
        scnScene.rootNode.addChildNode(boxNode1)
        scnScene.rootNode.addChildNode(boxNode2)
    }
}
