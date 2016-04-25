//
//  ResultsWindowController.swift
//  VesselLookup
//
//  Created by Robert Linnemann on 4/23/16.
//  Copyright © 2016 Epistrophy. All rights reserved.
//

import Foundation
import Cocoa
import RealmSwift

class ResultsWindowController: NSWindowController, NSTableViewDataSource, NSTableViewDelegate, NSWindowDelegate {
    
    var vesselResults: Results<Vessel>?
    @IBOutlet weak var resultsTableView: NSTableView!
    var searchString: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.window?.title = "Search: \(searchString)"
    }


    
    // MARK - TableView Methods
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return vesselResults!.count
    }

    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 42
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell: ResultsCell = tableView.makeViewWithIdentifier("resultCell", owner: self) as! ResultsCell
        cell.nameLabel.stringValue = vesselResults![row].name
        cell.ownerLabel.stringValue = vesselResults![row].owner
        cell.openButton.tag = row
        cell.sourceLabel.stringValue = sourceStringFromId(vesselResults![row].sourceString)
        return cell
    }
    
    func sourceStringFromId(sourceId: String) -> String {
        let realm = try! Realm()
        let source = realm.objects(Source).filter("sourceString == %@",sourceId).first
        if let sData = source {
            return sData.title
        } else {
            return ""
        }
    }

    @IBAction func openAction(sender: NSButton) {
        let row = self.resultsTableView.rowForView(sender.superview!)
        print("open \(row)")
    }
    

//    -(IBAction)downloadButtonClicked:(id)sender {
//    //do the stuffs.
//    NSButton *dlButton = (NSButton *)sender;
//    NSInteger row = [self.downloadsTableView rowForView:dlButton.superview];
//    ASDownloadableFile *thisFile = [self.downloads objectAtIndex:row];
//    [thisFile download];
//    //DRY - this should be picked up in the tick, but it's not.
//    DownloadsTableViewCell *cell = [self.downloadsTableView viewAtColumn:0 row:row makeIfNecessary:YES];
//    cell.downloadButton.hidden = YES;
//    cell.availableLabel.hidden = NO; //show show is available.
//    [cell.downloadIndicator startAnimation:nil];
//    cell.downloadIndicator.hidden = NO;
//    [self updateUI];
//    }

}
