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
    static var tasks = [Event]()
    static var taskLengths = [[CGPoint]]()
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
                LineView.tasks = [Event]()
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
                    
                    if (type == "task"){
                        let newTask = Event(subject: "Subject", start_time: dateFormatterOrig.date(from: start)!, end_time: dateFormatterOrig.date(from: end)!, color: color, type: type)
                        LineView.tasks.append(newTask)
                    }
                    else if(type == "alert"){
                        let newAlert = Alert(fromSubject: "Subject", fromStart_time: startTime, fromEnd_time: endTime, fromColor: color, fromTask_name: name)
                        LineView.alerts.append(newAlert)
                    }
                    else if(type == "cue"){
                        let newCue = Cue(fromSubject: "Subject", fromStart_time: startTime, fromEnd_time: endTime, fromColor: color, fromTask_name: name)
                        LineView.cues.append(newCue)
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
        
        var newTaskLengths = [[CGPoint]]()
        for i in CircleView.tasks {
            let startTime = i.get_start_time()
            let endTime = i.get_end_time()
            let startOffset = Calendar.current.dateComponents([.minute], from: Date(), to: startTime)
            let minutesFromStart = Int(startOffset.minute!)
            let endOffset = Calendar.current.dateComponents([.minute], from: Date(), to: endTime)
            let minutesFromEnd = Int(endOffset.minute!)
            
            do {
                newTaskLengths.append( [try CGPoint(from: Double(360*minutesFromStart/1440) as! Decoder), try CGPoint(from: Double(360*minutesFromEnd/1440) as! Decoder)])

            } catch{}
        }
        taskLengths = newTaskLengths
    }
    
    static func scale () {
        
    }

}
