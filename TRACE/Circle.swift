//
//  Circle.swift
//  TRACE
//
//  Created by Matt Thomas on 10/27/20.
//

import Foundation

//Only instantiate ONCE
class Circle {
    var tasks = [Task]()
    var alerts = [Alert]()
    var cues = [Cue]()
    
    draw {
        
    }
    
    func arrangeChrono () {
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
    
    func allocateLengths () {
        
        //Now set to color segment graphic length?
    }
    func assignColors () {
        for i in tasks {
            i.set_colorHex(by: "")
        }
    }
    scale {
        
    }
}
