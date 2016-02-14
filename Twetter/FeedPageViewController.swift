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
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        self.view.backgroundColor = UIColor.whiteColor()
                
        if manager.feedCount() != 0 {
            let firstViewController = makeFeedViewController(manager.feedAtIndex(0))
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Initialization
    
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
        label.frame = CGRectMake(0,0,50,100)
        label.text = "no feeds"
        label.backgroundColor = UIColor.redColor()
        label.center = feedlessViewController.view.center
        feedlessViewController.view.addSubview(label)
        setViewControllers([feedlessViewController], direction: .Forward, animated: true, completion: nil)
        
        disablePaging()
    }
    
    // MARK: Action
    
    private func scrollToTop() {
        if currentController != nil {
            let controller = currentController.childViewControllers[0] as! TWTRTimelineViewController
            controller.tableView.setContentOffset(CGPointZero, animated: true)
        }
    }
    
    private func composeTweet() {
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
    
    // MARK: Helper
    
    private func disablePaging() {
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.scrollEnabled = false
            }
        }
    }
    
    private func enablePaging() {
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.scrollEnabled = true
            }
        }
    }
    
    private func makeFeedViewController(query: String) -> FeedViewController {
        let viewController = FeedViewController()
        viewController.setQueryString(query)
        viewController.automaticallyAdjustsScrollViewInsets = false
        
        let topView = UIView()
        topView.backgroundColor = UIColor.whiteColor()
        topView.translatesAutoresizingMaskIntoConstraints = false
        
        let feedLabel = UILabel()
        feedLabel.text = manager.titleForQuery(query)
        feedLabel.font = UIFont.systemFontOfSize(18.0, weight: UIFontWeightThin)
        feedLabel.textColor = colorWithHexString("#00aced")
        feedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        topView.addSubview(feedLabel)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let dataSource = TWTRSearchTimelineDataSource(searchQuery: query, APIClient: manager.client)
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

// MARK: PageView Datasource

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
            
            return makeFeedViewController(manager.feedAtIndex(curr))
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
            
            return makeFeedViewController(manager.feedAtIndex(curr))
    }
}

// MARK: PageView Delegate

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