//
//  AddFeedViewController.swift
//  Twetter
//
//  Created by James on 2/13/16.
//  Copyright © 2016 James Risberg. All rights reserved.
//

import UIKit

class AddFeedViewController: NSObject {
    
    // MARK: Action
    
    func addFeedButtonTouched(sender: AddFeedView) {
        UIView.animateWithDuration(0.4, delay: 0.0, options: .CurveEaseOut, animations: {
            var myFrame = UIScreen.mainScreen().bounds
            myFrame.origin.y = myFrame.height
            sender.frame = myFrame
            
            }, completion: { finished in
        })
    }
    
    func cancelButtonTouched(sender: AddFeedView) {
        UIView.animateWithDuration(0.4, delay: 0.0, options: .CurveEaseOut, animations: {
            var myFrame = UIScreen.mainScreen().bounds
            myFrame.origin.y = myFrame.height
            sender.frame = myFrame
            
            }, completion: { finished in
        })
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("termCell", forIndexPath: indexPath) as! AddFeedCollectionViewCell
        
        cell.termLabel.text = "Term Here"
        
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
