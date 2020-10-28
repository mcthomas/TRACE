//
//  LineView.swift
//  TRACE
//
//  Created by Matt Thomas on 10/27/20.
//

import Foundation

//Only instantiate ONCE
class LineView {
    var tasks = [Task]()
    var alerts = [Alert]()
    var cues = [Cue]()

    
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

}
