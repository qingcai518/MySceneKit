//
//  MainController.swift
//  MySceneKit
//
//  Created by liqc on 2017/09/27.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

class MainController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let viewModel = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "SceneKit Study"
        setTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MainController {
    fileprivate func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        viewModel.getChapters()
        tableView.reloadData()
    }
}
