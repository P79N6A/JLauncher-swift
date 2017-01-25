//
//  JLIconCell.swift
//  JLauncher
//
//  Created by 谭建建 on 2017/1/17.
//  Copyright © 2017年 jtanisme. All rights reserved.
//

import UIKit
import Kingfisher

enum JLIconCellEditMode:Int {
    case editing,normal
}

protocol JLIconCellProtocol:class {
    func JLIconCellDeleteClicked(indexPath:IndexPath)
}

class JLIconCell: UICollectionViewCell {
    
    public weak var delegate:JLIconCellProtocol?
    
    private var _deleteBtn:UIButton!
    private var _imageView:UIImageView!
    private var _textLabel:UILabel!
    
    private var _indexPath:IndexPath!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }
    
    private func initViews() {
        _imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: width-20, height: width-20))
        _imageView.setCornerRadius(4)
        addSubview(_imageView)
        _textLabel = UILabel(frame: CGRect(x: 0, y: _imageView.bottom, width: width, height: height-_imageView.height))
        _textLabel.textColor = UIColor.black
        _textLabel.textAlignment = .center
        _textLabel.font = UIFont.systemFont(ofSize: 10)
        addSubview(_textLabel)
        
        _deleteBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 21, height: 21))
        _deleteBtn.addTarget(self, action: #selector(deleteClicked), for: .touchUpInside)
        _deleteBtn.setImage(#imageLiteral(resourceName: "action_delete"), for: .normal)
        _deleteBtn.isHidden = true
        addSubview(_deleteBtn)
    }
    
    @objc private func deleteClicked() {
        delegate?.JLIconCellDeleteClicked(indexPath: _indexPath)
    }
    
    func cellWithModel(model:JLModel,editMode:JLIconCellEditMode, indexPath:IndexPath) {
        _indexPath = indexPath
        _deleteBtn.isHidden = editMode != .editing
        _imageView.image = model.image
        _textLabel.text = model.name
    }
    
    class func cellIdentifer() -> String {
        return "kCell" + String(describing: JLIconCell.self)
    }
}
