//
//  VesselWindowController.swift
//  VesselLookup
//
//  Created by Robert Linnemann on 4/23/16.
//  Copyright © 2016 Epistrophy. All rights reserved.
//

import Foundation
import Cocoa
import Quartz
import RealmSwift

class VesselWindowController: NSWindowController, NSWindowDelegate {
    var vessel: Vessel?
    
    @IBOutlet weak var vesselText: NSTextField!
    @IBOutlet weak var ownerText: NSTextField!
    
    @IBOutlet var infoText: NSTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let ves = vessel {
        vesselText.stringValue = ves.name
        ownerText.stringValue = ves.owner
        var paramsText = ""
            for p in ves.params {
                paramsText += "\(p.title)\(p.value)\n"
            }
        infoText.string = paramsText
        }
    }


    
    
}