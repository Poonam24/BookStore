//
//  BookStorageUITests.swift
//  BookStorageUITests
//
//  Created by Poonam Yadav on 11/08/19.
//  Copyright © 2019 poonamyadav. All rights reserved.
//

import XCTest


class BookStorageUITests: XCTestCase {
    
    var app: XCUIApplication! = nil
    var vcLogin: LoginViewController!

    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication.init(bundleIdentifier: "com.poonamyadav.BookStorage")
        app.launch()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: LoginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vcLogin = vc
        _ = vcLogin.view // To call viewDidLoad

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.terminate()
    }
    
    
    func testLogin() {
        
        let enterNameTextField =  app.otherElements.textFields["userNameInput"]
        enterNameTextField.tap()
        enterNameTextField.setText(text: "hsbc", application: app)

        let enterPasswordTextField =  app.otherElements.secureTextFields["passwordInput"]
        enterPasswordTextField.tap()
        enterPasswordTextField.setText(text: "123456", application: app)

        //vcLogin?.loginButtonPressed(Any?.self)
        app.buttons["LogIn"]
        
        
    }
    
    
}


extension XCUIElement {
    // The following is a workaround for inputting text in the
    //simulator when the keyboard is hidden
    func setText(text: String, application: XCUIApplication) {
        UIPasteboard.general.string = text
        doubleTap()
        application.menuItems["Paste"].tap()
    }
}



