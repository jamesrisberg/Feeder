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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 4.0
        loginButton.layer.shadowOffset = CGSizeMake(0.0, 1.0)
        loginButton.layer.shadowOpacity = 0.6
        loginButton.layer.shadowRadius = 1.5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInWithTwitter(sender: UIButton) {
        sender.enabled = false
        
        Twitter.sharedInstance().logInWithCompletion { (session, error) in
            if let unwrappedSession = session {
                let alert = UIAlertController(title: "Logged In",
                    message: "User \(unwrappedSession.userName) has logged in",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {_ in
                    sender.enabled = true
                    self.loggedIn()
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                sender.enabled = true
                NSLog("Login error: %@", error!.localizedDescription);
            }
        }
    }
    
    func loggedIn() {
        performSegueWithIdentifier("logIn", sender: nil)
    }
}