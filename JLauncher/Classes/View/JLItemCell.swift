//
//  JLItemCell.swift
//  JLauncher
//
//  Created by 谭建建 on 2017/1/18.
//  Copyright © 2017年 jtanisme. All rights reserved.
//

import UIKit

class JLItemCell: UITableViewCell {
    
    private var _arrowImg:UIImageView!
    private var _imageView:UIImageView!
    private var _textLabel:UILabel!
    
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
        let cellHeight = JLItemCell.cellHeight()
        
        _arrowImg = UIImageView(frame: CGRect(x: ScreenWidth - 15 - 12, y: (cellHeight - 15)/2, width: 15, height: 15))
        _arrowImg.image = #imageLiteral(resourceName: "cell_arrows")
        addSubview(_arrowImg)
        
        _imageView = UIImageView(frame: CGRect(x: 18, y: 6, width: cellHeight - 12, height: cellHeight - 12))
        _imageView.setCornerRadius(4)
        addSubview(_imageView)
        
        _textLabel = UILabel(frame: CGRect(x: _imageView.right + 18, y: (cellHeight - 15)/2, width: _arrowImg.left - _imageView.right - 18, height: 15))
        _textLabel.textColor = UIColor.black
        _textLabel.font = UIFont.systemFont(ofSize: 12)
        addSubview(_textLabel)
    }
    
    func cellWithModel(model:JLLocalModel) {
        _imageView.image = UIImage.init(named: model.icon ?? "")
        _textLabel.text = model.name
        _arrowImg.isHidden = model.link?.count == 1
    }
    
    class func cellHeight() -> CGFloat {
        return 46
    }
    
    class func cellIdentifer() -> String {
        return "kCell" + String(describing: JLItemCell.self)
    }
}
