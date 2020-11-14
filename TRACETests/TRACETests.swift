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
        let testTask: Task = Task(fromSubject: "subject", fromStart_time: 1, fromEnd_time: 2, fromColor: "blue", fromTask_name: "name")
        XCAssertEqual(testTask.get_subject(), "subject")
        XCAssertEqual(testTask.get_start_time(), 1)
        XCAssertEqual(testTask.get_end_time(), 2)
        XCAssertEqual(testTask.get_color(), "blue")
        XCAssertEqual(testTask.get_task_name(), "name")
       
    }
   
    func testAlertInitAndGetters() throws {
        let testAlert: Alert = Alert(fromSubject: "subject", fromStart_time: 1, fromEnd_time: 2, fromColor: "blue", fromTask_name: "name")
        XCAssertEqual(testAlert.get_subject(), "subject")
        XCAssertEqual(testAlert.get_start_time(), 1)
        XCAssertEqual(testAlert.get_end_time(), 2)
        XCAssertEqual(testAlert.get_color(), "blue")
        XCAssertEqual(testAlert.get_task_name(), "name")
       
    }
   
    func testCueInitAndGetters() throws {
        let testCue: Cue = Cue(fromSubject: "subject", fromStart_time: 1, fromEnd_time: 2, fromColor: "blue", fromTask_name: "name")
        XCAssertEqual(testCue.get_subject(), "subject")
        XCAssertEqual(testCue.get_start_time(), 1)
        XCAssertEqual(testCue.get_end_time(), 2)
        XCAssertEqual(testCue.get_color(), "blue")
        XCAssertEqual(testCue.get_task_name(), "name")
       
    }
    
    func testCircleViewArrangeChrono(){
        let testCircle: CircleView = CircleView()
        testCircle.tasks.append(Task(fromSubject: "subject1", fromStart_time: 10, fromEnd_time: 20, fromColor: "blue", fromTask_name: "name1"))
        testCircle.tasks.append(Task(fromSubject: "subject2", fromStart_time: 1, fromEnd_time: 2, fromColor: "blue", fromTask_name: "name2"))
        testCircle.tasks.append(Task(fromSubject: "subject3", fromStart_time: 5, fromEnd_time: 2, fromColor: "blue", fromTask_name: "name3"))
        
        testCircle.alerts.append(Alert(fromSubject: "subject1", fromStart_time: 10, fromEnd_time: 20, fromColor: "blue", fromTask_name: "name1"))
        testCircle.alerts.append(Alert(fromSubject: "subject2", fromStart_time: 1, fromEnd_time: 2, fromColor: "blue", fromTask_name: "name2"))
        testCircle.alerts.append(Alert(fromSubject: "subject3", fromStart_time: 5, fromEnd_time: 2, fromColor: "blue", fromTask_name: "name3"))
        
        testCircle.cues.append(Cue(fromSubject: "subject", fromStart_time: 10, fromEnd_time: 20, fromColor: "blue", fromTask_name: "name1"))
        testCircle.cues.append(Cue(fromSubject: "subject", fromStart_time: 1, fromEnd_time: 2, fromColor: "blue", fromTask_name: "name2"))
        testCircle.cues.append(Cue(fromSubject: "subject3", fromStart_time: 5, fromEnd_time: 2, fromColor: "blue", fromTask_name: "name3"))
        
        testCircle.arrangeChrono()
        
        
        XCTAssertEqual(testCircle.tasks[0].get_task_name(), "name2")
        XCTAssertEqual(testCircle.tasks[1].get_task_name(), "name3")
        XCTAssertEqual(testCircle.tasks[2].get_task_name(), "name1")

        XCTAssertEqual(testCircle.alerts[0].get_task_name(), "name2")
        XCTAssertEqual(testCircle.alerts[1].get_task_name(), "name3")
        XCTAssertEqual(testCircle.alerts[2].get_task_name(), "name1")

        XCTAssertEqual(testCircle.cues[0].get_task_name(), "name2")
        XCTAssertEqual(testCircle.cues[1].get_task_name(), "name3")
        XCTAssertEqual(testCircle.cues[3].get_task_name(), "name1")

    }
    
    func testCircleViewAssignColors() {
        let testCircle: CircleView = CircleView()
        testCircle.tasks.append(Task(fromSubject: "subject1", fromStart_time: 10, fromEnd_time: 20, fromColor: "green", fromTask_name: "name1"))
        testCircle.tasks.append(Task(fromSubject: "subject2", fromStart_time: 1, fromEnd_time: 2, fromColor: "green", fromTask_name: "name2"))
        
        testCircle.alerts.append(Alert(fromSubject: "subject", fromStart_time: 10, fromEnd_time: 20, fromColor: "green", fromTask_name: "name1"))
        testCircle.alerts.append(Alert(fromSubject: "subject", fromStart_time: 1, fromEnd_time: 2, fromColor: "green", fromTask_name: "name2"))
        
        testCircle.cues.append(Cue(fromSubject: "subject", fromStart_time: 10, fromEnd_time: 20, fromColor: "green", fromTask_name: "name1"))
        testCircle.cues.append(Cue(fromSubject: "subject", fromStart_time: 1, fromEnd_time: 2, fromColor: "green", fromTask_name: "name2"))
        
        testCircle.assignColors()
        
        XCTAssertEqual(testCircle.tasks[0].get_color(), "blue")
        XCTAssertEqual(testCircle.alerts[0].get_color(), "#ff000")
        XCTAssertEqual(testCircle.cues[0].get_color(), "red")
        
    }
    
    
    func testLineViewArrangeChrono(){
        let testLine: LineView = LineView()
        testLine.tasks.append(Task(fromSubject: "subject1", fromStart_time: 10, fromEnd_time: 20, fromColor: "blue", fromTask_name: "name1"))
        testLine.tasks.append(Task(fromSubject: "subject2", fromStart_time: 1, fromEnd_time: 2, fromColor: "blue", fromTask_name: "name2"))
        testLine.tasks.append(Task(fromSubject: "subject3", fromStart_time: 5, fromEnd_time: 2, fromColor: "blue", fromTask_name: "name3"))
        
        testLine.alerts.append(Alert(fromSubject: "subject", fromStart_time: 10, fromEnd_time: 20, fromColor: "blue", fromTask_name: "name1"))
        testLine.alerts.append(Alert(fromSubject: "subject2", fromStart_time: 1, fromEnd_time: 2, fromColor: "blue", fromTask_name: "name2"))
        testLine.alerts.append(Alert(fromSubject: "subject3", fromStart_time: 5, fromEnd_time: 2, fromColor: "blue", fromTask_name: "name3"))
        
        testLine.cues.append(Cue(fromSubject: "subject", fromStart_time: 10, fromEnd_time: 20, fromColor: "blue", fromTask_name: "name1"))
        testLine.cues.append(Cue(fromSubject: "subject2", fromStart_time: 1, fromEnd_time: 2, fromColor: "blue", fromTask_name: "name2"))
        testLine.cues.append(Cue(fromSubject: "subject3", fromStart_time: 5, fromEnd_time: 2, fromColor: "blue", fromTask_name: "name3"))
        
        testLine.arrangeChrono()
        
        XCTAssertEqual(testLine.tasks[0].get_task_name(), "name2")
        XCTAssertEqual(testLine.tasks[1].get_task_name(), "name3")
        XCTAssertEqual(testLine.tasks[2].get_task_name(), "name1")

        XCTAssertEqual(testLine.alerts[0].get_task_name(), "name2")
        XCTAssertEqual(testLine.alerts[1].get_task_name(), "name3")
        XCTAssertEqual(testLine.alerts[2].get_task_name(), "name1")

        XCTAssertEqual(testLine.cues[0].get_task_name(), "name2")
        XCTAssertEqual(testLine.cues[1].get_task_name(), "name3")
        XCTAssertEqual(testLine.cues[3].get_task_name(), "name1")


    }
    
    func testLineViewAssignColors() {
        let testLine: LineView = LineView()
        testLine.tasks.append(Task(fromSubject: "subject1", fromStart_time: 10, fromEnd_time: 20, fromColor: "green", fromTask_name: "name1"))
        testLine.tasks.append(Task(fromSubject: "subject2", fromStart_time: 1, fromEnd_time: 2, fromColor: "green", fromTask_name: "name2"))
        
        testLine.alerts.append(Alert(fromSubject: "subject", fromStart_time: 10, fromEnd_time: 20, fromColor: "green", fromTask_name: "name1"))
        testLine.alerts.append(Alert(fromSubject: "subject", fromStart_time: 1, fromEnd_time: 2, fromColor: "green", fromTask_name: "name2"))
        
        testLine.cues.append(Cue(fromSubject: "subject", fromStart_time: 10, fromEnd_time: 20, fromColor: "yellow", fromTask_name: "name1"))
        testLine.cues.append(Cue(fromSubject: "subject", fromStart_time: 1, fromEnd_time: 2, fromColor: "yellow", fromTask_name: "name2"))
        
        testLine.assignColors()
        
        XCTAssertEqual(testLine.tasks[0].get_color(), "RED")
        XCTAssertEqual(testLine.alerts[0].get_color(), "BLUE")
        XCTAssertEqual(testLine.cues[0].get_color(), "GREEN")
        
    }
    
    
    func testContentViewInit(){
        let testView: ContentView = ContentView()
        
        XCTAssertEqual(testView.index, 0)
        XCTAssertFalse(testView.alertToggled)
        XCTAssertFalse(testView.cueToggled)
        XCTAssertFalse(testView.taskToggled)
        XCTAssertEqual(testView.colorSelected, "RED")
        XCTAssertEqual(testView.description, "")
    }

 
    func testPerformanceCreateAccount() throws {
        // This is an example of a performance test case.
        measure {
            
            // Put the code you want to measure the time of here.
            var testView: ContentView = ContentView()
            testView.data.loggedIn = false
            
            
            
            
        }
    }
 
}

