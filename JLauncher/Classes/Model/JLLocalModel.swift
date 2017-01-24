//
//  JLLocalModel.swift
//  JLauncher
//
//  Created by 谭建建 on 2017/1/24.
//  Copyright © 2017年 jtanisme. All rights reserved.
//

import UIKit
import SwiftyJSON

class JLLocalModel: NSObject {
    var name:String = ""
    var id:String?
    var link:[JLLinkModel]?
    var icon:String?
    
    init(key:String, json:JSON) {
        name = key
        id = json["id"].string
        icon = json["icon"].string
        link = [JLLinkModel]()
        for (_,subJson) in json["link"] {
            let model = JLLinkModel(json: subJson)
            link?.append(model)
        }
        
    }
}

class JLLinkModel: NSObject {
    var url:String?
    var name:String?
    var params:[JLLinkParamModel]?
    init(json:JSON) {
        url = json["url"].string
        name = json["name"].string
        params = [JLLinkParamModel]()
        for (_,subJson) in json["params"] {
            let model = JLLinkParamModel(json: subJson)
            params?.append(model)
        }
    }
}

class JLLinkParamModel: NSObject {
    var title:String?
    var key:String?
    var request:Bool?
    var action:String?
    
    init(json:JSON) {
        title = json["title"].string
        key = json["key"].string
        request = json["request"].bool
        action = json["action"].string
    }
}

