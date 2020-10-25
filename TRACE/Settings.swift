//
//  Settings.swift
//  TRACE
//
//  Created by Ethan Schnaser on 10/25/20.
//

import Foundation

class Settings {
    //Local variables
    var timeline_type: Bool //Determines timeline type displayed to user
    var colorblind_mode: Bool = false //Indicates whether user has colorblind mode on or not
    var alert_name: String // Name of the selected alert
    var task_name: String // Name of selected task
    var cue_name: String //Name of selected cue
    
    //Initialize the Settings page (Setting the local variables)
    init(selected_timeline: Bool = false, selected_colorblind: Bool = false, alert: String, task: String, cue: String){
        timeline_type = selected_timeline
        colorblind_mode = selected_colorblind
        alert_name = alert
        task_name = task
        cue_name = cue
    }
    
    //changes the name of the current alert selected
    func set_alert_name(alert_change: String){
        alert_name = alert_change
    }
    
    //changes the name of the current task selected
    func set_task_name(task_change: String){
        task_name = task_change
    }
    
    
    //changes the name of the current cue selected
    func set_alert_name(cue_change: String){
        task_name = cue_change
    }
    
    
    //gets the name of the current alert
    func get_alert_name() -> String{
        return alert_name
    }
    
    //gets the name of the current task
    func get_task_name() -> String{
        return task_name
    }
    
    //gets the name of the current cue
    func get_cue_name() -> String{
        return cue_name
    }
    
}
