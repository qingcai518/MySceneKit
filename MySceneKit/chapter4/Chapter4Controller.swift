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
        let scnView = SCNView(frame: view.frame)
        view.addSubview(scnView)
        
        let scnScene = SCNScene(named: "test1.dae")
        scnView.scene = scnScene
        
        scnView.allowsCameraControl = true
    }
}
