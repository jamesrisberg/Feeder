//
//  AddFeedViewController.swift
//  Twetter
//
//  Created by James on 2/13/16.
//  Copyright © 2016 James Risberg. All rights reserved.
//

import UIKit

class AddFeedViewController: UIViewController {

    @IBOutlet weak var includeCollectionView: UICollectionView!
    @IBOutlet weak var excludeCollectionView: UICollectionView!
    @IBOutlet weak var includeField: UITextField!
    @IBOutlet weak var excludeField: UITextField!
    @IBOutlet weak var addFeedButton: UIButton!
    @IBOutlet weak var feedNameField: UITextField!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Action
    
    @IBAction func addFeedButtonTouched(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: Textfield Delegate

extension AddFeedViewController: UITextFieldDelegate {
    
}

// MARK: Collection View Datasource

extension AddFeedViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("feedTermCell", forIndexPath: indexPath) as! UICollectionViewCell
        
        cell.backgroundColor = UIColor.blackColor()
        
        return cell
    }
}

// MARK: Collection View Flow Layout

extension AddFeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 50, height: 10)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init()
    }
}

// MARK: Collection View Delegate

extension AddFeedViewController: UICollectionViewDelegate {
    
}
