//
//  FeedListViewController.swift
//  Twetter
//
//  Created by James on 2/7/16.
//  Copyright © 2016 James Risberg. All rights reserved.
//

import UIKit

class FeedListViewController: NSObject {
    
    let prefs = NSUserDefaults.standardUserDefaults()
    
    let manager = FeedManager.sharedInstance
    
    func presentAddFeedView(listView: FeedListView) {
        let addFeedView = AddFeedView.loadFromNibNamed("AddFeedView")
        addFeedView!.configureWithController(AddFeedViewController())
        
        var screenFrame = UIScreen.mainScreen().bounds;
        screenFrame.origin.y = screenFrame.height;
        addFeedView?.frame = screenFrame
        
        listView.addSubview(addFeedView!)
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
            screenFrame.origin.y = 0.0;
            addFeedView?.frame = screenFrame
            
            }, completion: { finished in
        })
    }
    
    // MARK: Gesture Handlers
    
    func handleSwipeUp(sender: UISwipeGestureRecognizer, listView: FeedListView) {
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
            listView.frame = UIScreen.mainScreen().bounds
            
            listView.titleLabel.alpha = 1.0
            }, completion: { finished in
        })
    }
    
    func handleSwipeDown(sender: UISwipeGestureRecognizer, listView: FeedListView) {
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
            var frame = UIScreen.mainScreen().bounds
            frame.origin.y = frame.height - 50
            listView.frame = frame
            
            listView.titleLabel.alpha = 0.0
            
            }, completion: { finished in
        })
    }
}

// MARK: Table Datasource

extension FeedListViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.feedCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("feedListCell", forIndexPath: indexPath) as! FeedListCell
        cell.feedNameLabel.text = manager.feedTitleAtIndex(indexPath.row)
        
        return cell
    }
}

// MARK: Table Delegate

extension FeedListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            manager.removeFeed(indexPath.row)
            tableView.reloadData()
        }
    }
}
