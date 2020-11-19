//
//  TRACEUITests.swift
//  TRACEUITests
//
//  Created by Tony S on 11/16/20.
//

import XCTest

class TRACEUITests: XCTestCase {
    var app: XCUIApplication!


//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//
//        // In UI tests it is usually best to stop immediately when a failure occurs.
//        super.setUp()
//        continueAfterFailure = false
//        app.launchArguments.append("--uitesting")
//        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
//    }

//    override func tearDownWithError() throws {
//
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }

    func testLoginWithInvalidEmail() throws {
        // UI tests must launch the application that they test.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        let app = XCUIApplication()
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.tap()
        app.buttons["Send Sign In Link / Login"].tap()
        emailTextField.tap()
        app.alerts["The sign in link could not be sent."].scrollViews.otherElements.buttons["OK"].tap()
        XCTAssert(true)

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
