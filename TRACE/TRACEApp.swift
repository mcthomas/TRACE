//
//  TRACEApp.swift
//  TRACE
//
//  Created by Matt Thomas on 10/21/20.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct TRACEApp: App {
    var data = Model()
    var attr = EventAttributes()
    init() {
        FirebaseApp.configure()
      }
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(data).environmentObject(attr)
        }
    }

    
    
    
}


    

