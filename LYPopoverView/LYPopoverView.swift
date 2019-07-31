//
//  LYPopoverView.swift
//  LYPopoverView
//
//  Created by youger on 2018/8/28.
//  Copyright © 2018 youger. All rights reserved.
//

import UIKit

enum LYPopoverDirection {
    case topTobottom
    case bottomToTop
}

let LYPopoverViewWidth: CGFloat = 120
fileprivate let LYPopoverViewButtonBaseTag = 100
fileprivate let LYPopoverViewContentPadding: CGFloat = 2
fileprivate let LYPopoverArrowHeight: CGFloat = 5
fileprivate let LYPopoverArrowWidth: CGFloat = 12
fileprivate let LYPopoverButtonHeight : CGFloat = 44

class LYPopoverView: UIView {
    
    fileprivate var _shadowView: UIView = UIView()
    fileprivate var _contentView: UIView = UIView()
    fileprivate var _arrowImageView: UIImageView = UIImageView()
    fileprivate var _titles: [String]?
    fileprivate var _popoverItems : [LYPopoverItem]?
    fileprivate var _cellCount : Int = 0
    fileprivate var _shadowTopAnchor: NSLayoutConstraint?
    
    open var popoverViewPadding: CGFloat = 8
    open var popoverDirection: LYPopoverDirection = .topTobottom
    open var popoverBackgroundColor: UIColor = UIColor.black{
        didSet(newValue){
            //_arrowImageView.image = _arrowImageView.image?.imageWithColor(color1: newValue)
            _contentView.backgroundColor = newValue
            if newValue.isEqual(UIColor.white) {
                _shadowView.layer.shadowColor = UIColor.black.cgColor
            }else{
                _shadowView.layer.shadowColor = UIColor.clear.cgColor
            }
            drawArrowImage(newValue)
        }
    }
    open var textColor = UIColor.white
    open var separatorColor = UIColor.white
    
    weak var delegate: LYPopoverViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    convenience init(frame: CGRect, titles: [String]) {
    
        self.init(frame: frame)
        resetTitles(titles: titles)
    }
    
    convenience init(frame: CGRect, items: [LYPopoverItem]) {
        
        self.init(frame: frame)
        resetItems(items: items)
    }
    
