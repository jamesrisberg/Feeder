//
//  AddFeedView.swift
//  Twetter
//
//  Created by James on 2/14/16.
//  Copyright © 2016 James Risberg. All rights reserved.
//

import UIKit

class AddFeedView: UIView {
    
    @IBOutlet weak var includeCollectionView: UICollectionView!
    @IBOutlet weak var excludeCollectionView: UICollectionView!
    @IBOutlet weak var includeField: UITextField!
    @IBOutlet weak var excludeField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addFeedButton: UIButton!
    @IBOutlet weak var feedNameField: UITextField!
    
    var controller: AddFeedViewController!
    
    // MARK: Initialization
    
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> AddFeedView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(self, options: nil)[0] as? AddFeedView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureWithController(controller: AddFeedViewController) {
        self.controller = controller
        includeCollectionView.dataSource = controller
        includeCollectionView.delegate = controller
        excludeCollectionView.dataSource = controller
        excludeCollectionView.delegate = controller
        
        self.includeCollectionView.registerNib(
            UINib(nibName: "AddFeedCollectionCell",
                bundle: NSBundle.mainBundle()),
            forCellWithReuseIdentifier:"termCell")
        
        self.excludeCollectionView.registerNib(
            UINib(nibName: "AddFeedCollectionCell",
                bundle: NSBundle.mainBundle()),
            forCellWithReuseIdentifier:"termCell")
        
        configureButton(addFeedButton)
        configureButton(cancelButton)
    }
    
    private func configureButton(button: UIButton) {
        button.layer.cornerRadius = 4.0
        button.layer.shadowOffset = CGSizeMake(0.0, 1.0)
        button.layer.shadowOpacity = 0.6
        button.layer.shadowRadius = 1.5
    }
    
    @IBAction func cancelButtonTouched(sender: UIButton) {
        self.controller.cancelButtonTouched(self)
    }
    
    @IBAction func addFeedButtonTouched(sender: UIButton) {
        self.controller.addFeedButtonTouched(self)
    }
}
