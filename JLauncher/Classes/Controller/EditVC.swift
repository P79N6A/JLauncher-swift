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

class EditVC: BaseVC{

    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var appNameTextField: UITextField!
    @IBOutlet weak var storeIDTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var conformBtn: UIButton!
    
    var localModel:JLLocalModel?
    var linkIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        if let model = localModel {
            iconImg.setCornerRadius(iconImg.width/4)
            iconImg.setBorderColor(UIColor.black.withAlphaComponent(0.1))
            iconImg.setBorderWidth(0.5)
            if let icon = model.icon {
                if let img = UIImage.init(named: icon) {
                    iconImg.image = img
                }else if icon.hasPrefix("http") {
                    InstalledAppManager.shared.retrieveImage(imageUrlStr: icon, result: { (image) in
                        self.iconImg.image = image
                    })
                }
            }
            appNameTextField.text = model.name
            storeIDTextField.text = model.id
            if linkIndex == 0 {
                urlTextField.text = model.link?.first?.url
            }else {
                let linkModel = model.link?[linkIndex]
                appNameTextField.text = linkModel?.name
                urlTextField.text = linkModel?.url
            }
        }
    }
    
    @IBAction func conformClicked(_ sender: UIButton) {
        func saveToLocal(image:UIImage?) {
            let model = JLModel(name: appNameTextField.text ?? "",
                                url: urlTextField.text ?? "",
                                image: image,
                                storeID: storeIDTextField.text)
            if var array = JLModel.retrieveModelArr() {
                array.append(model)
                JLModel.saveModel(arr: array)
            }else {
                JLModel.saveModel(arr: [model])
            }
            _ = navigationController?.popToRootViewController(animated: true)
        }
        if let img = iconImg.image {
            saveToLocal(image:img)
        } else if let idString = storeIDTextField.text{
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
        }
        
    }
}
