//
//  Task.swift
//  TRACE
//
//  Created by Matt Thomas on 10/27/20.
//

import Foundation

//Instantiate as needed
// USED TO BE TASK.SWIFT, for this branch going to use this for environment object
class Event : Identifiable {
    var uid = UUID()
    var subject: String         // description
    var start_time: Int         // starting time
    var end_time: Int           // ending time
    var color: String           // color
    var type: String       // type
    
    init (subject: String, start_time: Int, end_time: Int, color: String, type: String) {
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
    
    func get_type () -> String {
        return self.type
    }
    
    func set_type (by type: String) {
        self.type = type
        return
    }
    
}
