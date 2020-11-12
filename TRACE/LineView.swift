//
//  LineView.swift
//  TRACE
//
//  Created by Matt Thomas on 10/27/20.
//

import Foundation

//Only instantiate ONCE
class LineView {
    var tasks = [Event]()
    var alerts = [Alert]()
    var cues = [Cue]()
    var colors = ["#ff0000", "#56cfda", "#31b941", "#dcb832", "#eb56c1"]
    
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
    
    func assignColors () {
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
    
    func allocateLengths () {
        
        //Now set to color segment graphic length?
    }
    
    
    
    func scale () {
        
    }

}
