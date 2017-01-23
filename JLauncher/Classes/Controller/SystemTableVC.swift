//
//  SystemTableVC.swift
//  JLauncher
//
//  Created by 谭建建 on 2017/1/23.
//  Copyright © 2017年 jtanisme. All rights reserved.
//

import UIKit

class SystemTableVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: JLItemCell.cellIdentifer(), for: indexPath) as! JLItemCell
//        let model = _allArray[indexPath.row]
//        cell.cellWithModel(model: model, isSelected: _addedArray.contains(model), indexPath: indexPath)
//        cell.delegate = self
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return _addedArray.count
//    }
//    
//    //MARK: tableView Delegate
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        JLItemCellClicked(indexPath: indexPath)
//    }

}
