//
//  TRACEUITests.swift
//  TRACEUITests
//  Note: some tests will have to be run manually to verify that the displays look how we want them to.
//  Created by Tony S on 11/16/20.
//

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

    }

    
}
