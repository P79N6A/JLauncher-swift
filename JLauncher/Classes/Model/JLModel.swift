//
//  JLModel.swift
//  JLauncher
//
//  Created by 谭建建 on 2017/1/15.
//  Copyright © 2017年 jtanisme. All rights reserved.
//

import UIKit
let JLUserDefaultsArrayKey = "group.com.jtanisme.widget.array"
let JLUserDefaultsAddedArrayKey = "group.com.jtanisme.widget.added.array"

class JLModel: NSObject, NSCoding {

    var name:String = ""
    var url:String = ""
    var image:UIImage?
    var storeID:String?
    
    fileprivate static let JLUserDefaultsNameKey = "group.com.jtanisme.widget"
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
        
        let archivedObject = NSKeyedArchiver.archivedData(withRootObject: arr as NSArray)
        return archivedObject as NSData
    }
    
    private class func unarchivedModelArr(unarchivedObject:Data) -> [JLModel]? {
        return NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject) as? [JLModel]
    }

    class func saveModel(arr:[JLModel], key:String) {
        let archivedObject = archiveModelArr(arr: arr)
        let defaults = UserDefaults(suiteName: JLUserDefaultsNameKey)
        defaults?.set(archivedObject, forKey: key)
        defaults?.synchronize()
    }
    
    class func retrieveModelArr(key:String) -> [JLModel]? {
        let defaults = UserDefaults(suiteName: JLUserDefaultsNameKey)
        if let unarchivedObject = defaults?.object(forKey: key) as? Data {
            return unarchivedModelArr(unarchivedObject: unarchivedObject)
        }
        return nil
    }
    
    class func getDefaultArr() -> [JLModel] {
        
        return [JLModel]()
    }
}
