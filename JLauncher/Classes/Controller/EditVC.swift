//
//  EditVC.swift
//  JLauncher
//
//  Created by 谭建建 on 2017/1/15.
//  Copyright © 2017年 jtanisme. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import SwiftyJSON

class EditVC: UIViewController{

    @IBOutlet weak var appNameTextField: UITextField!
    @IBOutlet weak var storeIDTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var conformBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func conformClicked(_ sender: UIButton) {
        func saveToLocal(image:UIImage?) {
            let model = JLModel(name: appNameTextField.text ?? "",
                                url: urlTextField.text ?? "",
                                image: image,
                                storeID: storeIDTextField.text)
//            _allArray.append(model)
//            _addedArray.append(model)
//            tableView.reloadData()
        }
        if let idString = storeIDTextField.text {
            let urlStr = "http://itunes.apple.com/lookup?id=" + idString
            Alamofire.request(urlStr).responseJSON(completionHandler: { response in
                
                switch response.result{
                case .success(let value):
                    let responseJson = JSON(value)
                    let imageUrlStr = responseJson["results"][0]["artworkUrl512"].stringValue
                    if let url = URL(string: imageUrlStr){
                        KingfisherManager.shared.downloader.downloadImage(with: url, options: nil, progressBlock: nil, completionHandler: { (img, error, url, data) in
                            saveToLocal(image: img)
                        })
                    }else {
                        saveToLocal(image:nil)
                    }
                case .failure( _):
                    saveToLocal(image:nil)
                }
            })
        }else {
            saveToLocal(image:nil)
        }
        
    }
    
    
    //MARK: - Delegate
    
    func JLItemCellClicked(indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: JLItemCell.cellIdentifer(), for: indexPath) as! JLItemCell
//        let model = _allArray[indexPath.row]
//        cell.cellWithModel(model: model, isSelected: _addedArray.contains(model), indexPath: indexPath)
    }
    
}
