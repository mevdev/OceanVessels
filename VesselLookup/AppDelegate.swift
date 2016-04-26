//
//  AppDelegate.swift
//  VesselLookup
//
//  Created by Robert Linnemann on 4/23/16.
//  Copyright © 2016 Epistrophy. All rights reserved.
//

import Cocoa
import RealmSwift

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        firstLaunch()
        checkMigration()
//  Source.importAllFiles() //files are pre-loaded.

    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func firstLaunch() {
        let loaded = NSUserDefaults.standardUserDefaults().boolForKey("first").boolValue
        if !loaded {
            //load up the saved realm.
            // copy over old data files for migration
            let defaultURL = Realm.Configuration.defaultConfiguration.fileURL!
            if let v0URL = bundleURL("fish_compressed") {
                do {
                    try NSFileManager.defaultManager().removeItemAtURL(defaultURL)
                    try NSFileManager.defaultManager().copyItemAtURL(v0URL, toURL: defaultURL)
                    print("db replaced")
                } catch {}
            }
            
            let prefs = NSUserDefaults.standardUserDefaults()
            prefs.setBool(true, forKey: "initial")
            prefs.synchronize()
        }
    }

    func checkMigration() {
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 2) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        Realm.Configuration.defaultConfiguration = config
        let realm = try! Realm()
    }

    func bundleURL(name: String) -> NSURL? {
        return NSBundle.mainBundle().URLForResource(name, withExtension: "realm")
    }
}

