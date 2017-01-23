//
//  JLItemCell.swift
//  JLauncher
//
//  Created by 谭建建 on 2017/1/18.
//  Copyright © 2017年 jtanisme. All rights reserved.
//

import UIKit

protocol JLItemCellProtocol:class {
    func JLItemCellClicked(indexPath:IndexPath)
}

class JLItemCell: UITableViewCell {
    
    public weak var delegate:JLItemCellProtocol?

    private var _btn:UIButton!
    private var _imageView:UIImageView!
    private var _textLabel:UILabel!
    
    private var _indexPath:IndexPath!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }
    
    private func initViews() {
        self.selectionStyle = UITableViewCellSelectionStyle.none
        _btn = UIButton(frame: CGRect(x: width - 16 - 12, y: (height - 16)/2, width: 16, height: 16))
        _btn.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)
        _btn.setImage(#imageLiteral(resourceName: "btn_uncheck"), for: .normal)
        addSubview(_btn)
        _imageView = UIImageView(frame: CGRect(x: 12, y: 4, width: height - 8, height: height - 8))
        _imageView.setCornerRadius(4)
        addSubview(_imageView)
        
        _textLabel = UILabel(frame: CGRect(x: _imageView.right + 8, y: (height - 15)/2, width: _btn.left - _imageView.right - 16, height: 15))
        _textLabel.textColor = UIColor.black
        _textLabel.font = UIFont.systemFont(ofSize: 12)
        addSubview(_textLabel)
    }
    
    @objc private func btnClicked() {
        _btn.isSelected = !_btn.isSelected
        delegate?.JLItemCellClicked(indexPath: _indexPath)
    }
    
    func cellWithModel(model:JLModel, isSelected: Bool, indexPath:IndexPath) {
        _btn.isSelected = isSelected
        _indexPath = indexPath
        _imageView.image = model.image
        _textLabel.text = model.name
    }
    
    class func cellIdentifer() -> String {
        return "kCell" + String(describing: JLItemCell.self)
    }
}
