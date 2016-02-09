//
//  EditFeedsViewController.swift
//  Twetter
//
//  Created by James on 2/7/16.
//  Copyright © 2016 James Risberg. All rights reserved.
//

import UIKit

class EditFeedsViewController: UIViewController {
    
    let prefs = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var tableview: UITableView!
    
    let manager = FeedManager.sharedInstance
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        self.tableview.addSubview(self.refreshControl)
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.tableview.reloadData()
        refreshControl.endRefreshing()
    }
    
    @IBAction func presentAddFeedAlert() {
        
        let alertController = UIAlertController(title: "Add Feed", message: "Enter your custom query", preferredStyle: .Alert)
        
        let addAction = UIAlertAction(title: "Add", style: .Default) { (_) in
            let feedTextField = alertController.textFields![0] as UITextField
            
            self.manager.addFeed(feedTextField.text!)
            self.tableview.reloadData()
        }
        addAction.enabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Custom Query"
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                addAction.enabled = textField.text != ""
            }
        }
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

extension EditFeedsViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.feedCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("queryCell", forIndexPath: indexPath) as! QueryCell
        cell.queryLabel.text = manager.feedTitleAtIndex(indexPath.row)
        
        return cell
    }
}

extension EditFeedsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            manager.removeFeed(indexPath.row)
            self.tableview.reloadData()
        }
    }
}
