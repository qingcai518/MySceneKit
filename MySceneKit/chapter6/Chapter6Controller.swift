//
//  Chapter3Controller.swift
//  MySceneKit
//
//  Created by liqc on 2017/09/27.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit
import SceneKit

class Chapter6Controller: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSCNView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension Chapter6Controller {
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

        // omni light.
        let light = SCNLight()
        light.type = .omni
        light.color = UIColor.yellow
        
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3Make(0, 0, 100)
        scnScene.rootNode.addChildNode(lightNode)
    }
}
