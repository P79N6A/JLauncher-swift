//
//  CustomTableVC.swift
//  JLauncher
//
//  Created by 谭建建 on 2017/1/23.
//  Copyright © 2017年 jtanisme. All rights reserved.
//

import UIKit

class CustomTableVC: UITableViewController {
    private var _userDefault:UserDefaults!
    
    private var _addedArray = [JLModel]()
    private var _allArray = [JLModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(JLItemCell.self, forCellReuseIdentifier: JLItemCell.cellIdentifer())

        if let arr = JLModel.retrieveModelArr(key: JLUserDefaultsArrayKey){
            _allArray = arr
        }
        if let arr = JLModel.retrieveModelArr(key: JLUserDefaultsAddedArrayKey) {
            _addedArray = arr
        }
        tableView.reloadData()
    }
    
    // MARK: - Delegate
    
    // MARK: Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JLItemCell.cellIdentifer(), for: indexPath) as! JLItemCell
        let model = _allArray[indexPath.row]
        cell.cellWithModel(model: model, isSelected: _addedArray.contains(model), indexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _addedArray.count
    }
    
    //MARK: tableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        JLItemCellClicked(indexPath: indexPath)
    }


}
