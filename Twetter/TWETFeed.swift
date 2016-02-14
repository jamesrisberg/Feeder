//
//  TWETFeed.swift
//  Twetter
//
//  Created by James on 2/6/16.
//  Copyright © 2016 James Risberg. All rights reserved.
//

import TwitterKit

class TWETFeed: NSObject {
    var keys: [String] = []
    var feedViewController: TWTRTimelineViewController!
    
    func initWithFeed(keys: [String], viewController: TWTRTimelineViewController) {
        self.keys = keys
        self.feedViewController = viewController
    }
}