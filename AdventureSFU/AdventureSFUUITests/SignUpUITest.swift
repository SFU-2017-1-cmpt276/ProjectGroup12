//
//  SignUpUITest.swift
//  AdventureSFU
//
//  Created by Karan Aujla on 4/3/17.
//  Copyright © 2017 Karan Aujla. All rights reserved.
//

import XCTest

class SignUpUITest: XCTestCase {
    
    var app: XCUIApplication!
   
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        
        //get to the screen related to this test class
        XCUIApplication().buttons["Create Account"].tap()
        
        //declare some common uielements in all the tests
       
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        app = nil
    }
    
    func testOnlyUsername() {
        
        let app = XCUIApplication()
        let usernameTextField = app.scrollViews.otherElements.children(matching: .textField).matching(identifier: "Username").element(boundBy: 1)
        usernameTextField.tap()
        usernameTextField.typeText("askldlasjf")
        app.typeText("\r")
        app.buttons["Create Account"].tap()
        
        let fieldsMissingAlert = app.alerts["Fields Missing!"]
        let fieldsMissingMessage = fieldsMissingAlert.staticTexts["Please enter an email, username, and password!"]
        
        //assert that both the alert and correct message exists
        XCTAssertTrue(fieldsMissingAlert.exists && fieldsMissingMessage.exists)

        // fieldsMissingAlert.buttons["Ok"].tap()
        
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func testOnlyEmail(){
        
        let app = XCUIApplication()
        app.scrollViews.otherElements.textFields["@address.com"].tap()
        app.scrollViews.otherElements.textFields["@address.com"].typeText("ktesting")
        app.typeText("\r")
        app.buttons["Create Account"].tap()
        
        let fieldsMissingAlert = app.alerts["Fields Missing!"]
        let fieldsMissingMessage = fieldsMissingAlert.staticTexts["Please enter an email, username, and password!"]
        
         XCTAssertTrue(fieldsMissingAlert.exists && fieldsMissingMessage.exists)
        
    }
    func testOnlyPassword(){
        
        let app = XCUIApplication()
        let passwordSecureTextField = app.scrollViews.otherElements.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("A123456")
        app.typeText("\r")
        app.buttons["Create Account"].tap()
        
        let fieldsMissingAlert = app.alerts["Fields Missing!"]
        let fieldsMissingMessage = fieldsMissingAlert.staticTexts["Please enter an email, username, and password!"]
        
        
        XCTAssertTrue(fieldsMissingMessage.exists && fieldsMissingAlert.exists)
        
    
    }
    func testWeakPasswordTooShort(){
        XCUIApplication().buttons["Create Account"].tap()
        
        let scrollViewsQuery = XCUIApplication().scrollViews
        let usernameTextField = scrollViewsQuery.otherElements.children(matching: .textField).matching(identifier: "Username").element(boundBy: 1)
        usernameTextField.tap()
        usernameTextField.typeText("kaan")
        
        let addressComTextField = XCUIApplication().scrollViews.otherElements.textFields["@address.com"]
        addressComTextField.tap()
        addressComTextField.typeText("k@S.CA")
        
        let app = XCUIApplication()
        let passwordSecureTextField = app.scrollViews.otherElements.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("A1")
        
        app.buttons["Create Account"].tap()
        
        let accountCreationIssueAlert = app.alerts["Account Creation Issue!"]
        let shortPasswordText = accountCreationIssueAlert.staticTexts["The password must be 6 characters long or more."]
        
        XCTAssertTrue(shortPasswordText.exists)
        
        
    }
    
}
