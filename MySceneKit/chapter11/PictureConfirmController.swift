//
//  PictureConfirmController.swift
//  MySceneKit
//
//  Created by liqc on 2017/10/11.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

class PictureConfirmController: UIViewController {
    @IBOutlet weak var pictureView: UIImageView!
    // param
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pictureView.image = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
