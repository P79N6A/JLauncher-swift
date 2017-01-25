//
//  JLModel.swift
//  JLauncher
//
//  Created by 谭建建 on 2017/1/15.
//  Copyright © 2017年 jtanisme. All rights reserved.
//

import UIKit
import MMWormhole

class JLModel: NSObject, NSCoding {

    var name:String = ""
    var url:String = ""
    var image:UIImage?
    var storeID:String?
    
    fileprivate static let JLUserDefaultsNameKey = "group.com.jtanisme.JLauncher"
    fileprivate static let JLUserDefaultsArrayKey = "group.com.jtanisme.widget.array"
    required init(name:String,url:String,image:UIImage?,storeID:String?) {
        super.init()
        self.name = name
        self.url = url
        self.image = image
        self.storeID = storeID
    }
    
    //MARK: - NSCoding -
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        url = aDecoder.decodeObject(forKey: "url") as? String ?? ""
        image = aDecoder.decodeObject(forKey: "image") as? UIImage
        storeID = aDecoder.decodeObject(forKey: "storeID") as? String
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(url, forKey: "url")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(storeID, forKey: "storeID")
    }
    
    private class func archiveModelArr(arr:[JLModel]) -> NSData {
        NSKeyedArchiver.setClassName("JLModel", for: JLModel.self)
        let archivedObject = NSKeyedArchiver.archivedData(withRootObject: arr as NSArray)
        return archivedObject as NSData
    }
    
    private class func unarchivedModelArr(unarchivedObject:Data) -> [JLModel]? {
        NSKeyedUnarchiver.setClass(JLModel.self, forClassName: "JLModel")
        let arr = NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject)
        let a = arr as? [JLModel]
        return a
    }

    class func saveModel(arr:[JLModel]) {
        let archivedObject = archiveModelArr(arr: arr)
        let wormhole = MMWormhole(applicationGroupIdentifier: JLUserDefaultsNameKey, optionalDirectory: "wormhole")
        wormhole.passMessageObject(archivedObject, identifier: JLUserDefaultsArrayKey)
    }
    
    class func retrieveModelArr() -> [JLModel]? {
        let wormhole = MMWormhole(applicationGroupIdentifier: JLUserDefaultsNameKey, optionalDirectory: "wormhole")
        if let unarchivedObject = wormhole.message(withIdentifier: JLUserDefaultsArrayKey)as? Data {
            return unarchivedModelArr(unarchivedObject: unarchivedObject)
        }
        return nil
    }
    
    class func getDefaultArr() -> [JLModel] {
        
        return [JLModel]()
    }
}
