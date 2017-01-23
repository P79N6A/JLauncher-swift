//
//  UIView.swift
//  MGA_IOS
//
//  Created by adolph on 2016/12/20.
//  Copyright © 2016年 www.newborn-town.com. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Frame

public extension UIView {
    
    var origin:CGPoint {
        get {
            return self.frame.origin
        }
        set(aPoint) {
            var newframe = self.frame
            newframe.origin = aPoint
            self.frame = newframe
        }
    }
    
    var size:CGSize {
        get{
            return self.frame.size
        }
        set(aSize) {
            if aSize.width < 0 || aSize.height < 0 {
                return
            }
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: aSize.width, height: aSize.height)
        }
    }
    
    var height:CGFloat {
        get {
            return self.frame.size.height
        }
        set(newheight){
            if newheight < 0 {
                return
            }
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: newheight)
        }
    }
    
    var width:CGFloat {
        get{
            return self.frame.size.width
        }
        
        set(newwidth){
            if newwidth < 0 {
                return
            }
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: newwidth, height: self.frame.size.height)
        }
    }
    
    var top:CGFloat {
        get {
            return self.frame.origin.y
        }
        set(newtop){
            self.frame = CGRect(x: self.frame.origin.x, y: newtop, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    
    var left: CGFloat {
        get{
            return self.frame.origin.x
        }
        set(newleft){
            self.frame = CGRect(x: newleft, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    
    var bottom: CGFloat{
        get{
            return self.frame.origin.y + self.frame.size.height
        }
        set(newbottom) {
            let y = newbottom - self.frame.size.height
            self.frame = CGRect(x: self.frame.origin.x, y: y, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    
    var right: CGFloat {
        get{
            return self.frame.origin.x + self.frame.size.width
        }
        set(newright) {
            let x = newright - self.frame.size.width
            self.frame = CGRect(x: x, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    
    
    var originX: CGFloat {
        get{
            return self.frame.origin.x
        }
        set(originX) {
            self.frame = CGRect(x: originX, y: self.originY, width: self.width, height: self.height)
        }
    }
    
    var originY:CGFloat {
        get{
            
            return self.frame.origin.y
        }
        set(originY) {
            self.frame = CGRect(x: self.originX, y: originY, width: self.width, height: self.height)
        }
    }
}

// MARK: - LineView

public extension UIView {
    
    func addSeparatorLine(_ beginPoint:CGPoint,
                          endPoint: CGPoint,
                          withCololr: UIColor,
                          withHeight: CGFloat) -> UIView {
        let lineView = UIView(frame: CGRect(x: beginPoint.x, y: beginPoint.y - withHeight, width: endPoint.x-beginPoint.x, height: withHeight))
        lineView.backgroundColor = withCololr
        lineView.autoresizingMask = [.flexibleLeftMargin,.flexibleWidth]
        self.addSubview(lineView)
        return lineView
    }
    
    func addSeparatorLine(_ pos: CGPoint, withCololr: UIColor) -> UIView {
        let hight:CGFloat = 1.0/2.0
        
        return self.addSeparatorLine(pos, withCololr:withCololr, withHeight:hight)
    }
    
    func addSeparatorLine(_ pos: CGPoint, withCololr: UIColor, withHeight: CGFloat) -> UIView {
        return self.addSeparatorLine(pos,
                                     endPoint:CGPoint(x: self.width-pos.x*2, y: pos.y),
                                     withCololr:withCololr,
                                     withHeight:withHeight)
    }
    
}


// MARK: - Xib

public extension UIView {
    
    func setCornerRadius(_ cornerRadius: CGFloat) {
        self.layer.cornerRadius  = cornerRadius
        self.layer.masksToBounds = true
    }
    
    func setBorderColor(_ bcolor: UIColor){
        self.layer.borderColor = bcolor.cgColor
    }
    
    func setBorderWidth(_ bwidth: CGFloat) {
        self.layer.borderWidth = bwidth
    }
    
}

// MARK: - TAP


extension UIView: UIGestureRecognizerDelegate {
    
    typealias UIViewTapBlock = @convention(block)()->()
    
    fileprivate struct TapAssociatedKeys {
        static var kWhenLongPressBlockKey = "kWhenLongPressBlockKey"
        static var kWhenTappedBlockKey = "kWhenTappedBlockKey"
        static var kWhenDoubleTappedBlockKey = "kWhenDoubleTappedBlockKey"
        static var kWhenTwoFingerTappedBlockKey = "kWhenTwoFingerTappedBlockKey"
        static var kWhenTouchedDownBlockKey = "kWhenTouchedDownBlockKey"
        static var kWhenTouchedUpBlockKey = "kWhenTouchedUpBlockKey"
    }
    
    // Set blocks
    
    func runBlockForKey(_ blockKey:UnsafeRawPointer) {
        if let tapBlock = objc_getAssociatedObject(self, blockKey){
            let block = unsafeBitCast(tapBlock, to: UIViewTapBlock.self)
            block()
        }
    }
    
    func setBlock(_ tapBlock:UIViewTapBlock, blockKey:UnsafeRawPointer) {
        self.isUserInteractionEnabled = true
        objc_setAssociatedObject(self, blockKey, unsafeBitCast(tapBlock, to: AnyObject.self), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    
    //When Tapped
    
    func whenTapped(_ block:(()->())) {
        let gesture = self.addTapGestureRecognizerWithTaps(1, touches:1, selector:#selector(viewWasTapped))
        self.addRequiredToDoubleTapsRecognizer(gesture)
        self.setBlock(block, blockKey: &TapAssociatedKeys.kWhenTappedBlockKey)
    }
    
    func whenLongPress(_ block:(()->())) {
        
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(viewWasLongPress))
        longPress.delegate = self;
        self.addGestureRecognizer(longPress)
        self.setBlock(block, blockKey:&TapAssociatedKeys.kWhenLongPressBlockKey)
    }
    
    public func removeLongPress() {
        
        guard let array = self.gestureRecognizers else {
            return
        }
        
        for gesture in array {
            if gesture is UILongPressGestureRecognizer {
                self.removeGestureRecognizer(gesture)
            }
        }
    }
    
    // Callbacks
    
    func viewWasTapped() {
        self.runBlockForKey(&TapAssociatedKeys.kWhenTappedBlockKey)
    }
    
    func viewWasLongPress() {
        self.runBlockForKey(&TapAssociatedKeys.kWhenLongPressBlockKey)
    }
    
    func viewWasDoubleTapped() {
        self.runBlockForKey(&TapAssociatedKeys.kWhenDoubleTappedBlockKey)
    }
    
    func viewWasTwoFingerTapped() {
        self.runBlockForKey(&TapAssociatedKeys.kWhenTwoFingerTappedBlockKey)
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.runBlockForKey(&TapAssociatedKeys.kWhenTouchedDownBlockKey)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.runBlockForKey(&TapAssociatedKeys.kWhenTouchedUpBlockKey)
    }
    
    // Helpers
    
    func addTapGestureRecognizerWithTaps(_ taps:Int, touches:Int, selector:Selector) -> UITapGestureRecognizer {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: selector)
        tapGesture.delegate = self
        tapGesture.numberOfTapsRequired = taps
        tapGesture.numberOfTouchesRequired = touches
        self.addGestureRecognizer(tapGesture)
        
        return tapGesture
    }
    
    func addRequirementToSingleTapsRecognizer(_ recognizer: UIGestureRecognizer) {
        guard let gests = self.gestureRecognizers else {
            return
        }
        for gesture in gests {
            if (gesture is UITapGestureRecognizer) {
                let tapGesture = gesture as! UITapGestureRecognizer
                if (tapGesture.numberOfTouchesRequired == 1 && tapGesture.numberOfTapsRequired == 1) {
                    recognizer.require(toFail: recognizer)
                }
            }
        }
    }
    
    func addRequiredToDoubleTapsRecognizer(_ recognizer:UIGestureRecognizer) {
        guard let gests = self.gestureRecognizers else {
            return
        }
        for gesture in gests {
            if (gesture is UITapGestureRecognizer) {
                let tapGesture = gesture as! UITapGestureRecognizer
                if (tapGesture.numberOfTouchesRequired == 2 && tapGesture.numberOfTapsRequired == 1) {
                    recognizer.require(toFail: tapGesture)
                }
            }
        }
    }
}

// MARK: - Loading

public extension UIView {
    fileprivate struct LoadingAssociatedKeys {
        static var kUIViewIndicatorLoadingView = "kUIViewIndicatorLoadingView"
    }
    
    func startLoading() -> UIActivityIndicatorView {
        let indicator =  objc_getAssociatedObject(self, &LoadingAssociatedKeys.kUIViewIndicatorLoadingView)
        
        var indicatorLoadingView:UIActivityIndicatorView!
        if (indicator == nil) {
            
            indicatorLoadingView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
            indicatorLoadingView.center = CGPoint(x: self.width/2, y: self.height/2)
            self.addSubview(indicatorLoadingView)
            indicatorLoadingView.startAnimating()
            
            objc_setAssociatedObject(self,
                                     &LoadingAssociatedKeys.kUIViewIndicatorLoadingView,
                                     indicatorLoadingView,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
        }else if ( indicator is UIActivityIndicatorView) {
            indicatorLoadingView = indicator as! UIActivityIndicatorView
            indicatorLoadingView.startAnimating()
        }
        return indicatorLoadingView
    }
    
    func stopLoading() {
        let indicatorLoadingView =  objc_getAssociatedObject(self, &LoadingAssociatedKeys.kUIViewIndicatorLoadingView)
        
        if (indicatorLoadingView != nil && indicatorLoadingView is UIActivityIndicatorView) {
            (indicatorLoadingView as! UIActivityIndicatorView).stopAnimating()
        }
    }
    
}

// MARK: - bindData

public extension UIView {
    
    //清除
    public func removeAllSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
}

// MARK: - screenShot

public extension UIView {
    
    func convertViewToImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.frame.size,false,0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    public func screenShot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}

