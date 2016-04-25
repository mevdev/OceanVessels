//
//  ResultsWindowController.swift
//  VesselLookup
//
//  Created by Robert Linnemann on 4/23/16.
//  Copyright © 2016 Epistrophy. All rights reserved.
//

import Foundation
import Cocoa

class ResultsWindowController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet weak var resultsTableView: NSTableView!
    
    var mainArray: [String] = ["asdf","interasfd","asdfasdf","abcdefg"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
    }
    
    
    // MARK - TableView Methods
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return mainArray.count
    }

    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 42
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell: ResultsCell = tableView.makeViewWithIdentifier("resultCell", owner: self) as! ResultsCell
        cell.nameLabel.stringValue = "Name here pls"
        cell.openButton.tag = row
    }

    @IBAction func openAction(sender: NSButton) {
        let row = self.resultsTableView.rowForView(sender.superview)
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
