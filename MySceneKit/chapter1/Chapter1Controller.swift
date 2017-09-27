//
//  Chapter1Controller.swift
//  MySceneKit
//
//  Created by liqc on 2017/09/27.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit
import SceneKit

class Chapter1Controller: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSCNView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension Chapter1Controller {
    fileprivate func setupSCNView() {
        let scnView = SCNView()
        scnView.frame = view.frame
        scnView.scene = SCNScene()
        scnView.backgroundColor = UIColor.black
        view.addSubview(scnView)
        
        let scnNode = SCNNode()
        let scnText = SCNText(string: "My SceneKit Study", extrusionDepth: 0.5)
        scnNode.geometry = scnText
        
        scnView.scene?.rootNode.addChildNode(scnNode)
        scnView.allowsCameraControl = true
    }
}
