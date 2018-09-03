//
//  UIView+Extension.swift
//  LYPopoverView
//
//  Created by youger on 2018/8/28.
//  Copyright © 2018 youger. All rights reserved.
//

import UIKit

extension UIView{
    
    var left : CGFloat {
        get{
            return frame.origin.x
        }
        set{
            frame.origin.x = newValue
        }
    }
    
    var right : CGFloat {
        get{
            return frame.maxX
        }
        set{
            frame.origin.x = newValue - frame.width
        }
    }
    
    var top : CGFloat {
        get{
            return frame.origin.y
        }
        set{
            frame.origin.y = newValue
        }
    }
    
    var bottom : CGFloat {
        get{
            return frame.maxY
        }
        set{
            frame.origin.y = newValue - frame.height
        }
    }
    
    var width : CGFloat {
        get{
            return frame.width
        }
        set{
            frame.size.width = newValue
        }
    }
    
    var height : CGFloat {
        get{
            return frame.height
        }
        set{
            frame.size.height = newValue
        }
    }
    
    var size : CGSize {
        get{
            return frame.size
        }
        set{
            frame.size = newValue
        }
    }
    
    var centerX : CGFloat {
        get{
            return center.x
        }
        set{
            center.x = newValue
        }
    }
    
    var centerY : CGFloat {
        get{
            return center.y
        }
        set{
            center.y = newValue
        }
    }
}
