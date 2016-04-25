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

class SearchWindowController: NSViewController {

    @IBOutlet weak var searchField: NSTextField!
    var resultsWindowRef :ResultsWindowController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
        
    // MARK: Action Methods
    
    @IBAction func searchAction(sender: AnyObject) {
        print("search some shiznit.")
        let realm = try! Realm()
        
        let searchString = searchField.stringValue
        let results = realm.objects(Vessel).filter("name CONTAINS[c] %@", searchString)
        print(" results count:\(results.count)")
        
        if (self.resultsWindowRef != nil) {
            self.resultsWindowRef?.close()
            self.resultsWindowRef = nil
        }
        let resultsWindow = ResultsWindowController(windowNibName:"ResultsWindow")
        resultsWindow.vesselResults = results
        resultsWindow.showWindow(nil)
        self.resultsWindowRef = resultsWindow
        
    }
    
    
}