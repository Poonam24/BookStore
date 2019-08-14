//
//  APIConnectionController.swift
//  BookStorage
//
//  Created by Poonam Yadav on 11/08/19.
//  Copyright © 2019 poonamyadav. All rights reserved.
//

import Foundation
import UIKit


/*
 APIConnectionDelegate methods are being implemented by respective controllers and those methods are invoked on completion of SignIn, Listing and Create Book API
 */
protocol APIConnectionDelegate : class {
    func didReceiveData(_ data: Any)
    func didReceiveError(_ err: String)
    
}



/*
 APIConnectionManager is to make network connection and do the main business logic of applications
 The communication between APIConnectionManager and other ViewControllers is done through delegate design pattern!
 */

class APIConnectionManager : NSObject {
    
    weak var delegate: APIConnectionDelegate?
    
    // Singleton Instance, as authenticationToken being used as parameter for different API which are getting invoked from different ViewController.
    static let sharedInstance = APIConnectionManager()
    
    private override init() {
        
    }
    var authenticationToken : String? = ""
    var userName, password : String?
    var contentsArrayForTable  : Array<Any>? = []
    
    /*
     Function used to authenticate the user credentials. On success, control goes back to  LoginViewController through delegate method named didReceiveData.
     On Error, another method named didReceiveError gets called and user gets alert for failure case!
     */
    
    func authenticateUser(userName : String?, password : String?){
        
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Basic aHNiYzoxMjM0NTY="
        ]
       
        let postData = NSMutableData(data: "username=\(userName!)".data(using: String.Encoding.utf8)!)
        postData.append("&password=\(password!)".data(using: String.Encoding.utf8)!)
        
        
        let request = NSMutableURLRequest(url: NSURL(string: "\(Constants.init().baseURL)/signin")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) -> Void in
            let httpResponse = response as? HTTPURLResponse
            if(httpResponse?.statusCode == 200) {
                do {
                    let responseDataAsArray = try JSONSerialization.jsonObject(with: data!, options:[])
                    self.authenticationToken = ((responseDataAsArray as AnyObject).object(forKey: "token")) as? String
                    DispatchQueue.main.async {
                        self.delegate?.didReceiveData(responseDataAsArray)
                    }
                }
                catch {
                    print("JSONSerialization error:", error)
                }
            } else if(httpResponse?.statusCode != 200 || error != nil){
                DispatchQueue.main.async {
                    self.delegate?.didReceiveError(error?.localizedDescription ?? Constants.init().defaultErrorMessage)
                }
            }
        })
        
        dataTask.resume()
        
    }
    
    
    /*
     Function used to list of books for loggedIn User as it takes authenticationToken as part of  header. On success, control goes back to  BookListViewController through delegate method named didReceiveData.
     On Error, another method named didReceiveError gets called and user gets alert for failure case!
     */
    
    func getListofBooks()  {
        
        let headers = [
            "Authorization": APIConnectionManager.sharedInstance.authenticationToken,
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "\(Constants.init().baseURL)/book")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.allHTTPHeaderFields = headers as? [String : String] //as? [String : String]
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            let httpResponse = response as? HTTPURLResponse
            if(httpResponse?.statusCode == 200) {
                do {
                    
                    let responseDataAsArray =  try JSONSerialization.jsonObject(with: data!, options:.mutableLeaves) //as! NSArray
                    
                    DispatchQueue.main.async {
                        self.delegate?.didReceiveData(responseDataAsArray)
                        
                    }
                }
                catch {
                    print("JSONSerialization error:", error)
                }
            } else if(httpResponse?.statusCode != 200 || error != nil){
                DispatchQueue.main.async {
                    self.delegate?.didReceiveError(error?.localizedDescription ?? Constants.init().defaultErrorMessage)
                }
            }
            
        })
        
        dataTask.resume()
    }
    
    /*
     Function used to create of books for loggedIn User as it takes authenticationToken as part of  header. On success, control goes back to  CreateBookViewController through delegate method named didReceiveData.
     On Error, another method named didReceiveError gets called and user gets alert for failure case!
     */
    
    func createBook (isbn : String, title : String, author : String, publisher : String, image : String) {
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": APIConnectionManager.sharedInstance.authenticationToken
        ]
        
        let postData = NSMutableData(data: "isbn=\(isbn)".data(using: String.Encoding.utf8)!)
        postData.append("&title=\(title)".data(using: String.Encoding.utf8)!)
        postData.append("&author=\(author)".data(using: String.Encoding.utf8)!)
        postData.append("&publisher=\(publisher)".data(using: String.Encoding.utf8)!)
        postData.append("&image=\(image)".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: "\(Constants.init().baseURL)/book")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.allHTTPHeaderFields = (headers as! [String : String])
        request.httpMethod = "POST"
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            let httpResponse = response as? HTTPURLResponse
            if(httpResponse?.statusCode == 200) {
                self.delegate?.didReceiveData(String(data: data!, encoding: String.Encoding.utf8)!);
            } else if(httpResponse?.statusCode != 200 || error != nil){
                DispatchQueue.main.async {
                    self.delegate?.didReceiveError(error?.localizedDescription ?? Constants.init().defaultErrorMessage)
                }
            }
        })
        dataTask.resume()
    }
}

