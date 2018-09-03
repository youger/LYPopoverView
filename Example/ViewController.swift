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
        
        print("clicked index \(index)")
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
    
    func configurePopoverViewInterface() {
        
        if arc4random()%2 == 0 {
         
            popverView.popoverBackgroundColor = UIColor.white
            popverView.textColor = UIColor.black
            popverView.separatorColor = UIColor.gray
        }else{
            
            popverView.popoverBackgroundColor = UIColor.black
            popverView.textColor = UIColor.white
            popverView.separatorColor = UIColor.white
        }
    }
    
    lazy var rectangleView = UIImageView.init()

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.addSubview(popverView)
        popverView.delegate = self
        let touchPoint = touches.first?.location(in: view)
        let array = [["我我哦我", "滴滴滴", "卡卡卡", "嘛嘛嘛"],["发发发发", "明明"],["肉肉", "好", "谢谢"]]
        
        popverView.resetTitles(titles: array[Int(arc4random()%3)])
        popverView.top = (touchPoint?.y)!
        configurePopoverViewInterface()
        rectangleView.center = touchPoint!
        rectangleView.size = CGSize(width: 60, height: 44)
        //rectangleView.layer.borderColor = UIColor.red.cgColor
        //rectangleView.layer.borderWidth = 0.5
        view.addSubview(rectangleView)
        //let rect = CGRect.init(origin: touchPoint!, size:CGSize(width: 100, height: 50))
        
        rectangleView.image = drawRectangle(rect: rectangleView.frame)
        popverView.showFromRect(rect: rectangleView.frame)
    }
    
    func drawRectangle(rect:CGRect)-> UIImage {
        
        UIGraphicsBeginImageContext(rect.size)
        let path = UIBezierPath.init(rect: CGRect.init(origin: .zero, size: rect.size)).cgPath
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setStrokeColor(UIColor.red.cgColor)
        ctx?.addPath(path)
        ctx?.setShadow(offset: .zero, blur: 5)
        ctx?.setShadow(offset: .zero, blur: 5, color: UIColor.red.cgColor)
        ctx?.stroke(CGRect.init(origin: .zero, size: rect.size))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

