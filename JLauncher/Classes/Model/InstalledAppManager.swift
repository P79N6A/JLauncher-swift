//
//  InstalledAppManager.swift
//  JLauncher
//
//  Created by 谭建建 on 2017/1/25.
//  Copyright © 2017年 jtanisme. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Kingfisher

protocol InstalledAppManagerProtocol:class {
    func firstScanFinished()
}

class InstalledAppManager: NSObject {

    static let shared = InstalledAppManager()
    weak var delegate:InstalledAppManagerProtocol?
    
    private var _installedArray = [JLLocalModel]()
    private(set) var isFisrtScan: Bool = false
    private var _isScanFinished:Bool = false
    
    private var _downloadCount:Int = 0
    private var _needDownArr = [String]()
    private var _saveArr = [JLModel]()
    
    override init() {
        super.init()
        isFisrtScan = JLModel.retrieveModelArr() == nil
        getInstalledApps()
    }
    
    private func getInstalledApps() {
        DispatchQueue.global().async {
            let path = Bundle.main.path(forResource: "AppList", ofType: "plist") ?? ""
            if let dic = NSDictionary.init(contentsOfFile: path){
                let json = JSON(dic)
                for (key,subJson) in json {
                    let model = JLLocalModel(key: key, json: subJson)
                    if let urlStr = model.link?.first?.url,
                        let url = URL(string:urlStr),
                        UIApplication.shared.canOpenURL(url) {
                        self.downloadImage(model: model)
                    }
                }
                self._isScanFinished = true
            }
        }
    }
    
    private func downloadImage(model:JLLocalModel) {
        
        if let idString = model.id {
            _downloadCount += 1

            let urlStr = "http://itunes.apple.com/cn/lookup?id=" + idString
            Alamofire.request(urlStr).responseJSON(completionHandler: { response in
                
                switch response.result{
                case .success(let value):
                    let responseJson = JSON(value)
                    
                    let imageUrlStr = responseJson["results"][0]["artworkUrl512"].stringValue//artworkUrl512//artworkUrl100//artworkUrl60
                    
                    model.icon = imageUrlStr
                    self._installedArray.append(model)
                    self._needDownArr.append(imageUrlStr)
                    
                    self.retrieveImage(model:model, imageUrlStr: imageUrlStr, result: { [unowned self] (model, imageUrlStr, image) in
                        
                        let jlModel = JLModel(name: model.name, url: model.link?[0].url ?? "", image: image, storeID: model.id)
                        self._saveArr.append(jlModel)
                        
                        if let index = self._needDownArr.index(of: imageUrlStr){
                            self._needDownArr.remove(at: index)
                        }
                        if self._downloadCount == self._installedArray.count
                            && self._isScanFinished
                            && self._needDownArr.count == 0
                        {
                            self.saveModelArr()
                        }
                    })
                case .failure( _):
                    self._installedArray.append(model)
                }
            })
        }
    }
    
    func retrieveImage(model:JLLocalModel, imageUrlStr: String,
                       result:((_ model:JLLocalModel, _ imageUrlStr: String, _ image:UIImage?)->())?) {
        if let imgUrl = URL(string: imageUrlStr){
            let res = ImageResource(downloadURL: imgUrl)
            KingfisherManager.shared.retrieveImage(with: res, options: nil, progressBlock: nil, completionHandler: { (img, error, type, url) in
                if let image = img {
                    result?(model, imageUrlStr, image)
                }else {
                    KingfisherManager.shared.downloader.downloadImage(with: imgUrl, options: nil, progressBlock: nil, completionHandler: { (img, error, url, data) in
                        result?(model, imageUrlStr, img)

                        if let image = img {
                            KingfisherManager.shared.cache.store(image, forKey: res.cacheKey)
                        }
                    })
                }
            })
        }
    }
    
    private func saveModelArr() {
        if isFisrtScan {
            JLModel.saveModel(arr: _saveArr)
            delegate?.firstScanFinished()
            isFisrtScan = false
        }
    }
    
    func appArray() -> [JLLocalModel] {
        var arr = [JLLocalModel]()
        arr.append(contentsOf: _installedArray)
        return arr
    }
}
