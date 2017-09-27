//
//  MainViewModel.swift
//  MySceneKit
//
//  Created by liqc on 2017/09/27.
//  Copyright © 2017年 RN-079. All rights reserved.
//

class MainViewModel {
    var chapters = [ChapterInfo]()
    
    func getChapters() {
        chapters.append(ChapterInfo(id: "Chapter1", name: "Chapter1.  text"))
        chapters.append(ChapterInfo(id: "Chapter2", name: "Chapter2.  cube"))
        chapters.append(ChapterInfo(id: "Chapter3", name: "Chapter3.  3d model"))
        chapters.append(ChapterInfo(id: "Chapter4", name: "Chapter4."))
        chapters.append(ChapterInfo(id: "Chapter5", name: "Chapter5."))
        chapters.append(ChapterInfo(id: "Chapter6", name: "Chapter6."))
        chapters.append(ChapterInfo(id: "Chapter7", name: "Chapter7."))
        chapters.append(ChapterInfo(id: "Chapter8", name: "Chapter8."))
        chapters.append(ChapterInfo(id: "Chapter9", name: "Chapter9."))
        chapters.append(ChapterInfo(id: "Chapter10", name: "Chapter10."))
        chapters.append(ChapterInfo(id: "Chapter11", name: "Chapter11."))
        chapters.append(ChapterInfo(id: "Chapter12", name: "Chapter12."))
    }
}
