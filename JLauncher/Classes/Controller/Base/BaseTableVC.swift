//
//  BaseTableVC.swift
//  JLauncher
//
//  Created by 谭建建 on 2017/1/24.
//  Copyright © 2017年 jtanisme. All rights reserved.
//

import UIKit

class BaseTableVC: UITableViewController, UIGestureRecognizerDelegate {
    
    var leftBtn:UIButton!
    var rightBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLeftBtn()
        initRightBtn()
    }
    
    private func initLeftBtn() {
        leftBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        leftBtn.setImage(#imageLiteral(resourceName: "nav_back").withRenderingMode(.alwaysOriginal), for: .normal)
        leftBtn.contentHorizontalAlignment = .center
        leftBtn.addTarget(self, action: #selector(leftBtnClicked), for: .touchUpInside)
        let leftItem = UIBarButtonItem(customView: leftBtn)
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -15
        
        navigationItem.leftBarButtonItems = [negativeSpacer,leftItem]
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func initRightBtn() {
        rightBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightBtn.contentHorizontalAlignment = .center
        setRightBtnImage()
        rightBtn.addTarget(self, action: #selector(rightBtnClicked), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: rightBtn)
        navigationController?.navigationBar.items?.first?.setRightBarButton(rightItem, animated: true)
    }
    
    func setRightBtnImage() {}
    
    func leftBtnClicked() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func rightBtnClicked() {}
}
