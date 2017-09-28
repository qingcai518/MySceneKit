//
//  Chapter3Controller.swift
//  MySceneKit
//
//  Created by liqc on 2017/09/27.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit
import SceneKit

class Chapter5Controller: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSCNView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension Chapter5Controller {
    fileprivate func setupSCNView() {
        let scnView = SCNView(frame: view.frame)
        scnView.backgroundColor = UIColor.black
        scnView.allowsCameraControl = true
        view.addSubview(scnView)
        
        let scnScene = SCNScene()
        scnView.scene = scnScene
        
        let scnBox = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0)
        let scnSphere = SCNSphere(radius: 0.1)
        
        let boxNode = SCNNode(geometry: scnBox)
        boxNode.position = SCNVector3Make(0, 0, -11)
        
        let sphereNode = SCNNode(geometry: scnSphere)
        sphereNode.position = SCNVector3Make(0, 0, -10)
        
        scnScene.rootNode.addChildNode(boxNode)
        scnScene.rootNode.addChildNode(sphereNode)
        
        // ambient light.
        let light1 = SCNLight()
        light1.type = .ambient
        light1.color = UIColor.brown
        let lightNode1 = SCNNode()
        lightNode1.light = light1
        scnScene.rootNode.addChildNode(lightNode1)
        
        // omni light.
        let light2 = SCNLight()
        light2.type = .omni
        light2.color = UIColor.red
        let lightNode2 = SCNNode()
        lightNode2.light = light2
        lightNode2.position = SCNVector3Make(0, -10, 0)
        lightNode2.rotation = SCNVector4Make(1, 0, 0, .pi/2)
        scnScene.rootNode.addChildNode(lightNode2)
     
        // directional light.
        let light3 = SCNLight()
        light3.type = .directional
        light3.color = UIColor.yellow
        let lightNode3 = SCNNode()
        lightNode3.light = light3
        lightNode3.position = SCNVector3Make(0, 10, -100)
        lightNode3.rotation = SCNVector4Make(1, 0, 0, -.pi / 2)
        scnScene.rootNode.addChildNode(lightNode3)
        
        
        // spot light.
        let light4 = SCNLight()
        light4.type = .spot
        light4.color = UIColor.blue
        light4.castsShadow = true
        let lightNode4 = SCNNode()
        lightNode4.light = light4
        lightNode4.position = SCNVector3Make(0, 0, -1)
        scnScene.rootNode.addChildNode(lightNode4)
    }
}
