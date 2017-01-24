//
//  DetailTableVC.swift
//  JLauncher
//
//  Created by 谭建建 on 2017/1/24.
//  Copyright © 2017年 jtanisme. All rights reserved.
//

import UIKit

class DetailTableVC: BaseTableVC {
    var localModel:JLLocalModel?
    private var _detailArray = [JLLinkModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(JLItemDetailCell.self, forCellReuseIdentifier: JLItemDetailCell.cellIdentifer())
        if let arr = localModel?.link {
            _detailArray = arr
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return JLItemDetailCell.cellHeight()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JLItemDetailCell.cellIdentifer(), for: indexPath) as! JLItemDetailCell
        let model = _detailArray[indexPath.row]
        cell.cellWithModel(model: model)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _detailArray.count
    }
    
    //MARK: tableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let mainStory = UIStoryboard.init(name: "Main", bundle: nil)
        let editVC = mainStory.instantiateViewController(withIdentifier: "EditVC") as! EditVC
        editVC.localModel = localModel
        editVC.linkIndex = indexPath.row
        navigationController?.pushViewController(editVC, animated: true)
    }
}
