//
//  BooksListViewController.swift
//  BookStorage
//
//  Created by Poonam Yadav on 11/08/19.
//  Copyright © 2019 poonamyadav. All rights reserved.
//

import Foundation
import UIKit


/*
 Class intend to show the list of Books on screen.
 */


class BookListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var navigationTitleItem: UINavigationItem!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var contentsArray = NSArray()
    
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

    
    @IBAction func navigateToCreateBookScreen(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "CreateBookViewController", bundle: nil)
        let createBookViewController = storyBoard.instantiateViewController(withIdentifier: "CreateBookVC")
        navigationController?.show(createBookViewController, sender: self)
    }
    
    override func viewDidLoad() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationTitleItem.hidesBackButton = true
        
        self.navigationItem.backBarButtonItem?.setBackgroundImage(UIImage.init(named: "Menu.png"), for: .normal, style: .plain, barMetrics: .`default`)
        APIConnectionManager.sharedInstance.delegate = self
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        startLoading();
        APIConnectionManager.sharedInstance.getListofBooks()
    }
    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      //  if(indexPath.row % 2 == 0) {
            return 130.0
      /*  } else {
            return 200.0
        } */
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contentsArray.count ;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : BookListCustomCell
        //         let defualtImageURL = URL.init(string: //"https://www.iconfinder.com/icons/2487618/finance_hsbc_logo_method_payment_icon") ;
     //   if(indexPath.row % 2 == 0) {
            cell = self.tableView.dequeueReusableCell(withIdentifier: "customCell") as! BookListCustomCell
            
       /* } else {
            cell = self.tableView.dequeueReusableCell(withIdentifier: "alternateRowCustomCell") as! BookListCustomCell
            
        }*/
        
        
        let  rowObject : NSDictionary = self.contentsArray[indexPath.row] as! NSDictionary
        
        cell.bookTitleLabel?.text = (rowObject.value(forKey: "title") as! String)
        cell.bookAuthorNameLabel?.text = (rowObject.value(forKey: "author") as! String)
        let urlString : String = (rowObject.value(forKey: "image") as! String)
        
        guard let imageURL : URL = URL.init(string: urlString) else {
            return cell
        }
        
        getData(from: imageURL) { data, response, error in
            guard let data = data, error == nil else { return }
            if (error != nil) {
                DispatchQueue.main.async() {
                    cell.bookIconView.image = UIImage(named: "hsbc-logo.png", in: Bundle(identifier: "bundleIdentifier"), compatibleWith: nil)
                }
            }
            DispatchQueue.main.async() {
                cell.bookIconView.image = UIImage(data: data)
            }
        }
        
        return cell
        
    }
}



/*
 Extension can also beconsidered as  default implementation for delegate methods
 */


extension BookListViewController: APIConnectionDelegate {
    func didReceiveError(_ err: String) {
        
         let alertController = UIAlertController(title: "Oops!", message: "Failed To List Book!", preferredStyle: .alert)
         
         // Create the actions
         alertController.addAction(UIAlertAction(title: "OKAY", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
         self.navigationController?.popViewController(animated: true)
         }))
         
         // Present the controller
         self.present(alertController, animated: true, completion: nil)
        stopLoading()

        
    }
    
    
    func didReceiveData(_ data: Any) {
        self.contentsArray = []
        self.contentsArray = data as! NSArray
        self.tableView.reloadData()
        stopLoading()
        
        
    }
}

