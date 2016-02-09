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
    let prefs = NSUserDefaults.standardUserDefaults()
    
    static let sharedInstance = FeedManager()
    
    override init() {
        if let userID = Twitter.sharedInstance().sessionStore.session()!.userID {
            client = TWTRAPIClient(userID: userID)
        }
    }
    
    func feedCount() -> Int {
        let feeds : NSArray = prefs.valueForKey("feeds") as! NSArray
        return feeds.count
    }
    
    func feedAtIndex(index: Int) -> String {
        let feeds : NSArray = prefs.valueForKey("feeds") as! NSArray
        return feeds.objectAtIndex(index) as! String
    }
    
    func feedTitleAtIndex(index: Int) -> String {
        let feeds : NSArray = prefs.valueForKey("feeds") as! NSArray
        let query = feeds.objectAtIndex(index) as! String
        return titleForQuery(query)
    }
    
    func indexForFeed(feed: String) -> Int {
        let feeds : NSArray = prefs.valueForKey("feeds") as! NSArray
        let query : Int = feeds.indexOfObject(feed)
        return query
    }
    
    func feedTitles() -> NSArray {
        let feeds : NSArray = prefs.valueForKey("feeds") as! NSArray
        let mutableFeeds: NSMutableArray = feeds.mutableCopy() as! NSMutableArray
        
        for i in 0...mutableFeeds.count-1 {
            mutableFeeds[i] = titleForQuery(mutableFeeds[i] as! String)
        }
        
        return mutableFeeds
    }
    
    func titleForQuery(query: String) -> String {
        return query.stringByReplacingOccurrencesOfString("OR ", withString:"")
    }
    
    func queries() -> NSArray {
        return prefs.valueForKey("feeds") as! NSArray
    }
    
    func addFeed(input: String) {
        let arguments = input.componentsSeparatedByString(" ")
        
        var query = arguments[0]
        if arguments.count > 1 {
            for i in 1...arguments.count-1 {
                query += (" OR " + arguments[i])
            }
        }
        
        let feeds : NSArray = prefs.valueForKey("feeds") as! NSArray
        let mutableFeeds = feeds.mutableCopy()
        mutableFeeds.addObject(query)
        prefs.setValue(mutableFeeds, forKey: "feeds")
        prefs.synchronize()
    }
    
    func removeFeed(index: Int) {
        let feeds = prefs.valueForKey("feeds") as! NSArray
        let mutableFeeds = feeds.mutableCopy()
        mutableFeeds.removeObjectAtIndex(index)
        prefs.setValue(mutableFeeds, forKey: "feeds")
    }
    
    func makeFeedViewController(query: String) -> FeedViewController {
        let viewController = FeedViewController()
        viewController.setQueryString(query)
        viewController.automaticallyAdjustsScrollViewInsets = false
        
        let topView = UIView()
        topView.backgroundColor = UIColor.whiteColor()
        topView.translatesAutoresizingMaskIntoConstraints = false
        
        let feedLabel = UILabel()
        feedLabel.text = titleForQuery(query)
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
            "V:|-10-[feedLabel]-10-|",
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
            "V:|-0-[topView]-0-[containerView]-0-|",
            options: NSLayoutFormatOptions.AlignAllLeading,
            metrics: nil, views: viewsDictionary)
        
        viewController.view.addConstraints(topViewHorizontalConstraint)
        viewController.view.addConstraints(containerViewHorizontalConstraint)
        viewController.view.addConstraints(verticalConstraints)
        
        return viewController
    }
}

