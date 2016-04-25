//
//  SearchWindowController.swift
//  VesselLookup
//
//  Created by Robert Linnemann on 4/23/16.
//  Copyright © 2016 Epistrophy. All rights reserved.
//

import Foundation
import Cocoa
import RealmSwift

class SearchWindowController: NSViewController, NSWindowDelegate {

    @IBOutlet weak var searchWindow: NSWindow!
    @IBOutlet weak var searchField: NSTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
    }
    
    // MARK: Action Methods
    
    @IBAction func searchAction(sender: AnyObject) {
        print("search some shiznit.")
        let realm = try! Realm()
        
        let searchString = searchField.stringValue
        let results = realm.objects(Vessel).filter("name CONTAINS[c] %@", searchString)
        print(" results count:\(results.count)")
    }
    
    
}