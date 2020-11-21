//  TRACETests.swift
//  TRACETests
//
//  Created by Tony Schulz on 10/28/20.
//
 
//var sut: TRACEApp!
 
import XCTest
import Foundation
import Firebase
@testable import TRACE
 
class TRACETests: XCTestCase {
 
    func setupWithError() throws{
        super.setUp()
        //sut = TRACEApp()
    }
   
    func tearDownWithErro() throws {
        //sut = nil
        super.tearDown()
    }
 
//Tests for Task
    func testTaskInitAndGetters() throws {
        let testTask: Task = Task(subject: "subject", start_time: 1, end_time: 2, color: "blue", type: "task")
        XCTAssertEqual(testTask.get_subject(), "subject")
        XCTAssertEqual(testTask.get_start_time(), 1)
        XCTAssertEqual(testTask.get_end_time(), 2)
        XCTAssertEqual(testTask.get_color(), "blue")
       
    }
   
    func testAlertInitAndGetters() throws {
        let testAlert: Alert = Alert(fromSubject: "subject", fromStart_time: 1, fromEnd_time: 2, fromColor: "blue", fromTask_name: "name")
        XCTAssertEqual(testAlert.get_subject(), "subject")
        XCTAssertEqual(testAlert.get_start_time(), 1)
        XCTAssertEqual(testAlert.get_end_time(), 2)
        XCTAssertEqual(testAlert.get_color(), "blue")
        XCTAssertEqual(testAlert.get_task_name(), "name")
       
    }
   
    func testCueInitAndGetters() throws {
        let testCue: Cue = Cue(fromSubject: "subject", fromStart_time: 1, fromEnd_time: 2, fromColor: "blue", fromTask_name: "name")
        XCTAssertEqual(testCue.get_subject(), "subject")
        XCTAssertEqual(testCue.get_start_time(), 1)
        XCTAssertEqual(testCue.get_end_time(), 2)
        XCTAssertEqual(testCue.get_color(), "blue")
        XCTAssertEqual(testCue.get_task_name(), "name")
       
    }
    
    func testCircleViewArrangeChrono(){
        let testCircle: CircleView = CircleView()
        CircleView.tasks.append(Task(subject: "subject1", start_time: 10, end_time: 20, color: "blue", type: "task"))
        CircleView.tasks.append(Task(subject: "subject2", start_time: 1, end_time: 2, color: "blue", type: "task"))
        CircleView.tasks.append(Task(subject: "subject3", start_time: 5, end_time: 15, color: "blue", type: "task"))
        
        CircleView.alerts.append(Alert(fromSubject: "subject1", fromStart_time: 10, fromEnd_time: 20, fromColor: "blue", fromTask_name: "name1"))
        CircleView.alerts.append(Alert(fromSubject: "subject2", fromStart_time: 1, fromEnd_time: 2, fromColor: "blue", fromTask_name: "name2"))
        CircleView.alerts.append(Alert(fromSubject: "subject3", fromStart_time: 5, fromEnd_time: 15, fromColor: "blue", fromTask_name: "name3"))
        
        CircleView.cues.append(Cue(fromSubject: "subject", fromStart_time: 10, fromEnd_time: 20, fromColor: "blue", fromTask_name: "name1"))
        CircleView.cues.append(Cue(fromSubject: "subject", fromStart_time: 1, fromEnd_time: 2, fromColor: "blue", fromTask_name: "name2"))
        CircleView.cues.append(Cue(fromSubject: "subject3", fromStart_time: 5, fromEnd_time: 15, fromColor: "blue", fromTask_name: "name3"))
        
        testCircle.arrangeChrono()
        
        
        XCTAssertEqual(CircleView.tasks[0].get_subject(), "subject2")
        XCTAssertEqual(CircleView.tasks[1].get_subject(), "subject3")
        XCTAssertEqual(CircleView.tasks[2].get_subject(), "subject1")

        XCTAssertEqual(CircleView.alerts[0].get_task_name(), "name2")
        XCTAssertEqual(CircleView.alerts[1].get_task_name(), "name3")
        XCTAssertEqual(CircleView.alerts[2].get_task_name(), "name1")

        XCTAssertEqual(CircleView.cues[0].get_task_name(), "name2")
        XCTAssertEqual(CircleView.cues[1].get_task_name(), "name3")
        XCTAssertEqual(CircleView.cues[2].get_task_name(), "name1")

    }
    
