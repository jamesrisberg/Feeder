//
//  FeedListView.swift
//  Twetter
//
//  Created by James on 2/13/16.
//  Copyright © 2016 James Risberg. All rights reserved.
//

import UIKit

class FeedListView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var addFeedButton: UIButton!
    
    var listController: FeedListViewController!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    // MARK: Initialization
    
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> FeedListView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(self, options: nil)[0] as? FeedListView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureWithController(controller: FeedListViewController) {
        self.listController = controller
        configureTableView()
    }
    
    private func configureTableView() {
        self.tableview.addSubview(self.refreshControl)
        self.tableview.delegate = self.listController
        self.tableview.dataSource = self.listController
        self.tableview.registerNib(UINib(
            nibName: "FeedListCell",
            bundle: NSBundle.mainBundle()
            ), forCellReuseIdentifier: "feedListCell")
    }
    
    // MARK: Actions
    
    @IBAction func addFeedButtonTouched(sender: UIButton) {
        self.listController.presentAddFeedView(self)
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.tableview.reloadData()
        refreshControl.endRefreshing()
    }

    @IBAction func handleSwipe(sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.Up:
            self.listController.handleSwipeUp(sender, listView: self)
        case UISwipeGestureRecognizerDirection.Down:
            self.listController.handleSwipeDown(sender, listView: self)
        default:
            break
        }
    }
}
