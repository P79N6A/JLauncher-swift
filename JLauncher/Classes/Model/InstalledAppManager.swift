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

class InstalledAppManager: NSObject {

    static let shared = InstalledAppManager()
    private var _installedArray = [JLLocalModel]()
    
    override init() {
        super.init()
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
            }
        }
    }
    
    private func downloadImage(model:JLLocalModel) {
        
        if let idString = model.id {
            
            if idString == "590338362" {
                NSLog(model.name + "590338362 \n ")
            }
            let urlStr = "http://itunes.apple.com/cn/lookup?id=" + idString
            Alamofire.request(urlStr).responseJSON(completionHandler: { response in
                
                switch response.result{
                case .success(let value):
                    let responseJson = JSON(value)
                    
                    let imageUrlStr = responseJson["results"][0]["artworkUrl512"].stringValue
                    
                    if idString == "590338362" {
                        NSLog(imageUrlStr + "\n " + (responseJson.rawString() ?? ""))
                    }
                    model.icon = imageUrlStr
                    self._installedArray.append(model)
                    self.retrieveImage(imageUrlStr: imageUrlStr, result: nil)
                case .failure( _):
                    break
                }
            })
        }
    }
    
    func retrieveImage(imageUrlStr: String, result:((_ image:UIImage)->())?) {
        if let imgUrl = URL(string: imageUrlStr){
            let res = ImageResource(downloadURL: imgUrl)
            KingfisherManager.shared.retrieveImage(with: res, options: nil, progressBlock: nil, completionHandler: { (img, error, type, url) in
                if let image = img {
                    result?(image)
                }else {
                    KingfisherManager.shared.downloader.downloadImage(with: imgUrl, options: nil, progressBlock: nil, completionHandler: { (img, error, url, data) in
                        if let image = img {
                            result?(image)
                            KingfisherManager.shared.cache.store(image, forKey: res.cacheKey)
                        }
                    })
                }
            })
        }
    }
    
    func appArray() -> [JLLocalModel] {
        var arr = [JLLocalModel]()
        arr.append(contentsOf: _installedArray)
        return arr
    }
}
