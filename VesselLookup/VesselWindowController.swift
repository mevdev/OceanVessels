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
    
    @IBOutlet weak var backgroundView: NSImageView!
    @IBOutlet weak var vesselText: NSTextField!
    @IBOutlet weak var ownerText: NSTextField!
    @IBOutlet var infoText: NSTextView!
    
    @IBOutlet weak var sourceText: NSTextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundView.imageScaling = .ScaleProportionallyUpOrDown
        if let ves = vessel {
        vesselText.stringValue = ves.name
        ownerText.stringValue = ves.owner
        let sourceTitle = "" //getSource(ves.sourceString)
        sourceText.stringValue = sourceTitle
        var paramsText = ""
            for p in ves.params {
                paramsText += "\(p.title):  \(p.value)\n"
            }
        infoText.string = paramsText
        }
    }

    func getSource(source: String) -> Source? {
        let realm = try! Realm()
        return realm.objects(Source).filter("sourceString == %@",source).first!
    }
    
    
}