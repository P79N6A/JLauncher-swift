//
//  JLItemCell.swift
//  JLauncher
//
//  Created by 谭建建 on 2017/1/18.
//  Copyright © 2017年 jtanisme. All rights reserved.
//

import UIKit

class JLItemDetailCell: UITableViewCell {
    
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
        
        _textLabel = UILabel(frame: CGRect(x: 18, y: (cellHeight - 15)/2, width: ScreenWidth - 18, height: 15))
        _textLabel.textColor = UIColor.black
        _textLabel.font = UIFont.systemFont(ofSize: 12)
        addSubview(_textLabel)
    }
    
    func cellWithModel(model:JLLinkModel) {
        _textLabel.text = model.name
    }
    
    class func cellHeight() -> CGFloat {
        return 46
    }
    
    class func cellIdentifer() -> String {
        return "kCell" + String(describing: JLItemDetailCell.self)
    }
}
