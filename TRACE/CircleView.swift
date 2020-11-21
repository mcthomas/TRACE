//
//  CircleView.swift
//  TRACE
//
//  Created by Matt Thomas on 10/27/20.
//
 
import Foundation
import SwiftUI
import Firebase
 
//Only instantiate ONCE
class CircleView {
    static var tasks = [Event]()
    static var taskAngles = [[Angle]]()
    static var alerts = [Alert]()
    static var cues = [Cue]()
    
    static func getEvents(email: String){
            
            var finalEmail = email.replacingOccurrences(of: "@", with: "", options: NSString.CompareOptions.literal, range: nil)
            finalEmail = finalEmail.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range: nil)
            //Create DateFormatter
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            ref.child(finalEmail).observeSingleEvent(of: .value, with: { (snapshot) in
                CircleView.tasks = [Event]()
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
                        CircleView.tasks.append(newTask)
                    }
                    else if(type == "alert"){
                        let newAlert = Alert(fromSubject: "Subject", fromStart_time: startTime, fromEnd_time: endTime, fromColor: color, fromTask_name: name)
                        CircleView.alerts.append(newAlert)
                    }
                    else if(type == "cue"){
                        let newCue = Cue(fromSubject: "Subject", fromStart_time: startTime, fromEnd_time: endTime, fromColor: color, fromTask_name: name)
                        CircleView.cues.append(newCue)
                    }
                }
              })
            
        }
 
    
    
    func arrangeChrono () {
        CircleView.tasks.sort {
            $0.start_time < $1.start_time
        }
        CircleView.alerts.sort {
            $0.start_time < $1.start_time
        }
        CircleView.cues.sort {
            $0.start_time < $1.start_time
        }
    }
    
    func assignColors () {
        for i in CircleView.tasks {
            i.set_color(by: "blue")
        }
        for i in CircleView.alerts {
            i.set_color(by: "#ff000")
        }
        for i in CircleView.cues {
            i.set_color(by: "red")
        }
    }
    
    static func allocateAngles (){
        var newTaskAngles = [[Angle]]()
        for i in CircleView.tasks {
            let startTime = i.get_start_time()
            let endTime = i.get_end_time()
            let startOffset = Calendar.current.dateComponents([.minute], from: Date(), to: startTime)
            let minutesFromStart = Int(startOffset.minute!)
            let endOffset = Calendar.current.dateComponents([.minute], from: Date(), to: endTime)
            let minutesFromEnd = Int(endOffset.minute!)
            
            do {
                newTaskAngles.append( [try Angle.degrees(Double(360*minutesFromStart/1440)), try Angle.degrees(Double(360*minutesFromEnd/1440))])

            } catch{}
        }
        taskAngles = newTaskAngles
    }
 
    
    
    func scale () {
        
    }
 
}
