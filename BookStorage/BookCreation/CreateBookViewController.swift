//
//  CreateBookVC.swift
//  BookStorage
//
//  Created by Poonam Yadav on 12/08/19.
//  Copyright © 2019 poonamyadav. All rights reserved.
//

import Foundation
import UIKit

class CreateBookViewController: UIViewController {
    

    @IBOutlet var ISBNValue: UITextField!
    
    @IBOutlet var bookTitle: UITextField!
    
    @IBOutlet var bookPublisher: UITextField!
    
    @IBOutlet var bookAuthor: UITextField!
    
    @IBOutlet var bookImage: UITextField!
    
    
    
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

    
    override func viewDidLoad() {
        ISBNValue.borderStyle = .none
        bookTitle.borderStyle = .none
        bookPublisher.borderStyle = .none
        bookAuthor.borderStyle = .none
        bookImage.borderStyle = .none
        APIConnectionManager.sharedInstance.delegate = self
    }
    
    @IBAction func createBook(sender: AnyObject) {
    
        if(ISBNValue.text!.isEmpty ||  bookTitle.text!.isEmpty || bookAuthor.text!.isEmpty || bookPublisher.text!.isEmpty || bookImage.text!.isEmpty) {
            let alertController = UIAlertController(title: "INFO!", message: "Please Fill Each Input Fields!", preferredStyle: .alert)
            // Create the actions
            alertController.addAction(UIAlertAction(title: "OKAY", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            }))
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
            
        }
        APIConnectionManager.sharedInstance.createBook(isbn: ISBNValue.text!, title: bookTitle.text!, author: bookAuthor.text!, publisher: bookPublisher.text!, image: bookImage.text!)
        
    }
    
}


extension CreateBookViewController: APIConnectionDelegate {
    func didReceiveError(_ err: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Oops!", message: "Failed to create Book!", preferredStyle: .alert)
            // Create the actions
            alertController.addAction(UIAlertAction(title: "OKAY", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            //    self.navigationController?.popViewController(animated: true)
            }))
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    func didReceiveData(_ data: Any) {
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Bingo!", message: "Book Created Successfully!", preferredStyle: .alert)
            // Create the actions
            alertController.addAction(UIAlertAction(title: "OKAY", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
               // self.navigationController?.popViewController(animated: true)
                
                
                let topMostVC: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                let storyBoard: UIStoryboard = UIStoryboard(name: "BookListViewController", bundle: nil)
                let bookListViewController = storyBoard.instantiateViewController(withIdentifier: "BookListVC")
                topMostVC.show(bookListViewController, sender: self)
                
            }))
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
}

