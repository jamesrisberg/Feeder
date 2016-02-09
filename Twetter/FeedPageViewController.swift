//
//  FeedPageViewController.swift
//  Twetter
//
//  Created by James on 2/6/16.
//  Copyright © 2016 James Risberg. All rights reserved.
//

import UIKit
import TwitterKit

class FeedPageViewController: UIPageViewController {
    
    let manager = FeedManager.sharedInstance
    
    var currentController: FeedViewController! = nil
    var nextController: FeedViewController! = nil
    
    var currentPage = 0
    var nextPage = -1
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        self.view.backgroundColor = UIColor.whiteColor()
                
        if manager.feedCount() != 0 {
            let firstViewController = manager.makeFeedViewController(manager.feedAtIndex(0))
            currentController = firstViewController
            setViewControllers([firstViewController], direction: .Forward, animated: true, completion: nil)
        } else {
            configureFeedlessView()
        }
        
        if manager.feedCount() == 1 {
            disablePaging()
        }
        configureTopView()
    }
    
    func configureTopView() {
        let topBarTapRecognizer = UITapGestureRecognizer(target: self, action: "scrollToTop")
        topBarTapRecognizer.cancelsTouchesInView = false
        self.navigationController?.navigationBar.addGestureRecognizer(topBarTapRecognizer)
        
        let composeTweetButton = UIButton(type: .Custom)
        if let image = UIImage(named: "tweet") {
            composeTweetButton.setImage(image, forState: .Normal)
        }
        composeTweetButton.frame = CGRectMake(0, 0, 30, 25)
        composeTweetButton.addTarget(self, action: "composeTweet", forControlEvents: .TouchUpInside)
        
        let tweetBarButton = UIBarButtonItem(customView: composeTweetButton)
        
        let barButtons: [UIBarButtonItem] = [addButton, tweetBarButton]
        self.navigationItem.rightBarButtonItems = barButtons
    }
    
    func configureFeedlessView() {
        let feedlessViewController = UIViewController()
        feedlessViewController.view.backgroundColor = UIColor.brownColor()
        let label = UILabel()
        label.text = "no feeds"
        label.backgroundColor = UIColor.redColor()
        label.center = feedlessViewController.view.center
        feedlessViewController.view.addSubview(label)
        setViewControllers([feedlessViewController], direction: .Forward, animated: true, completion: nil)
        
        disablePaging()
    }
    
    func disablePaging() {
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.scrollEnabled = false
            }
        }
    }
    
    func enablePaging() {
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.scrollEnabled = true
            }
        }
    }
    
    func scrollToTop() {
        if currentController != nil {
            let controller = currentController.childViewControllers[0] as! TWTRTimelineViewController
            controller.tableView.setContentOffset(CGPointZero, animated: true)
        }
    }
    
    func composeTweet() {
        let composer = TWTRComposer()
        
        composer.showFromViewController(self) { result in
            if (result == TWTRComposerResult.Cancelled) {
                print("Tweet composition cancelled")
            }
            else {
                print("Sending tweet!")
            }
        }
    }
    
    @IBAction func presentAddFeedAlert(sender: UIButton) {
        
        let alertController = UIAlertController(title: "Add Feed", message: "Enter your custom query", preferredStyle: .Alert)
        
        let addAction = UIAlertAction(title: "Add", style: .Default) { (_) in
            let feedTextField = alertController.textFields![0] as UITextField
            
            self.manager.addFeed(feedTextField.text!)
            
            if self.manager.feedCount() == 1 {
                self.setViewControllers([self.manager.makeFeedViewController(self.manager.feedAtIndex(0))], direction: .Forward, animated: true, completion: nil)
            }
            if self.manager.feedCount() == 2 {
                self.enablePaging()
            }
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

extension FeedPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            var curr = currentPage - 1
            
            if curr < 0 {
                curr = manager.feedCount()-1
            }
            
            guard manager.feedCount() > curr else {
                return nil
            }
            
            return manager.makeFeedViewController(manager.feedAtIndex(curr))
    }
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
            var curr = currentPage + 1
            
            if curr == manager.feedCount() {
                curr = 0
            }
            
            guard manager.feedCount() > curr else {
                return nil
            }
            
            return manager.makeFeedViewController(manager.feedAtIndex(curr))
    }
}

extension FeedPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        nextController = pendingViewControllers.first as! FeedViewController
        nextPage = manager.indexForFeed(nextController.query)
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (completed) {
            currentController = nextController
            nextController = nil
            currentPage = nextPage
        }
    }
}