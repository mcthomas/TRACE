//
//  Cue.swift
//  TRACE
//
//  Created by Matt Thomas on 10/27/20.
//

import Foundation

//Instantiate as needed
class Cue {
    var subject: String
    var start_time: Int
    var end_time: Int
    var color: String
    var cue_name: String
    
    init (fromSubject subject: String, fromStart_time start_time: Int, fromEnd_time end_time: Int, fromColor color: String, fromTask_name task_name: String) {
        self.subject = subject
        self.start_time = start_time
        self.end_time = end_time
        self.color = color
        self.cue_name = task_name
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
    
    func get_color () -> String {
        return self.color
    }
    
    func set_color (by color: String) {
        self.color = color
        return
    }
    
    func get_task_name () -> String {
        return self.cue_name
    }
    
    func set_task_name (by task_name: String) {
        self.cue_name = task_name
        return
    }
    
}
