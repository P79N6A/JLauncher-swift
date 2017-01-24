//
//  SystemTableVC.swift
//  JLauncher
//
//  Created by 谭建建 on 2017/1/23.
//  Copyright © 2017年 jtanisme. All rights reserved.
//

import UIKit
import SwiftyJSON

class SystemTableVC: BaseTableVC {

    private var _sysAppArray = [JLLocalModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(JLItemCell.self, forCellReuseIdentifier: JLItemCell.cellIdentifer())
        tableView.separatorStyle = .singleLine
        let path = Bundle.main.path(forResource: "SystemAppList", ofType: "plist") ?? ""
        if let dic = NSDictionary.init(contentsOfFile: path){
            let json = JSON(dic)
            for (key,subJson) in json {
                let model = JLLocalModel(key: key, json: subJson)
                _sysAppArray.append(model)
            }
        }
    }


    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return JLItemCell.cellHeight()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JLItemCell.cellIdentifer(), for: indexPath) as! JLItemCell
        let model = _sysAppArray[indexPath.row]
        cell.cellWithModel(model: model)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _sysAppArray.count
    }

    //MARK: tableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = _sysAppArray[indexPath.row]
        let mainStory = UIStoryboard.init(name: "Main", bundle: nil)
        let count = model.link?.count ?? 0
        if count == 1 {
            let editVC = mainStory.instantiateViewController(withIdentifier: "EditVC") as! EditVC
            editVC.localModel = model
            navigationController?.pushViewController(editVC, animated: true)
        }else if count > 1 {
            let detailTableVC = mainStory.instantiateViewController(withIdentifier: "DetailTableVC") as! DetailTableVC
            detailTableVC.localModel = model
            navigationController?.pushViewController(detailTableVC, animated: true)
        }

    }

}
