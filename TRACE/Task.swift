//
//  Task.swift
//  TRACE
//
//  Created by Matt Thomas on 10/27/20.
//

import Foundation

//Instantiate as needed
// USED TO BE TASK.SWIFT, for this branch going to use this for environment object
class Task : Identifiable {
    var uid = UUID()
    var subject: String         // description
    var start_time: Date         // starting time
    var end_time: Date           // ending time
    var color: String           // color
    var type: String       // type
    
    init (subject: String, start_time: Date, end_time: Date, color: String, type: String) {
        self.subject = subject
        self.start_time = start_time
        self.end_time = end_time
        self.color = color
        self.type = type
    }
    
    func get_subject () -> String {
        return self.subject
    }
    
    func set_subject (by subject: String) {
        self.subject = subject
        return
    }
    
    func get_start_time () -> Date {
        return self.start_time
    }
    
    func set_start_time (by start_time: Date) {
        self.start_time = start_time
        return
    }
    
    func get_end_time () -> Date {
        return self.end_time
    }
    
    func set_end_time (by end_time: Date) {
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
    
    func get_type () -> String {
        return self.type
    }
    
    func set_type (by type: String) {
        self.type = type
        return
    }
    
}
