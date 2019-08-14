//
//  BookStorageTests.swift
//  BookStorageTests
//
//  Created by Poonam Yadav on 11/08/19.
//  Copyright © 2019 poonamyadav. All rights reserved.
//

import XCTest
@testable import BookStorage

class BookStorageTests: XCTestCase {
    
    private var rootVC: LoginViewController!
    private var apiDelegate: APIConnectionDelegate!


    override func setUp() {
        super.setUp()
        rootVC = LoginViewController()
        apiDelegate  = rootVC
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        rootVC = nil
        apiDelegate = nil
        super.tearDown()

    }

    func testLoginShouldCallIBActionLogin() {
        rootVC.userNameInout?.text = "hsbc"
        
//        XCTAssertEqual(rootVC.userNameInout?.text, "")
  //      XCTAssertEqual(rootVC.passwordInput.text, "")
        
        rootVC.userNameInout.text = "hsbc"
        rootVC.userNameInout.text = "123456"

        rootVC.loginButtonPressed((Any).self) //login(email: "EMAIL", password: "PASSWORD")

       // XCTAssertTrue(rootVC.isViewLoaded, "Login View Controller loaded successfully!")
    }
    
  

    
    func testLogin() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        let _ = vc.view
        
        vc.userNameInout!.text = "hsbc"
        vc.passwordInput!.text = ""
        
        vc.loginButtonPressed((Any).self)
        XCTAssertTrue(vc.passwordInput.text!.isEmpty, "Password is not empty, rather it contain empty string")
        XCTAssertEqual("hsbc", vc.userNameInout!.text!)

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
