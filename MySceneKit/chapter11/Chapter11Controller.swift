//
//  Chapter3Controller.swift
//  MySceneKit
//
//  Created by liqc on 2017/09/27.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit
import SceneKit

class Chapter11Controller: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSCNView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension Chapter11Controller {
    fileprivate func setupSCNView() {
        let scnView = SCNView(frame: view.frame)
        scnView.backgroundColor = UIColor.black
        scnView.allowsCameraControl = true
        view.addSubview(scnView)
        
        let scnScene = SCNScene()
        scnView.scene = scnScene
        
        // plane
        let plane = SCNPlane(width: 1, height: 1)
        plane.firstMaterial?.diffuse.contents = UIImage(named: "test3.jpg")
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3Make(0, 0, 0)
        scnScene.rootNode.addChildNode(planeNode)
        
//        // custom.
//        let path = UIBezierPath(arcCenter: <#T##CGPoint#>, radius: <#T##CGFloat#>, startAngle: <#T##CGFloat#>, endAngle: <#T##CGFloat#>, clockwise: <#T##Bool#>)
//        let shape = SCNShape(path: <#T##UIBezierPath?#>, extrusionDepth: 3)
    }
}
