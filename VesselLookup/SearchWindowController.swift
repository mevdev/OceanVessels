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
import Quartz

class SearchWindowController: NSViewController, NSWindowDelegate {

    @IBOutlet weak var searchField: NSTextField!
    @IBOutlet weak var backgroundView: NSImageView!
    @IBOutlet weak var iconView: NSImageView!
    var resultsWindowRef :ResultsWindowController?
    
    @IBOutlet weak var iotcCheck: NSButton!
    @IBOutlet weak var wcpfcCheck: NSButton!
    @IBOutlet weak var alaskaCheck: NSButton!
    @IBOutlet weak var ccsbtCheck: NSButton!
    @IBOutlet weak var euroCheck: NSButton!
    @IBOutlet weak var ffaCheck: NSButton!
    @IBOutlet weak var statusLabel: NSTextField!
    
    var infoWindows: [VesselWindowController] = [VesselWindowController]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
            self.backgroundView.image = NSImage(named: "dark_background")
            self.iconView.image = NSImage(named: "icon_white")
        self.loadUP()
    }
    
    func loadUP() {
        
        let center = NSNotificationCenter.defaultCenter()
        center.addObserverForName(kUpdate, object: nil, queue: nil) { notification in
            print("\(notification.name): \(notification.userInfo ?? [:])")
            if let str:NSString = notification.object as? NSString {
                dispatch_async(dispatch_get_main_queue(),{                    
                self.statusLabel.stringValue = str as String
                })

            }
        }

        self.turnControlTextWhite(iotcCheck)
        self.turnControlTextWhite(wcpfcCheck)
        self.turnControlTextWhite(alaskaCheck)
        self.turnControlTextWhite(ccsbtCheck)
        self.turnControlTextWhite(euroCheck)
        self.turnControlTextWhite(ffaCheck)
        
    }

    
    func turnControlTextWhite(control: NSButton) {
        //TODO: make this work please.
        let attString = NSMutableAttributedString(attributedString: control.attributedTitle)
        let title: NSString = control.title
        let range = NSMakeRange(0, title.length);
        attString.addAttributes([NSForegroundColorAttributeName: NSColor.whiteColor()], range: range)
            control.attributedTitle = attString
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
        resultsWindow.searchString = searchString
        resultsWindow.showWindow(nil)
        self.resultsWindowRef = resultsWindow
        
    }
    
    
}