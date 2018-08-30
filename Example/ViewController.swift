//
//  ViewController.swift
//  LYPopoverView
//
//  Created by youger on 2018/8/28.
//  Copyright © 2018 youger. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LYPopoverViewDelegate {
    
    func popoverView(_ popoverView: LYPopoverView, index: Int) {
        
        print(index)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var popverView = LYPopoverView.init(frame: CGRect.init(x: 0, y: 0, width:LYPopoverViewWidth , height: 0), titles:["test", "test1", "标签"])

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.addSubview(popverView)
        popverView.delegate = self
        let touchPoint = touches.first?.location(in: view)
        let array = [["我我哦我", "滴滴滴", "卡卡卡", "嘛嘛嘛"],["发发发发", "明明"],["肉肉", "好", "谢谢"]]
        
        popverView.resetTitles(titles: array[Int(arc4random()%3)])
        popverView.top = (touchPoint?.y)!
        popverView.showFromRect(rect: CGRect.init(origin: touchPoint!, size:.zero))
    }
}

