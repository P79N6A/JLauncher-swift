//
//  JLModel.swift
//  JLauncher
//
//  Created by 谭建建 on 2017/1/15.
//  Copyright © 2017年 jtanisme. All rights reserved.
//

import UIKit

class JLModel: NSObject, NSCoding {

    var name:String = ""
    var url:String = ""
    var image:UIImage?
    var storeID:String?
    
    private static let JLUserDefaultsNameKey = "group.com.kitty.JLauncher"
    private static let JLUserDefaultsArrayKey = "group.com.kitty.widget.array"
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
    
    private class func getImageFromLocal(model:JLModel) -> JLModel {
        //获得当前的组的路径
        if var groupPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: JLUserDefaultsNameKey){
            groupPath.appendPathComponent(model.name+(model.storeID ?? ""))
            if let data = try? Data(contentsOf: groupPath) {
                model.image = UIImage(data: data)
            }
        }
        return model
    }
    
    func copyModel() -> JLModel {
        let model = JLModel(name: name, url: url, image: image, storeID: storeID)
        return model
    }
    
    private class func saveImageToLocal(model:JLModel) {
        //获得当前的组的路径
        if var groupPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: JLUserDefaultsNameKey){
            groupPath.appendPathComponent(model.name+(model.storeID ?? ""))
            do{
                try? UIImageJPEGRepresentation(model.image!, 1.0)?.write(to: groupPath)
            }
        }
    }
    
    private class func archiveModelArr(arr:[JLModel]) -> NSData? {
        var archArr = [JLModel]()
        for model in arr {
            let archModel = model.copyModel()
            
            saveImageToLocal(model: archModel)
            archModel.image = nil
            archArr.append(archModel)
        }
        NSKeyedArchiver.setClassName("JLModel", for: JLModel.self)
        let archivedObject = NSKeyedArchiver.archivedData(withRootObject: archArr)
        return archivedObject as NSData
    }
    
    private class func unarchivedModelArr(unarchivedObject:Data) -> [JLModel] {

        var arr = [JLModel]()
        NSKeyedUnarchiver.setClass(JLModel.self, forClassName: "JLModel")
        let array = NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject) as! NSArray

        for item in array {
            if let model = item as? JLModel {
                let defModel = getImageFromLocal(model: model)
                arr.append(defModel)
            }
        }
        return arr
    }

    class func saveModel(arr:[JLModel]) {
        let archivedObject = archiveModelArr(arr: arr)
        let def = UserDefaults(suiteName: JLUserDefaultsNameKey)
        def?.set(archivedObject, forKey: JLUserDefaultsArrayKey)
        
    }
    
    class func retrieveModelArr() -> [JLModel]? {
        let def = UserDefaults(suiteName: JLUserDefaultsNameKey)
        if let unarchivedObject = def?.data(forKey: JLUserDefaultsArrayKey){
            let arr = unarchivedModelArr(unarchivedObject: unarchivedObject)
            return arr
        }
        return nil
    }
}
