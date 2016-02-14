//
//  LoginViewController.swift
//  Twetter
//
//  Created by James on 2/6/16.
//  Copyright © 2016 James Risberg. All rights reserved.
//

import UIKit
import TwitterKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Initialization
    
    private func configureButton() {
        loginButton.layer.cornerRadius = 4.0
        loginButton.layer.shadowOffset = CGSizeMake(0.0, 1.0)
        loginButton.layer.shadowOpacity = 0.6
        loginButton.layer.shadowRadius = 1.5
    }
    
    // MARK: Action
    
    @IBAction func signInWithTwitter(sender: UIButton) {
        sender.enabled = false
        activityIndicator.startAnimating()
        
        Twitter.sharedInstance().logInWithCompletion { (session, error) in
            if let _ = session {
                sender.enabled = true
                self.activityIndicator.stopAnimating()
                self.loggedIn()
            } else {
                sender.enabled = true
                NSLog("Login error: %@", error!.localizedDescription);
            }
        }
    }
    
    // MARK: Helper
    
    private func loggedIn() {
        performSegueWithIdentifier("logIn", sender: nil)
    }
}