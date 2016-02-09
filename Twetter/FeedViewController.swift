//
//  FeedViewController.swift
//  Twetter
//
//  Created by James on 2/9/16.
//  Copyright © 2016 James Risberg. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    var query: String!
    
    func setQueryString(query: String) {
        self.query = query
    }
    
    func queryString() -> String {
        return query
    }
}
