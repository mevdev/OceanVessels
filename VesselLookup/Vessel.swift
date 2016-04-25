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
    dynamic var nameLowerCase = ""
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
    dynamic var imported = false
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
            

//            importALASKA()
//            print("vessel count: \(realm.objects(Vessel).count)")

            importWCPFC()
            print("vessel count: \(realm.objects(Vessel).count)")

            importIOTC()
            print("vessel count: \(realm.objects(Vessel).count)")



            
        })
    }
    
    static func importALASKA() { //source: Source) {
        print("starting alaska")
        let realm = try! Realm()
        let aSource = Source()
        aSource.sourceString = "alaska"
        aSource.title = "CFEC - Alaska Commercial Fisheries Entry Commission"
        try! realm.write {
            realm.add(aSource)
        }

        do {
            let realm = try! Realm()
            let path = NSBundle.mainBundle().pathForResource("ALASKA", ofType: "csv")
            let contents = try String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
            let csv = try CSV(string: contents)
            //print(csv.header)
            
            csv.enumerateAsDict { dict in
                
                if let shipName = dict["Vessel Name"] {
                    let owner = (dict["Owner Name"] != nil) ? dict["Owner Name"]! : "Unlisted"
                    let ship = Vessel(name: shipName, owner: owner, sourceString: "alaska", type: "Fishing")
                    ship.nameLowerCase = shipName.lowercaseString
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
        try! realm.write {
            aSource.imported = true
        }
        print("alaska processed")
    }
    
    static func importWCPFC() { //source: Source) {
        let kSourceString = "wcpfc"
        print("starting WCPFC")
        let realm = try! Realm()
        let wcpfcSource = Source()
        wcpfcSource.sourceString = kSourceString
        wcpfcSource.title = "WCPFC - Western and Central Pacific Fisheries Commission"
        try! realm.write {
            realm.add(wcpfcSource)
        }

        do {
            let path = NSBundle.mainBundle().pathForResource("WCPFC", ofType: "csv")
            let contents = try String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
            let csv = try CSV(string: contents)
            //print(csv.header)
            
            csv.enumerateAsDict { dict in
                if let shipName = dict["Vessel Name"] {
                    let owner = (dict["Owner Name"] != nil) ? dict["Owner Name"]! : "Unlisted"
                    let ship = Vessel(name: shipName, owner: owner, sourceString: kSourceString, type: "Fishing")
                    ship.nameLowerCase = shipName.lowercaseString
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
        try! realm.write {
            wcpfcSource.imported = true
        }

        print("WCPFC processed")
    }
    
    static func importIOTC() { //source: Source) {
        let realm = try! Realm()
        print("starting iotc")
        
        let iotaSource = Source()
        iotaSource.sourceString = "iotc"
        iotaSource.title = "IOTC - Indian Ocean Tuna Commission"
        try! realm.write {
            realm.add(iotaSource)
        }
        
        do {
            let realm = try! Realm()
            let path = NSBundle.mainBundle().pathForResource("IOTC", ofType: "csv")
            let contents = try String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
            let csv = try CSV(string: contents)
            //print(csv.header)
            
            csv.enumerateAsDict { dict in
                
                if let shipName = dict["Name_Ship"] {
                    let owner = (dict["Name_Owner"] != nil) ? dict["Name_Owner"]! : "Unlisted"
                    let typeShip = (dict["Type_Ship"] != nil) ? dict["Type_Ship"]! : "Fishing"
                    let ship = Vessel(name: shipName, owner: owner, sourceString: "iotc", type: typeShip)
                    ship.nameLowerCase = shipName.lowercaseString
                    //record params.
                    let exclude = ["Name_Ship","Name_Owner","Type_Ship"]
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
        try! realm.write {
            iotaSource.imported = true
        }

        print("iotc processed")
    }
    
    
}
