//  TRACETests.swift
//  TRACETests
//
//  Created by Tony Schulz on 10/28/20.
//
 
//var sut: TRACEApp!
 
import XCTest
import Foundation
@testable import TRACE
 
class TRACETests: XCTestCase {
 
    override func setupWithError() throws{
        super.setUp()
        //sut = TRACEApp()
    }
   
    override func tearDownWithErro() throws {
        //sut = nil
        super.tearDown()
    }
 
//Tests for Task
    func testTaskInitAndGetters() throws {
        let testTask: Task = Task(fromSubject: "subject", fromStart_time: 1, fromEnd_time: 2, fromColorHex: [1,2,3], fromTask_name: "name")
        XCAssertEqual(testTask.get_subject(), "subject")
        XCAssertEqual(testTask.get_start_time(), 1)
        XCAssertEqual(testTask.get_end_time(), 2)
        XCAssertEqual(testTask.get_colorHex()[0], 1)
        XCAssertEqual(testTask.get_task_name(), "name")
       
    }
   
    func testAlertInitAndGetters() throws {
        let testAlert: Alert = Alert(fromSubject: "subject", fromStart_time: 1, fromEnd_time: 2, fromColorHex: [1,2,3], fromTask_name: "name")
        XCAssertEqual(testAlert.get_subject(), "subject")
        XCAssertEqual(testAlert.get_start_time(), 1)
        XCAssertEqual(testAlert.get_end_time(), 2)
        XCAssertEqual(testAlert.get_colorHex()[0], 1)
        XCAssertEqual(testAlert.get_task_name(), "name")
       
    }
   
    func testCueInitAndGetters() throws {
        let testCue: Cue = Cue(fromSubject: "subject", fromStart_time: 1, fromEnd_time: 2, fromColorHex: [1,2,3], fromTask_name: "name")
        XCAssertEqual(testCue.get_subject(), "subject")
        XCAssertEqual(testCue.get_start_time(), 1)
        XCAssertEqual(testCue.get_end_time(), 2)
        XCAssertEqual(testCue.get_colorHex()[0], 1)
        XCAssertEqual(testCue.get_task_name(), "name")
       
    }
 
 
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
 
}
