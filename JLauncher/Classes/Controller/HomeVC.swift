//
//  HomeVC.swift
//  JLauncher
//
//  Created by 大鹏 on 2016/11/22.
//  Copyright © 2016年 jtanisme. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, JLIconCellProtocol{

    @IBOutlet weak var collection: UICollectionView!
    private var _array = [JLModel]()
    private var _editMode:JLIconCellEditMode = .normal
    
    private var _userDefault:UserDefaults? = nil
    
    @IBOutlet weak var addBtn: UIButton!
    private var _rightBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initRightBtn()
        addBtn.layer.cornerRadius = addBtn.width/2
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.width/6, height: view.width/6/5*7)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        collection.setCollectionViewLayout(layout, animated: false)
        collection.register(JLIconCell.self, forCellWithReuseIdentifier: JLIconCell.cellIdentifer())
        collection.delegate = self
        collection.dataSource = self
        if let arr = JLModel.retrieveModelArr(key: JLUserDefaultsAddedArrayKey) {
            _array = arr
        }
        collection.reloadData()
    }

    private func initRightBtn() {
        _rightBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        _rightBtn.setImage(#imageLiteral(resourceName: "nav_edit").withRenderingMode(.alwaysOriginal), for: .normal)
        _rightBtn.setImage(#imageLiteral(resourceName: "nav_done").withRenderingMode(.alwaysOriginal), for: .selected)
        _rightBtn.contentHorizontalAlignment = .center
        _rightBtn.addTarget(self, action: #selector(editBtnClicked), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: _rightBtn)
        navigationController?.navigationBar.items?.first?.setRightBarButton(rightItem, animated: true)
    }
    @objc private func editBtnClicked() {
        if _editMode == .editing {
            _editMode = .normal
        }else{
            _editMode = .editing
        }
        _rightBtn.isSelected = _editMode == .editing
        collection.reloadData()
    }
    
    //MARK: - Delegate
    
    internal func JLIconCellDeleteClicked(indexPath:IndexPath) {
        _array.remove(at: indexPath.item)
        _userDefault?.setValue(_array, forKey: JLUserDefaultsAddedArrayKey)
        _userDefault?.synchronize()
    }

    //MARK: Collection DataSource
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JLIconCell.cellIdentifer(), for: indexPath) as! JLIconCell
        cell.cellWithModel(model: _array[indexPath.item], editMode: _editMode, indexPath:indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _array.count
    }
    
    //MARK: Collection Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
