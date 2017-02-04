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
import AVFoundation
import AssetsLibrary
import Photos

class EditVC: BaseVC, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var appNameTextField: UITextField!
    @IBOutlet weak var storeIDTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var conformBtn: UIButton!
    
    var localModel:JLLocalModel?
    var modifyModel:JLModel?
    
    var linkIndex = 0
    var imagePicker: UIImagePickerController!
    var isImageChanged = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconImg.setCornerRadius(iconImg.width/4)
        iconImg.setBorderColor(UIColor.black.withAlphaComponent(0.1))
        iconImg.setBorderWidth(0.5)
        
        iconImg.whenTapped(target: self, action: #selector(showActionSheet))
        
        if let model = localModel {
            if let icon = model.icon {
                if let img = UIImage.init(named: icon) {
                    iconImg.image = img
                }else if icon.hasPrefix("http") {
                    InstalledAppManager.shared.retrieveImage(model:model, imageUrlStr: icon, result: { (model, imageUrlStr, image) in
                        self.iconImg.image = image ?? #imageLiteral(resourceName: "icon")
                    })
                }else {
                    iconImg.image = #imageLiteral(resourceName: "icon")
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
        }else if let model = modifyModel {
            iconImg.image = model.image ?? #imageLiteral(resourceName: "icon")
            appNameTextField.text = model.name
            storeIDTextField.text = model.storeID
            urlTextField.text = model.url
        }
    }
    
    @IBAction func conformClicked(_ sender: UIButton) {
        func saveToLocal(image:UIImage?) {
            let model = JLModel(name: appNameTextField.text ?? "",
                                url: urlTextField.text ?? "",
                                image: image,
                                storeID: storeIDTextField.text)
            if var array = JLModel.retrieveModelArr() {
                if let oldModel = modifyModel {
                    var index = 0
                    for item in array {
                        if item.name == oldModel.name
                            && item.storeID == oldModel.storeID
                            && item.url == oldModel.url
                        {
                            array[index] = model
                        }
                        index += 1
                    }
                } else {
                    array.append(model)
                }
                JLModel.saveModel(arr: array)
            }else {
                
                JLModel.saveModel(arr: [model])
            }
            _ = navigationController?.popToRootViewController(animated: true)
        }
        if isImageChanged {
            if let img = iconImg.image {
                saveToLocal(image:img)
            }
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
                    }else if let img = self.iconImg.image {
                        saveToLocal(image:img)
                    }
                case .failure( _):
                    if let img = self.iconImg.image {
                        saveToLocal(image:img)
                    }
                }
            })
        }
    }
    
    func showActionSheet() {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        let sheetVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheetVC.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self](action) in
            let avAuthStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
            if self != nil && (avAuthStatus == .authorized) {
                self?.imagePicker.sourceType = .camera
                self?.present(self!.imagePicker, animated: true, completion: nil)
            }
        }))
        sheetVC.addAction(UIAlertAction(title: "Picture", style: .default, handler: { [weak self](action) in
            if self != nil && PHPhotoLibrary.authorizationStatus() == .authorized {
                self?.imagePicker.sourceType = .photoLibrary
                self?.present(self!.imagePicker, animated: true, completion: nil)
            }
        }))
        sheetVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(sheetVC, animated: true, completion: nil)
    }
    
    //MARK: - Delegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        iconImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        isImageChanged = true
    }
}
