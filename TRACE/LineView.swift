//
//  LineView.swift
//  TRACE
//
//  Created by Matt Thomas on 10/27/20.
//

import Foundation
import SwiftUI
import Firebase

//Only instantiate ONCE
class LineView {
    static var tasks = [Task]()
    static var taskLengths = [Int]()
    static var alerts = [Alert]()
    static var cues = [Cue]()
    static var colors = ["#ff0000", "#56cfda", "#31b941", "#dcb832", "#eb56c1"]
    
    static func getEvents(email: String){
            
            var finalEmail = email.replacingOccurrences(of: "@", with: "", options: NSString.CompareOptions.literal, range: nil)
            finalEmail = finalEmail.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range: nil)
            //Create DateFormatter
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            ref.child(finalEmail).observeSingleEvent(of: .value, with: { (snapshot) in
                LineView.tasks = [Task]()
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let name = snap.key
                    let value = snap.value as? NSDictionary
                    let start = value?["Start Date"] as? String ?? ""
                    let end = value?["End Date"] as? String ?? ""
                    let type = value?["Type"] as? String ?? ""
                    let color = value?["Color"] as? String ?? ""
                    let calendar = Calendar.current
     
                    let dateFormatterOrig = DateFormatter()
 
                    dateFormatterOrig.locale = Locale(identifier: "en_US_POSIX")
                    dateFormatterOrig.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                    
                    var startTime = 0
                    var endTime = 0
                    if start != ""{
                        let startDate = dateFormatterOrig.date(from: start)!
                        let hourInMinutes = calendar.component(.hour, from: startDate) * 60
                        let minutes = calendar.component(.minute, from: startDate)
                        startTime = hourInMinutes + minutes as Int
                    }
                    
                    if end != "" {
                        let endDate = dateFormatterOrig.date(from: end)!
                        let hourInMinutes = calendar.component(.hour, from: endDate) * 60
                        let minutes = calendar.component(.minute, from: endDate)
                        endTime = hourInMinutes + minutes as Int
                    }
                    print(type)
                    print("new shit above")
                    if (type == "task"){
                        let newTask = Task(subject: "Subject", start_time: startTime, end_time: endTime, color: color, type: type)
                        self.tasks.append(newTask)
                        for n in self.tasks {
                            print(n)
                        }
                        print("TASKER")
                    }
                    else if(type == "alert"){
                        let newAlert = Alert(fromSubject: "Subject", fromStart_time: startTime, fromEnd_time: endTime, fromColor: color, fromTask_name: name)
                        self.alerts.append(newAlert)
                    }
                    else if(type == "cue"){
                        let newCue = Cue(fromSubject: "Subject", fromStart_time: startTime, fromEnd_time: endTime, fromColor: color, fromTask_name: name)
                        self.cues.append(newCue)
                    }
                }
              })
            
        }
    
    static func arrangeChrono () {
        tasks.sort {
            $0.start_time < $1.start_time
        }
        alerts.sort {
            $0.start_time < $1.start_time
        }
        cues.sort {
            $0.start_time < $1.start_time
        }
    }
    
    static func assignColors () {
        for i in tasks {
            i.set_color(by: "RED")
        }
        for i in alerts {
            i.set_color(by: "BLUE")
        }
        for i in cues {
            i.set_color(by: "GREEN")
        }
    }
    
    static func allocateLengths () {
        print(self.tasks.count)
        print("shit")
        var newTaskLengths = [Int]()
        for i in self.tasks {
            let startTime = i.get_start_time()
            let endTime = i.get_end_time()
            print(startTime)
            print("above for startTime")
            do {
                newTaskLengths.append(Int(360*startTime/1440))
            }
        }
        taskLengths = newTaskLengths
    }
    
    static func scale () {
        
    }

}
