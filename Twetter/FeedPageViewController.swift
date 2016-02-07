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
    var pageViews = NSMutableArray()
    var currentPage = 0
    var nextPage = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        self.view.backgroundColor = UIColor.whiteColor()
        
        manager.configureWithViewController(self)
        manager.getFeeds()
        
        if let firstViewController = pageViews.firstObject {
            setViewControllers([firstViewController as! UIViewController],
                direction: .Forward,
                animated: true,
                completion: nil)
        }
        
        configureTopView()
    }
    
    func configureTopView() {
        let topBarTapRecognizer = UITapGestureRecognizer(target: self, action: "scrollToTop")
        
        let topBar = UIView()
        topBar.addGestureRecognizer(topBarTapRecognizer)
        topBar.backgroundColor = UIColor.whiteColor()
        topBar.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "My Feeds"
        titleLabel.font = UIFont.systemFontOfSize(25.0, weight: UIFontWeightThin)
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let addFeedButton = UIButton(type: .Custom)
        if let image = UIImage(named: "plus") {
            addFeedButton.setImage(image, forState: .Normal)
        }
        addFeedButton.addTarget(self, action: "presentAddFeedAlert", forControlEvents: .TouchUpInside)
        addFeedButton.translatesAutoresizingMaskIntoConstraints = false
        
        let menuButton = UIButton(type: .Custom)
        menuButton.setTitle("Menu", forState: .Normal)
        menuButton.titleLabel?.font = UIFont.systemFontOfSize(20.0)
        menuButton.setTitleColor(colorWithHexString("#00aced"), forState: .Normal)
        menuButton.tintColor = colorWithHexString("#00aced")
        menuButton.addTarget(self, action: "backToMenu", forControlEvents: .TouchUpInside)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        
        let composeTweetButton = UIButton(type: .Custom)
        if let image = UIImage(named: "tweet") {
            composeTweetButton.setImage(image, forState: .Normal)
        }
        composeTweetButton.addTarget(self, action: "composeTweet", forControlEvents: .TouchUpInside)
        composeTweetButton.translatesAutoresizingMaskIntoConstraints = false
        
        topBar.addSubview(titleLabel)
        topBar.addSubview(addFeedButton)
        topBar.addSubview(composeTweetButton)
        topBar.addSubview(menuButton)
        
        self.view.addSubview(topBar)
        
        let viewsDictionary = [
            "topBar" : topBar,
            "titleLabel" : titleLabel,
            "addFeedButton" : addFeedButton,
            "composeTweetButton" : composeTweetButton,
            "menuButton" : menuButton]
        
        let topBarViewHorizontalConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-0-[topBar]-0-|",
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil, views: viewsDictionary)
        
        let topBarViewVerticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[topBar(64)]",
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil, views: viewsDictionary)
        
        let menuButtonVerticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-25-[menuButton]",
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil, views: viewsDictionary)
        
        let menuButtonHorizontalConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-20-[menuButton]",
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil, views: viewsDictionary)
        
        let tweetButtonVerticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-25-[composeTweetButton(27)]",
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil, views: viewsDictionary)
        
        let addButtonHorizontalConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:[composeTweetButton(35)]-20-[addFeedButton(25)]-20-|",
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil, views: viewsDictionary)
        
        let addButtonVerticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-25-[addFeedButton(25)]",
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil, views: viewsDictionary)
        
        let titleLabelXCenterConstraint = NSLayoutConstraint(item: titleLabel, attribute: .CenterX, relatedBy: .Equal, toItem: topBar, attribute: .CenterX, multiplier: 1, constant: 0)
        
        let titleLabelViewVerticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-20-[titleLabel]-0-|",
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil, views: viewsDictionary)
        
        self.view.addConstraints(topBarViewHorizontalConstraint)
        self.view.addConstraints(topBarViewVerticalConstraint)
        
        topBar.addConstraints(menuButtonVerticalConstraint)
        topBar.addConstraints(menuButtonHorizontalConstraint)
        topBar.addConstraints(tweetButtonVerticalConstraint)
        topBar.addConstraints(addButtonHorizontalConstraint)
        topBar.addConstraints(addButtonVerticalConstraint)
        
        topBar.addConstraint(titleLabelXCenterConstraint)
        topBar.addConstraints(titleLabelViewVerticalConstraint)
    }
    
    func scrollToTop() {
        let controller = pageViews.objectAtIndex(currentPage).childViewControllers[0] as! TWTRTimelineViewController
        controller.tableView.setContentOffset(CGPointZero, animated: true)
    }
    
    func addFeedViewController(vc: UIViewController) {
        pageViews.addObject(vc)
    }
    
    func composeTweet() {
        let composer = TWTRComposer()
        
        // Called from a UIViewController
        composer.showFromViewController(self) { result in
            if (result == TWTRComposerResult.Cancelled) {
                print("Tweet composition cancelled")
            }
            else {
                print("Sending tweet!")
            }
        }
    }
    
    func backToMenu() {
        dismissViewControllerAnimated(true) { () -> Void in }
    }
    
    func presentAddFeedAlert() {
        
        let alertController = UIAlertController(title: "Add Feed", message: "Enter your custom query", preferredStyle: .Alert)
        
        let addAction = UIAlertAction(title: "Add", style: .Default) { (_) in
            let feedTextField = alertController.textFields![0] as UITextField
            
            self.manager.addFeed(feedTextField.text!)
            self.manager.addFeedPage(feedTextField.text!)
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
                curr = pageViews.count-1
            }
            
            guard pageViews.count > curr else {
                return nil
            }
            
            return pageViews.objectAtIndex(curr) as? UIViewController
    }
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
            var curr = currentPage + 1
            
            if curr == pageViews.count {
                curr = 0
            }
            
            guard pageViews.count > curr else {
                return nil
            }
            
            return pageViews.objectAtIndex(curr) as? UIViewController
    }
}

extension FeedPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        let nextController = pendingViewControllers.first
        nextPage = pageViews.indexOfObject(nextController!)
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (completed) {
            currentPage = nextPage
        }
    }
}