    func testCircleViewAssignColors() {
        let testCircle: CircleView = CircleView()
        CircleView.tasks.append(Task(subject: "subject1", start_time: 10, end_time: 20, color: "red", type: "task"))
        CircleView.tasks.append(Task(subject: "subject1", start_time: 10, end_time: 20, color: "red", type: "task"))
        
        CircleView.alerts.append(Alert(fromSubject: "subject", fromStart_time: 10, fromEnd_time: 20, fromColor: "green", fromTask_name: "name1"))
        CircleView.alerts.append(Alert(fromSubject: "subject", fromStart_time: 1, fromEnd_time: 2, fromColor: "green", fromTask_name: "name2"))
        
        CircleView.cues.append(Cue(fromSubject: "subject", fromStart_time: 10, fromEnd_time: 20, fromColor: "green", fromTask_name: "name1"))
        CircleView.cues.append(Cue(fromSubject: "subject", fromStart_time: 1, fromEnd_time: 2, fromColor: "green", fromTask_name: "name2"))
        
        testCircle.assignColors()
        
        XCTAssertEqual(CircleView.tasks[0].get_color(), "blue")
        XCTAssertEqual(CircleView.alerts[0].get_color(), "#ff000")
        XCTAssertEqual(CircleView.cues[0].get_color(), "red")
        
    }
    
    
    func testLineViewArrangeChrono(){
        //let testLine: LineView = LineView()
        LineView.tasks.append(Task(subject: "subject1", start_time: 10, end_time: 20, color: "blue", type: "task"))
        LineView.tasks.append(Task(subject: "subject2", start_time: 1, end_time: 2, color: "blue", type: "task"))
        LineView.tasks.append(Task(subject: "subject3", start_time: 5, end_time: 15, color: "blue", type: "task"))
        
        LineView.alerts.append(Alert(fromSubject: "subject1", fromStart_time: 10, fromEnd_time: 20, fromColor: "blue", fromTask_name: "name1"))
        LineView.alerts.append(Alert(fromSubject: "subject2", fromStart_time: 1, fromEnd_time: 2, fromColor: "blue", fromTask_name: "name2"))
        LineView.alerts.append(Alert(fromSubject: "subject3", fromStart_time: 5, fromEnd_time: 15, fromColor: "blue", fromTask_name: "name3"))
        
        LineView.cues.append(Cue(fromSubject: "subject", fromStart_time: 10, fromEnd_time: 20, fromColor: "blue", fromTask_name: "name1"))
        LineView.cues.append(Cue(fromSubject: "subject", fromStart_time: 1, fromEnd_time: 2, fromColor: "blue", fromTask_name: "name2"))
        LineView.cues.append(Cue(fromSubject: "subject3", fromStart_time: 5, fromEnd_time: 15, fromColor: "blue", fromTask_name: "name3"))
        
        LineView.arrangeChrono()
        
        XCTAssertEqual(LineView.tasks[0].get_subject(), "subject2")
        XCTAssertEqual(LineView.tasks[1].get_subject(), "subject3")
        XCTAssertEqual(LineView.tasks[2].get_subject(), "subject1")

        XCTAssertEqual(LineView.alerts[0].get_task_name(), "name2")
        XCTAssertEqual(LineView.alerts[1].get_task_name(), "name3")
        XCTAssertEqual(LineView.alerts[2].get_task_name(), "name1")

        XCTAssertEqual(LineView.cues[0].get_task_name(), "name2")
        XCTAssertEqual(LineView.cues[1].get_task_name(), "name3")
        XCTAssertEqual(LineView.cues[2].get_task_name(), "name1")


    }
    
    func testLineViewAssignColors() {
        let testLine: LineView = LineView()
        LineView.tasks.append(Task(subject: "subject1", start_time: 10, end_time: 20, color: "blue", type: "task"))
        LineView.tasks.append(Task(subject: "subject1", start_time: 10, end_time: 20, color: "blue", type: "task"))
        
        LineView.alerts.append(Alert(fromSubject: "subject", fromStart_time: 10, fromEnd_time: 20, fromColor: "green", fromTask_name: "name1"))
        LineView.alerts.append(Alert(fromSubject: "subject", fromStart_time: 1, fromEnd_time: 2, fromColor: "green", fromTask_name: "name2"))
        
        LineView.cues.append(Cue(fromSubject: "subject", fromStart_time: 10, fromEnd_time: 20, fromColor: "yellow", fromTask_name: "name1"))
        LineView.cues.append(Cue(fromSubject: "subject", fromStart_time: 1, fromEnd_time: 2, fromColor: "yellow", fromTask_name: "name2"))
        
        LineView.assignColors()
        
        XCTAssertEqual(LineView.tasks[0].get_color(), "RED")
        XCTAssertEqual(LineView.alerts[0].get_color(), "BLUE")
        XCTAssertEqual(LineView.cues[0].get_color(), "GREEN")
        
    }
    
    
    func testTaskArrayPopulate(){
        
    }
    


 
    func testPerformanceCreateAccount() throws {
        // This is an example of a performance test case.
        measure {
            
            // Put the code you want to measure the time of here.
//            var testView: ContentView = ContentView()
//            testView.data.loggedIn = false
            
            
            
            
        }
    }
 
}

