//
//  JLItemCell.swift
//  JLauncher
//
//  Created by 谭建建 on 2017/1/18.
//  Copyright © 2017年 jtanisme. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

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
        _imageView.setCornerRadius(_imageView.width/4)
        _imageView.setBorderColor(UIColor.black.withAlphaComponent(0.1))
        _imageView.setBorderWidth(0.5)
        addSubview(_imageView)
        
        _textLabel = UILabel(frame: CGRect(x: _imageView.right + 18, y: (cellHeight - 18)/2, width: _arrowImg.left - _imageView.right - 18, height: 18))
        _textLabel.textColor = UIColor.black
        _textLabel.font = UIFont.systemFont(ofSize: 15)
        addSubview(_textLabel)
    }
    
    func cellWithModel(model:JLLocalModel) {
        if let icon = model.icon {
            if let img = UIImage.init(named: icon) {
                _imageView.image = img
            }else if icon.hasPrefix("http") {
                InstalledAppManager.shared.retrieveImage(model:model, imageUrlStr: icon, result: { (model, imageUrlStr, image) in
                    if let img = image {
                        self._imageView.image = img
                    }else {
                        self._imageView.image = #imageLiteral(resourceName: "icon")
                    }
                })
            }else {
                self._imageView.image = #imageLiteral(resourceName: "icon")
            }
        }
        _textLabel.text = model.name
        _arrowImg.isHidden = model.link?.count == 1
    }
    
    class func cellHeight() -> CGFloat {
        return 66
    }
    
    class func cellIdentifer() -> String {
        return "kCell" + String(describing: JLItemCell.self)
    }
}
