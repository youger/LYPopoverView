//
//  LYPopoverItem.swift
//  LYPopoverView
//
//  Created by youger on 2018/8/28.
//  Copyright © 2018 youger. All rights reserved.
//

import Foundation

class LYPopoverItem {
    
    var title: String = ""
    var icon: String?
    //var clickedBlock : ((Int)->Void)?
 
    init(title: String, icon: String?) {
        self.title = title
        self.icon = icon
    }
    
    private var clickedBlock : ((Int)->Void)?
    
    func setClickedBlock<Object : AnyObject>(delegate: Object, callback: @escaping (Object, Int) -> Void) {
        self.clickedBlock = { [weak delegate] index in
            if let delegate = delegate {
                callback(delegate, index)
            }
        }
    }
    
    func clickedBlockImp(_ index:Int) {
        self.clickedBlock?(index)
    }
}
