//
//  ResultsCell.swift
//  VesselLookup
//
//  Created by Robert Linnemann on 4/25/16.
//  Copyright © 2016 Epistrophy. All rights reserved.
//

import Foundation
import Cocoa

class ResultsCell: NSTableCellView {

    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var ownerLabel: NSTextField!
    @IBOutlet weak var openButton: NSButton!
    @IBOutlet weak var sourceLabel: NSTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}