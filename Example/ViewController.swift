//
//  ViewController.swift
//  LYPopoverView
//
//  Created by youger on 2018/8/28.
//  Copyright © 2018 youger. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var menus: [Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("dealloc")
    }
    
    func pushViewController(_ atIndex:Int) {
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "ViewController")
        if menus is [String]  {
            viewController?.title = menus?[atIndex] as? String
        }else if menus is [LYPopoverItem]{
            viewController?.title = (menus?[atIndex] as? LYPopoverItem)?.title
        }
        navigationController?.pushViewController(viewController!, animated: true)
    }
    
    lazy var popverView = LYPopoverView.init(frame: CGRect.init(x: 0, y: 0, width:LYPopoverViewWidth , height: 0), titles:["test", "test1", "标签"])
    
    func configurePopoverViewInterface() {
        
        if arc4random()%2 == 0 {
         
            popverView.popoverBackgroundColor = UIColor.white
            popverView.textColor = UIColor.black
            popverView.separatorColor = UIColor.gray
        }else{
            
            popverView.popoverBackgroundColor = UIColor.brown
            popverView.textColor = UIColor.white
            popverView.separatorColor = UIColor.white
        }
    }
    
    lazy var rectangleView = UIImageView.init()

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.addSubview(popverView)
        let touchPoint = touches.first?.location(in: view)
        
        menus = getMenus()
        if menus is [String]  {
            popverView.delegate = self
            popverView.resetTitles(titles: menus as! [String])
        }else if menus is [LYPopoverItem]{
            popverView.delegate = nil
            popverView.resetItems(items: menus as! [LYPopoverItem])
        }
        
        configurePopoverViewInterface()
        rectangleView.center = touchPoint!
        rectangleView.size = CGSize(width: 60, height: 44)
        view.addSubview(rectangleView)
        //rectangleView.layer.borderColor = UIColor.red.cgColor
        //rectangleView.layer.borderWidth = 0.5
        
        rectangleView.image = drawRectangle(rect: rectangleView.frame)
        popverView.showFromRect(rect: rectangleView.frame)
    }
    
    func getMenus() -> [Any] {
        
        func createItem(_ title: String) -> LYPopoverItem{
            let item = LYPopoverItem(title: title, icon: nil)
            item.setClickedBlock(delegate: self) { (self, index) in
                print("clicked item at index: \(index)")
                self.pushViewController(index)
            }
            return item
        }
        let array = [["我我哦我", "滴滴滴", "卡卡卡", "嘛嘛嘛"],[createItem("发发发发"), createItem("明明")],["肉肉", "好", "谢谢"]]
        let menus = array[Int(arc4random()%3)]
        return menus
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

extension ViewController: LYPopoverViewDelegate{
    
    func popoverView(_ popoverView: LYPopoverView, index: Int) {
        
        print("clicked title at index: \(index)")
        pushViewController(index)
    }
}
