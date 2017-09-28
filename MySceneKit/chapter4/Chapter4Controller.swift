//
//  Chapter3Controller.swift
//  MySceneKit
//
//  Created by liqc on 2017/09/27.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit
import SceneKit

class Chapter4Controller: UIViewController {
    var scnView = SCNView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSCNView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension Chapter4Controller {
    fileprivate func setupSCNView() {
        scnView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        scnView.center = view.center
        scnView.backgroundColor = UIColor.black
        view.addSubview(scnView)
        
        createScene()
    }
    
    fileprivate func createScene() {
        let scene = SCNScene()
        scnView.scene = scene
        
        let node = SCNNode()
        scene.rootNode.addChildNode(node)
        
        let sphere = SCNSphere(radius: 0.5)
        node.geometry = sphere
        
        // sub node.
        let childNode = SCNNode()
        childNode.position = SCNVector3Make(0, 0, 0)
        
        let scnText = SCNText(string: "Study is very good", extrusionDepth: 0.03)
        scnText.firstMaterial?.diffuse.contents = UIColor.red
        scnText.font = UIFont.systemFont(ofSize: 0.15)
        
        childNode.geometry = scnText
        node.addChildNode(childNode)
        
        scnView.allowsCameraControl = true
    }
}
