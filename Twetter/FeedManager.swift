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
    
    // MARK: Initialization
    
    override init() {
        if let userID = Twitter.sharedInstance().sessionStore.session()!.userID {
            client = TWTRAPIClient(userID: userID)
        }
    }
    
    // MARK: Accessors
    
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
    
    func queries() -> NSArray {
        return prefs.valueForKey("feeds") as! NSArray
    }
    
    // TODO: Way more complicated feeds
    
    func titleForQuery(query: String) -> String {
        return query.stringByReplacingOccurrencesOfString("OR ", withString:"")
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
}

