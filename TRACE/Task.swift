//
//  Task.swift
//  TRACE
//
//  Created by Matt Thomas on 10/27/20.
//

import Foundation

//Instantiate as needed
class Task {
    
    var subject: String
    var start_time: Int
    var end_time: Int
    var colorHex: String
    var task_name: String
    
    init (fromSubject subject: String, fromStart_time start_time: Int, fromEnd_time end_time: Int, fromColorHex colorHex: String, fromTask_name task_name: String) {
        self.subject = subject
        self.start_time = start_time
        self.end_time = end_time
        self.colorHex = colorHex
        self.task_name = task_name
    }
    
    func get_subject () -> String {
        return self.subject
    }
    
    func set_subject (by subject: String) {
        self.subject = subject
        return
    }
    
    func get_start_time () -> Int {
        return self.start_time
    }
    
    func set_start_time (by start_time: Int) {
        self.start_time = start_time
        return
    }
    
    func get_end_time () -> Int {
        return self.end_time
    }
    
    func set_end_time (by end_time: Int) {
        self.end_time = end_time
        return
    }
    
    func get_colorHex () -> String {
        return self.colorHex
    }
    
    func set_colorHex (by colorHex: String) {
        self.colorHex = colorHex
        return
    }
    
    func get_task_name () -> String {
        return self.task_name
    }
    
    func set_task_name (by task_name: String) {
        self.task_name = task_name
        return
    }
    
}
