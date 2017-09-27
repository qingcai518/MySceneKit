//
//  Chapter2Controller.swift
//  MySceneKit
//
//  Created by liqc on 2017/09/27.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit
import SceneKit

class Chapter2Controller: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSCNView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension Chapter2Controller {
    fileprivate func setupSCNView() {
        let scnView = SCNView(frame: view.frame)
        scnView.backgroundColor = UIColor.black
        view.addSubview(scnView)
        
        let scene = SCNScene()
        scnView.scene = scene
        
        let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = "test1.jpg"
        
        let boxNode = SCNNode()
        boxNode.geometry = box
        
        scene.rootNode.addChildNode(boxNode)
        scnView.allowsCameraControl = true
        scnView.antialiasingMode = .multisampling4X
        scnView.showsStatistics = true
//        scnView.preferredFramesPerSecond = 30
    }
}
