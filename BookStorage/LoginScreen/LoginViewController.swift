//
//  ViewController.swift
//  BookStorage
//
//  Created by Poonam Yadav on 11/08/19.
//  Copyright © 2019 poonamyadav. All rights reserved.
//

import UIKit
import Foundation

/*
 Class intend to show the login screen. on failed authentication user gets intimated with alert view. For Security Purpose, generic error messages has been showed to users
 */

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var userNameInout: UITextField!
    
    @IBOutlet weak var passwordInput: UITextField!
    
    
    
    
    // MARK
    /*
     Activity Indicator to show the background activity is in progress
 */
    let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView();
    
    func startLoading(){
        activityIndicator.center = self.view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge;
        view.addSubview(activityIndicator);
        
        activityIndicator.startAnimating();
        UIApplication.shared.beginIgnoringInteractionEvents();
        
    }
    
    func stopLoading(){
        
        activityIndicator.stopAnimating();
        UIApplication.shared.endIgnoringInteractionEvents();
        
    }
    
    
    /*
     Login Button Click Event Handler
 */
    @IBAction func loginButtonPressed(_ sender: Any) {
        if(!self.userNameInout.text!.isEmpty && !self.passwordInput.text!.isEmpty) {
            startLoading();
            let userName = self.userNameInout.text
            let password = self.passwordInput.text
            APIConnectionManager.sharedInstance.authenticateUser(userName: userName, password: password)
            
        } else {
                let alertController = UIAlertController(title: "Credential Alert!", message: "Please Enter Valid UserName and Password! ", preferredStyle: .alert)
                
                // Create the actions
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                    self.dismiss(animated: true, completion: nil)
                    
                }))
                self.present(alertController, animated: true, completion: nil)
                stopLoading()
            
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        userNameInout.borderStyle = .none
        passwordInput.borderStyle = .none

        APIConnectionManager.sharedInstance.delegate = self
        
    }
}

/*
 Extension can also beconsidered as  default implementation for delegate methods
 */

extension LoginViewController: APIConnectionDelegate {
    func didReceiveError(_ err: String) {
            let alertController = UIAlertController(title: "Credential Alert!", message: "\(err) ", preferredStyle: .alert)
            
            // Create the actions
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                self.dismiss(animated: true, completion: nil)
                
            }))
        self.present(alertController, animated: true, completion: nil)
        stopLoading()

    }
    
    func didReceiveData(_ data: Any) {

        let topMostVC: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        let storyBoard: UIStoryboard = UIStoryboard(name: "BookListViewController", bundle: nil)
        let bookListViewController = storyBoard.instantiateViewController(withIdentifier: "BookListVC")
        topMostVC.show(bookListViewController, sender: self)
        
        stopLoading()

    }
}
