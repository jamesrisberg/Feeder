//
//  FeedManager.swift
//  Twetter
//
//  Created by James on 2/6/16.
//  Copyright © 2016 James Risberg. All rights reserved.
//

import TwitterKit

class FeedManager: NSObject {
    
    var client: TWTRAPIClient!
    var feedView: FeedPageViewController!
    let prefs = NSUserDefaults.standardUserDefaults()
    
    static let sharedInstance = FeedManager()
    
    override init() {
        if let userID = Twitter.sharedInstance().sessionStore.session()!.userID {
            client = TWTRAPIClient(userID: userID)
        }
    }
    
    func configureWithViewController(vc: FeedPageViewController) {
        self.feedView = vc
    }
    
    func getFeeds() {
        let feeds : NSArray = prefs.valueForKey("feeds") as! NSArray
        
        for feed in feeds {
            self.feedView.addFeedViewController(makeFeedViewController(feed as! String))
        }
    }
    
    func addFeedPage(query: String) {
        self.feedView.addFeedViewController(makeFeedViewController(query))
    }
    
    func addFeed(query: String) {
        let feeds : NSArray = prefs.valueForKey("feeds") as! NSArray
        let mutableFeeds = feeds.mutableCopy()
        mutableFeeds.addObject(query)
        prefs.setValue(mutableFeeds, forKey: "feeds")
        prefs.synchronize()
    }
    
    func makeFeedViewController(query: String) -> UIViewController {
        let viewController = UIViewController()
        
        let topView = UIView()
        topView.backgroundColor = UIColor.whiteColor()
        topView.translatesAutoresizingMaskIntoConstraints = false
        
        let feedLabel = UILabel()
        feedLabel.text = query
        feedLabel.font = UIFont.systemFontOfSize(18.0, weight: UIFontWeightThin)
        feedLabel.textColor = colorWithHexString("#00aced")
        feedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        topView.addSubview(feedLabel)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let dataSource = TWTRSearchTimelineDataSource(searchQuery: query, APIClient: client)
        let timelineView = TWTRTimelineViewController(dataSource: dataSource)
        timelineView.showTweetActions = true
        timelineView.view.backgroundColor = UIColor.whiteColor()
        timelineView.view.translatesAutoresizingMaskIntoConstraints = false
        
        viewController.addChildViewController(timelineView)
        containerView.addSubview(timelineView.view)
        timelineView.didMoveToParentViewController(viewController)
        
        viewController.view.addSubview(topView)
        viewController.view.addSubview(containerView)
        
        let viewsDictionary = [
            "topView" : topView,
            "feedLabel" : feedLabel,
            "containerView" : containerView,
            "timelineView" : timelineView.view]
        
        let feedXCenterConstraint = NSLayoutConstraint(item: feedLabel, attribute: .CenterX, relatedBy: .Equal, toItem: topView, attribute: .CenterX, multiplier: 1, constant: 0)
        
        let feedLabelVerticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-0-[feedLabel]-10-|",
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil, views: viewsDictionary)
        
        topView.addConstraint(feedXCenterConstraint)
        topView.addConstraints(feedLabelVerticalConstraint)
        
        let timelineViewHorizontalConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-0-[timelineView]-0-|",
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil, views: viewsDictionary)
        
        let timelineViewVerticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-0-[timelineView]-0-|",
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil, views: viewsDictionary)
        
        containerView.addConstraints(timelineViewHorizontalConstraint)
        containerView.addConstraints(timelineViewVerticalConstraint)
        
        let topViewHorizontalConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-0-[topView]-0-|",
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil, views: viewsDictionary)
        
        let containerViewHorizontalConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-0-[containerView]-0-|",
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil, views: viewsDictionary)
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-64-[topView]-0-[containerView]-0-|",
            options: NSLayoutFormatOptions.AlignAllLeading,
            metrics: nil, views: viewsDictionary)
        
        viewController.view.addConstraints(topViewHorizontalConstraint)
        viewController.view.addConstraints(containerViewHorizontalConstraint)
        viewController.view.addConstraints(verticalConstraints)
        
        return viewController
    }
}

