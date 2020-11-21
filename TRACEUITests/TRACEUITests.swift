//
//  TRACEUITests.swift
//  TRACEUITests
//
//  Created by Tony S on 11/18/20.
//  Note - the UI tests will fail if you don't use your own email and sign in on the simulated iphone

import XCTest

class TRACEUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSwitchToLineMode() throws {
        // UI tests must launch the application that they test.
//        let app = XCUIApplication()
//        app.launch()
        
        let app = XCUIApplication()
        app.launch()
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("tonytonys123@gmail.com")
        app.buttons["Send Sign In Link / Login"].tap()
        app.buttons["menu_icon, menu_arrow"].tap()
        app.buttons["Line Mode"].tap()
        app.buttons["Line Mode"].tap()
        app.buttons["Line Mode"].tap()
        app.terminate()
        
    }
    
    func testToggleDarkMode() throws {
        let app = XCUIApplication()
        app.launch()
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("tonytonys123@gmail.com")
        app.buttons["Send Sign In Link / Login"].tap()
        app.buttons["menu_icon, menu_arrow"].tap()
        app.buttons["Dark Mode"].tap()
        app.buttons["Dark Mode"].tap()
        app.buttons["Dark Mode"].tap()
        app.terminate()
        
        
        

    }
    
    func testToggle24HourFormat() throws {
        let app = XCUIApplication()
        app.launch()
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("tonytonys123@gmail.com")
        app.buttons["Send Sign In Link / Login"].tap()
        app.buttons["menu_icon, menu_arrow"].tap()
        app.buttons["24 Hour Format"].tap()
        app.buttons["24 Hour Format"].tap()
        app.buttons["24 Hour Format"].tap()
        app.terminate()
    }
    
//    func testEditEvent()throws{
////        let app = XCUIApplication()
////        app.launch()
////        app.textFields["Email"].tap()
////        app.textFields["Email"].typeText("tonytonys123@gmail.com")
////        app.buttons["Send Sign In Link / Login"].tap()
//
//        let app = XCUIApplication()
//        app.staticTexts["Next:\nWork Shift"].tap()
//        app.buttons["Send Sign In Link / Login"].tap()
//
//
//
//
//
//
//
//
//
//
//    }

    
}
