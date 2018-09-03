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
    var icon: String = ""
    var clickedBlock:os_function_t?
    
    init(title:String, icon: String) {
        
        self.title = title
        self.icon = icon
    }
}
