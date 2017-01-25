//
//  TodayViewController.swift
//  extension
//
//  Created by 大鹏 on 2016/11/28.
//  Copyright © 2016年 jtanisme. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, UICollectionViewDelegate, UICollectionViewDataSource {
        
    var collectionView: UICollectionView!
    
    private var _list = [JLModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(JLIconCell.self, forCellWithReuseIdentifier: JLIconCell.cellIdentifer())
        if #available(iOSApplicationExtension 10.0, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
        } else {
            // Fallback on earlier versions
        }
        if let arr = JLModel.retrieveModelArr() {
            _list = arr
        }
        collectionView.reloadData()

    }
    
    //MARK: - delegate
    
    //MARK: NCWidgetProviding
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        
        if (activeDisplayMode == NCWidgetDisplayMode.compact) {
            self.preferredContentSize = CGSize(width: maxSize.width, height: (maxSize.width-24)/5)
        }
        else {
            let num:CGFloat = ((_list.count % 5) == 0 ? 0 : 1)
            
            let count:CGFloat = CGFloat(_list.count/5) + num
            let height = count*((maxSize.width-24)/5/5*6)
            self.preferredContentSize = CGSize(width: maxSize.width, height: height)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (preferredContentSize.width-24)/5, height: (preferredContentSize.width-24)/5/5*6)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.size = preferredContentSize
        collectionView.reloadData()
    }
    //MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = URL(string:_list[indexPath.item].url) {
            extensionContext?.open(url, completionHandler: nil)
        }
    }
    
    //MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JLIconCell.cellIdentifer(), for: indexPath) as! JLIconCell
        cell.cellWithModel(model: _list[indexPath.item], editMode: .normal, indexPath:indexPath)
        return cell
    }
}
