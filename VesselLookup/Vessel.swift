//
//  Vessel.swift
//  VesselLookup
//
//  Created by Robert Linnemann on 4/23/16.
//  Copyright © 2016 Epistrophy. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftCSV

class Vessel: Object {
    dynamic var name = ""
    dynamic var owner = ""
    dynamic var type = ""
    dynamic var sourceString = ""
    dynamic var source: Source?
    dynamic var country :String?
    let params = List<Params>()
    
    convenience init(name: String, owner: String, sourceString: String, type: String) {
        self.init()
        self.name = name
        self.owner = owner
        self.type = type
    }
    
//    override static func primaryKey() -> String? {
//        return "combinedPrimaryKey"
//    }
    
    override static func indexedProperties() -> [String] {
        return ["name"]
    }
    
//    static func getAllVessels() -> Results<Vessel> {
//
//    }
}

class Params: Object {
    dynamic var title = ""
    dynamic var value = ""
    
    convenience init(title: String, value: String) {
        self.init()
        self.title = title
        self.value = value
    }
}

class Source: Object {
    dynamic var sourceString = ""
    dynamic var title = ""
//    dynamic var updated: NSDate?
    
    override static func primaryKey() -> String? {
        return "sourceString"
    }
    
    static func importAllFiles() {
        let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
        dispatch_async(backgroundQueue, {

            let realm = try! Realm()
            try! realm.write({
                realm.deleteAll() //start this off right.
            })
            
            let iotaSource = Source()
            iotaSource.sourceString = "iota"
            iotaSource.title = "IOTA"
            try! realm.write {
                realm.add(iotaSource)
            }
            
            importIOTA()
            //Send notification
            importWCPFC()
            //send notification
            //
            print("vessel count: \(realm.objects(Vessel).count)")
        })
    }
    
    static func importIOTA() { //source: Source) {
        print("starting iota")
        do {
            let realm = try! Realm()
            let path = NSBundle.mainBundle().pathForResource("ALASKA", ofType: "csv")
            let contents = try String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
            let csv = try CSV(string: contents)
            //print(csv.header)
            
            csv.enumerateAsDict { dict in
                
                if let shipName = dict["Vessel Name"] {
                    let owner = (dict["Owner Name"] != nil) ? dict["Owner Name"]! : "Unlisted"
                    let ship = Vessel(name: shipName, owner: owner, sourceString: "iota", type: "Fishing")
                    //record params.
                    let exclude = ["Vessel Name","Owner Name"]
                    let allKeys = dict.keys
                    let allParams = List<Params>()
                    for oneKey in allKeys {
                        if !exclude.contains(oneKey) {
                            let oneParam = dict[oneKey]
                            if let saveParam = oneParam {
                                let p = Params(title: oneKey, value: saveParam)
                                allParams.append(p)
                            }
                        }
                    }
                    ship.params.appendContentsOf(allParams)
                    try! realm.write {
                        realm.add(ship)
                    }
                    
                }
                
            }
            
        } catch  {
            // Catch errors or something
            print("what errors")
        }
        print("iota processed")
    }
    
    static func importWCPFC() { //source: Source) {
        print("starting iota")
        do {
            let realm = try! Realm()
            let path = NSBundle.mainBundle().pathForResource("ALASKA", ofType: "csv")
            let contents = try String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
            let csv = try CSV(string: contents)
            //print(csv.header)
            
            csv.enumerateAsDict { dict in
                
                if let shipName = dict["Vessel Name"] {
                    let owner = (dict["Owner Name"] != nil) ? dict["Owner Name"]! : "Unlisted"
                    let ship = Vessel(name: shipName, owner: owner, sourceString: "iota", type: "Fishing")
                    //record params.
                    let exclude = ["Vessel Name","Owner Name"]
                    let allKeys = dict.keys
                    let allParams = List<Params>()
                    for oneKey in allKeys {
                        if !exclude.contains(oneKey) {
                            let oneParam = dict[oneKey]
                            if let saveParam = oneParam {
                                let p = Params(title: oneKey, value: saveParam)
                                allParams.append(p)
                            }
                        }
                    }
                    ship.params.appendContentsOf(allParams)
                    try! realm.write {
                        realm.add(ship)
                    }
                    
                }
                
            }
            
        } catch  {
            // Catch errors or something
            print("what errors")
        }
        print("iota processed")
    }
    
    
}
