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
        chapters.append(ChapterInfo(id: "Chapter4", name: "Chapter4.  child node & root node"))
        chapters.append(ChapterInfo(id: "Chapter5", name: "Chapter5.  mix light"))
        chapters.append(ChapterInfo(id: "Chapter6", name: "Chapter6.  omni light"))
        chapters.append(ChapterInfo(id: "Chapter7", name: "Chapter7.  directional light"))
        chapters.append(ChapterInfo(id: "Chapter8", name: "Chapter8.  sopt light"))
        chapters.append(ChapterInfo(id: "Chapter9", name: "Chapter9.  camera"))
        chapters.append(ChapterInfo(id: "Chapter10", name: "Chapter10.  action"))
        chapters.append(ChapterInfo(id: "Chapter11", name: "Chapter11.  geometry"))
        chapters.append(ChapterInfo(id: "Chapter12", name: "Chapter12.  movie"))
        chapters.append(ChapterInfo(id: "Chapter13", name: "Chapter13.  Vision"))
    }
}
