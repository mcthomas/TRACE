//
//  CircleView.swift
//  TRACE
//
//  Created by Matt Thomas on 10/27/20.
//

import Foundation
import SwiftUI

//Only instantiate ONCE
class CircleView {
    static var tasks = [Task.init(fromSubject: "Work", fromStart_time: 0, fromEnd_time: 720, fromColorHex: [255, 255, 255], fromTask_name: "Work Shift"), Task.init(fromSubject: "Relax", fromStart_time: 720, fromEnd_time: 1440, fromColorHex: [54, 52, 52], fromTask_name: "Listen to Music")]
    var alerts = [Alert]()
    var cues = [Cue]()
    var colors = [[54, 52, 52], [255, 255, 255],[247, 202, 89],[252, 76, 93],[114,224,110]
    ,[76,223,252]
    ,[129,79,255]
    ,[250,75,212]]
    

    
    
    func arrangeChrono () {
        CircleView.tasks.sort {
            $0.start_time < $1.start_time
        }
        alerts.sort {
            $0.start_time < $1.start_time
        }
        cues.sort {
            $0.start_time < $1.start_time
        }
    }
    
    func assignColors () {
        for i in CircleView.tasks {
            i.set_colorHex(by: colors[CircleView.tasks.count % colors.count])
        }
        for i in alerts {
            i.set_colorHex(by: "#ff000")
        }
        for i in cues {
            i.set_colorHex(by: "red")
        }
    }
    
    static func allocateAngles () -> [[Angle]]{
        var taskAngles = [[Angle]]()
        for i in CircleView.tasks {
            let startTime = i.get_start_time()
            let endTime = i.get_end_time()
            taskAngles.append( [Angle.degrees(Double(360*startTime/1440)),Angle.degrees(Double(360*endTime/1440))])
        }
        return taskAngles
    }

    
    
    func scale () {
        
    }

}
