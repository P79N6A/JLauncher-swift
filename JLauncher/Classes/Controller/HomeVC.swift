//
//  HomeVC.swift
//  JLauncher
//
//  Created by 大鹏 on 2016/11/22.
//  Copyright © 2016年 jtanisme. All rights reserved.
//

import UIKit

class HomeVC: BaseVC, UICollectionViewDelegate, UICollectionViewDataSource, JLIconCellProtocol{

    @IBOutlet weak var collection: UICollectionView!
    private var _array = [JLModel]()
    private var _editMode:JLIconCellEditMode = .normal
    
    private var _userDefault:UserDefaults? = nil
    
    @IBOutlet weak var addBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftBtn.isHidden = true
        addBtn.layer.cornerRadius = addBtn.width/2
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.width-24)/6, height: (view.width-24)/6/5*7)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        collection.contentInset.left = 12
        collection.contentInset.right = 12

        collection.setCollectionViewLayout(layout, animated: false)
        collection.register(JLIconCell.self, forCellWithReuseIdentifier: JLIconCell.cellIdentifer())
        collection.delegate = self
        collection.dataSource = self
    }

    override func setRightBtnImage() {
        rightBtn.setImage(#imageLiteral(resourceName: "nav_edit").withRenderingMode(.alwaysOriginal), for: .normal)
        rightBtn.setImage(#imageLiteral(resourceName: "nav_done").withRenderingMode(.alwaysOriginal), for: .selected)
    }
    
    override func rightBtnClicked() {
        if _editMode == .editing {
            _editMode = .normal
            JLModel.saveModel(arr: _array)
        }else{
            _editMode = .editing
        }
        rightBtn.isSelected = _editMode == .editing
        collection.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let arr = JLModel.retrieveModelArr() {
            _array = arr
        }
        collection.reloadData()
    }
    
    //MARK: - Delegate
    
    internal func JLIconCellDeleteClicked(indexPath:IndexPath) {
        _array.remove(at: indexPath.item)
        collection.reloadData()
    }

    //MARK: Collection DataSource
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JLIconCell.cellIdentifer(), for: indexPath) as! JLIconCell
        cell.cellWithModel(model: _array[indexPath.item], editMode: _editMode, indexPath:indexPath)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _array.count
    }
    
    //MARK: Collection Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if _editMode != .editing, let url = URL(string:_array[indexPath.item].url) {
            UIApplication.shared.openURL(url)
        }
    }
}
