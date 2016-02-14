//
//  MainViewController.swift
//  Twetter
//
//  Created by James on 2/14/16.
//  Copyright © 2016 James Risberg. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addListView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func addListView() {
        let listView = FeedListView.loadFromNibNamed("FeedListView")
        listView!.configureWithController(FeedListViewController())
        
        var myFrame = self.view.bounds;
        myFrame.origin.y = myFrame.height - 50;
        listView?.frame = myFrame
        
        self.view.addSubview(listView!)
    }
    
    @IBAction func settingsButtonTouched(sender: UIButton) {
        
    }
    
    @IBAction func homeButtonTouched(sender: UIButton) {
        
    }
}
