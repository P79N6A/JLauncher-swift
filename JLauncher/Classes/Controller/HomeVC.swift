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
    @IBOutlet weak var addBtn: UIButton!

    private var _array = [JLModel]()
    private var _editMode:JLIconCellEditMode = .normal
    
    private var _longPressRecongnizer:UILongPressGestureRecognizer?
    private var _currentDrapAndDropIndexPath:IndexPath?
    private var _currentDrapAndDropSnapshot:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBtn.layer.cornerRadius = addBtn.width/2
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.width-24)/5, height: (view.width-24)/5/5*6)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        collection.contentInset.left = 12
        collection.contentInset.right = 12

        collection.setCollectionViewLayout(layout, animated: false)
        collection.register(JLIconCell.self, forCellWithReuseIdentifier: JLIconCell.cellIdentifer())
        collection.delegate = self
        collection.dataSource = self
        _longPressRecongnizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressRecognizer(sender:)))
        collection.addGestureRecognizer(_longPressRecongnizer!)
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
        leftBtn.isHidden = true

        if let arr = JLModel.retrieveModelArr() {
            _array = arr
        }
        collection.reloadData()
    }
    
    func longPressRecognizer(sender:UILongPressGestureRecognizer) {
        let location = sender.location(in: collection)
        
        guard _editMode == .editing,
            let currentIndex = collection.indexPathForItem(at: location) else {
            return
        }
        switch sender.state {
        case .began:
            _currentDrapAndDropIndexPath = currentIndex
            let cell = collection.cellForItem(at: currentIndex) as? JLIconCell
            _currentDrapAndDropSnapshot = cell!.snapshot
            updateDrapAndDropSnapshotView(alpha: 0.0, center: cell!.center, transform: CGAffineTransform.identity)
            collection.addSubview(_currentDrapAndDropSnapshot!)
            UIView.animate(withDuration: 0.25, animations: {
                self.updateDrapAndDropSnapshotView(alpha: 0.95, center: cell!.center, transform: CGAffineTransform(scaleX: 1.05, y: 1.05))
                cell!.isMoving = true
            })
        case .changed:
            _currentDrapAndDropSnapshot?.center = location
            let sourceModel = _array[_currentDrapAndDropIndexPath!.item]
            _array.remove(at: _currentDrapAndDropIndexPath!.item)
            _array.insert(sourceModel, at: currentIndex.item)
            collection.moveItem(at: _currentDrapAndDropIndexPath!, to: currentIndex)
            _currentDrapAndDropIndexPath = currentIndex
        default:
            let cell = collection.cellForItem(at: currentIndex) as? JLIconCell
            UIView.animate(withDuration: 0.25, animations: {
                self.updateDrapAndDropSnapshotView(alpha: 0.0, center: cell!.center, transform: .identity)
            }, completion: {(finished) in
                cell!.isMoving = false
                self._currentDrapAndDropSnapshot?.removeFromSuperview()
                self._currentDrapAndDropSnapshot = nil
            })
            
        }
        
    }
    
    func updateDrapAndDropSnapshotView(alpha:CGFloat, center:CGPoint, transform:CGAffineTransform) {
        _currentDrapAndDropSnapshot?.alpha = alpha
        _currentDrapAndDropSnapshot?.center = center
        _currentDrapAndDropSnapshot?.transform = transform
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
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //MARK: Collection Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if _editMode != .editing, let url = URL(string:_array[indexPath.item].url) {
            UIApplication.shared.openURL(url)
        }
    }
}