    func configureSubviews()
    {
        self.clipsToBounds = true
        _shadowView.translatesAutoresizingMaskIntoConstraints = false
        _shadowView.backgroundColor = UIColor.init(white: 1, alpha: 1)
        _shadowView.layer.cornerRadius = 5.0
        _shadowView.layer.shadowColor = popoverBackgroundColor.cgColor
        _shadowView.layer.shadowOffset = CGSize.zero
        _shadowView.layer.shadowOpacity = 1.0
        _shadowView.layer.shadowRadius = LYPopoverViewContentPadding
        _shadowView.layer.masksToBounds = false
        addSubview(_shadowView)
        _shadowTopAnchor = _shadowView.topAnchor.constraint(equalTo: self.topAnchor, constant: LYPopoverArrowHeight)
        self.addConstraints([
            _shadowTopAnchor!,
            _shadowView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: LYPopoverViewContentPadding),
            _shadowView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -LYPopoverViewContentPadding),
             _shadowView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -LYPopoverArrowHeight-LYPopoverViewContentPadding),
        ])
        
        _contentView.translatesAutoresizingMaskIntoConstraints = false
        _contentView.clipsToBounds = true
        _contentView.backgroundColor = popoverBackgroundColor
        _contentView.layer.cornerRadius = 5.0
        addSubview(_contentView)
        
        self.addConstraints([
            _contentView.topAnchor.constraint(equalTo: _shadowView.topAnchor),
            _contentView.leftAnchor.constraint(equalTo: _shadowView.leftAnchor),
            _contentView.bottomAnchor.constraint(equalTo: _shadowView.bottomAnchor),
            _contentView.rightAnchor.constraint(equalTo: _shadowView.rightAnchor),
        ])
        
        _arrowImageView = UIImageView.init(frame: CGRect.init(x: (self.width - LYPopoverArrowWidth)/2.0, y: 0, width: LYPopoverArrowWidth, height: LYPopoverArrowHeight))
        addSubview(_arrowImageView)
        drawArrowImage(UIColor.black);
    }
    
    func configureItemView()
    {
        for view in _contentView.subviews{
            view.removeFromSuperview()
        }
        
        func configureItemViewLayout(itemView: UIView, index: Int){
            
            _contentView.addConstraints([
                itemView.topAnchor.constraint(equalTo: _contentView.topAnchor, constant: LYPopoverButtonHeight * CGFloat(index)),
                itemView.leftAnchor.constraint(equalTo: _contentView.leftAnchor, constant: 8),
                itemView.rightAnchor.constraint(equalTo: _contentView.rightAnchor, constant: -8),
                itemView.heightAnchor.constraint(equalToConstant: LYPopoverButtonHeight),
                ])
        }
        
        _titles?.enumerated().forEach({ (index, obj) in
            
            let itemView = itemViewWithTitle(title: obj as String, index: index)
            
            _contentView.addSubview(itemView)
            configureItemViewLayout(itemView: itemView, index: index)
            
        })
        
        _popoverItems?.enumerated().forEach({ (index, obj) in
            
            let itemView = itemViewWithTitle(title: obj.title as String, index: index)
            
            _contentView.addSubview(itemView)
            configureItemViewLayout(itemView: itemView, index: index)
        })
        
        sizeToFit()
    }
    
    func drawArrowImage(_ color:UIColor){
        
        let scale = UIScreen.main.scale
        let width = LYPopoverArrowWidth
        let height = LYPopoverArrowHeight
        let lineWidth = 1/scale
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height),  false, scale)
        let ctx = UIGraphicsGetCurrentContext()
        let path = UIBezierPath()
        path.move(to: CGPoint.init(x: lineWidth, y: height))
        path.addLine(to: CGPoint.init(x: width / 2.0, y: lineWidth))
        path.addLine(to: CGPoint.init(x: width - lineWidth, y: height))
        
        if color.isEqual(UIColor.white) {
            ctx?.setShadow(offset: CGSize.init(width: 0, height: -lineWidth), blur: 2, color: UIColor.init(white: 0, alpha: 0.6).cgColor)
        }
        
        ctx?.addPath(path.cgPath)
        ctx?.setFillColor(color.cgColor)
        ctx?.fillPath()
        
        let arrowImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        _arrowImageView.image = arrowImage
    }
    
    func itemViewWithTitle(title: String, index: Int) -> UIButton {
        
        let button = UIButton.init(type:.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.tag = index + LYPopoverViewButtonBaseTag
        
        if index < _cellCount - 1 {
            
            let separatorLine = UIView()
            separatorLine.translatesAutoresizingMaskIntoConstraints = false
            separatorLine.backgroundColor = separatorColor
            button.addSubview(separatorLine)
            
            button.addConstraints([
                separatorLine.bottomAnchor.constraint(equalTo: button.bottomAnchor),
                separatorLine.leftAnchor.constraint(equalTo: button.leftAnchor),
                separatorLine.rightAnchor.constraint(equalTo: button.rightAnchor),
                separatorLine.heightAnchor.constraint(equalToConstant: 0.5),
                ])
        }
        return button
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
     
        return CGSize(width: size.width, height: CGFloat(_cellCount) * LYPopoverButtonHeight + LYPopoverArrowHeight + LYPopoverViewContentPadding)
    }
    
    @objc func buttonClicked(sender: UIButton){
        
        let index: Int = sender.tag - LYPopoverViewButtonBaseTag
        
        if delegate != nil {
            delegate?.popoverView(self, index: index)
        }
    
        dismiss()
        
        guard _popoverItems == nil else {
            
            if (index < (_popoverItems?.count)!) {
                let item = _popoverItems![index]
                item.clickedBlockImp(index)
            }
            return
        }
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        let touchInside = super.point(inside: point, with: event)
        guard touchInside else {
            
            dismiss()
            return touchInside
        }
        return touchInside
    }

    func resetTitles(titles: [String]) {
        
        _popoverItems = nil
        _titles = titles
        _cellCount = titles.count
        
        configureItemView()
    }
    
    func resetItems(items: [LYPopoverItem]) {
        
        _popoverItems = items
        _titles = nil
        _cellCount = items.count
        
        configureItemView()
    }
    
    func setPopoverDirection(direction: LYPopoverDirection) {
        
        popoverDirection = direction
        if (popoverDirection == .topTobottom){
            
            _shadowTopAnchor?.constant = LYPopoverArrowHeight
            _arrowImageView.transform = CGAffineTransform.identity
            _arrowImageView.top = 0.5
            
        }else if (popoverDirection == .bottomToTop) {
            
            _shadowTopAnchor?.constant = LYPopoverViewContentPadding
            _arrowImageView.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi)
            _arrowImageView.top = CGFloat(_cellCount) * LYPopoverButtonHeight +  LYPopoverViewContentPadding - 0.5
        }
        layoutIfNeeded()
    }
    
    func showFromRect(rect: CGRect){
        
        let popoverFrame = layoutPopoverFrameFromRect(rect: rect)
        
        var fromY = popoverFrame.minY
        if (popoverDirection == .bottomToTop) {
            fromY = popoverFrame.maxY
        }
        self.frame = CGRect(x: popoverFrame.minX, y: fromY, width: popoverFrame.width, height: 0)
        self.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.frame = popoverFrame
        }
    }
    
    func layoutPopoverFrameFromRect(rect: CGRect) -> CGRect {
        
        sizeToFit()
        var originFrame = frame
        let midX = rect.midX
        let halfWidth = originFrame.width/2.0
        let cornerPadding: CGFloat = 2.5 + LYPopoverViewContentPadding
        _arrowImageView.centerX = halfWidth
        
        if midX < halfWidth {
            
            originFrame.origin.x = popoverViewPadding
            _arrowImageView.left = cornerPadding
            if midX > popoverViewPadding {
                _arrowImageView.centerX = max(midX - popoverViewPadding, popoverViewPadding + cornerPadding)
            }
        }
        else if(midX > (superview?.width)! - halfWidth){
            
            originFrame.origin.x = (self.superview?.width)! - originFrame.width - popoverViewPadding
            _arrowImageView.right = originFrame.width - cornerPadding
            if(midX < (superview?.width)! - popoverViewPadding){
                _arrowImageView.centerX = min(midX - originFrame.minX, originFrame.width - _arrowImageView.width/2.0 - cornerPadding)
            }
        }
        else{
            originFrame.origin.x = midX - halfWidth
        }
        
        var fromY = max(0, rect.midY)
        if fromY + originFrame.height < (superview?.height)! {
            
            setPopoverDirection(direction: .topTobottom)
            fromY = max(0, rect.maxY)
            originFrame.origin.y = fromY + 5

        }else{
            
            setPopoverDirection(direction: .bottomToTop)
            fromY = rect.minY - 5
            originFrame.origin.y = fromY - originFrame.height - popoverViewPadding
        }
        return originFrame
    }
    
    func dismiss() {
    
        self.isHidden = true
    }
}
