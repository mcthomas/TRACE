//
//  ContentView.swift
//  TRACE
//
//  Created by Matt Thomas on 10/21/20.
//

// Defined pre-set colors
let DARK_GREY = [54, 52, 52]
let ORANGE = [247, 202, 89]
let RED = [252, 76, 93]
let LIME = [114,224,110]
let LIGHT_BLUE = [76,223,252]
let PURPLE = [129,79,255]
let HOT_PINK = [250,75,212]


import SwiftUI

struct ContentView: View {
    var body: some View {
        HomePage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct HomePage: View {
    var body: some View {
        NavigationView {
            Color(rgb: DARK_GREY)
                .ignoresSafeArea()
                .overlay(
                    VStack {
                        // TO-DO: Navigation Bar for Menu & Notifications?
                        
                        // TO-DO: Digital Clock Here
                        HStack {
                            Text("6:30")
                            .font(Font.custom("Comfortaa-Light", size: 60))
                            .foregroundColor(.white)
                            
                            
                            Text("pm")
                                .font(Font.custom("Comfortaa-Light", size: 20))
                                .foregroundColor(.white)
                                .offset(x: -5, y: 10)
                        }.offset(x: 16, y: 16)
                        
                        // Circular Timeline ZStack
                        ZStack {
                            // Orbital Circle
                            // Should rotate with the time
                            // Should have colored arcs for separate events
                            Circle()
                                .strokeBorder(Color.white, lineWidth: 8)
                                .frame(width: UIScreen.main.bounds.size.width - 40)
                            
                            // Inner circle
                            // Color of the current task
                            Circle()
                                .foregroundColor(Color(rgb: ORANGE))
                                .frame(width: UIScreen.main.bounds.size.width - 105)
                            
                            // Subject Text
                            // Bounded to not overflow inner circle dimensions
                            Text("CS 506")
                                .font(Font.custom("Comfortaa-Light", size: 40))
                                .padding()
                                .foregroundColor(Color(rgb: DARK_GREY))
                                .frame(width: UIScreen.main.bounds.size.width - 145, height: UIScreen.main.bounds.size.width - 160, alignment: .center)
                                .multilineTextAlignment(.center)
                                .fixedSize()
                                .offset(y: 5)
                        }
                        
                        // TO-DO: Peek Next Event
                        ZStack {
                            RoundedRectangle(cornerRadius: 15.0)
                                .foregroundColor(Color(rgb: RED))
                                .padding()
                                .frame(width: UIScreen.main.bounds.size.width * 0.88, height: 125, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            VStack{
                                Text("Next:\nWork Shift")
                                    .font(Font.custom("Comfortaa-Regular", size: 22))
                                    .foregroundColor(Color(rgb: DARK_GREY, alpha: 0.9))
                                    .multilineTextAlignment(.center)
                                
                                Text("8:30pm - 10:30pm")
                                    .font(Font.custom("Comfortaa-Regular", size: 18))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    
                            }.frame(width: UIScreen.main.bounds.size.width * 0.75, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }.padding()
                        .offset(y: -10)

                        // +/- Button HStack
                        HStack {
                            
                            // Add button
                            // Should take user to the AddPage (use NavigationLink)
                            Button(action: {print("Add")}) {
                                ZStack {
                                    Circle()
                                        .foregroundColor(Color(rgb: ORANGE))
                                        .frame(width: UIScreen.main.bounds.size.width / 4, height: UIScreen.main.bounds.size.width / 4, alignment: .center)
                                    Text("+")
                                        .font(Font.custom("Comfortaa-Regular", size: 70))
                                        .foregroundColor(Color(rgb: DARK_GREY, alpha: 0.9))
                                        .offset(y: 6)
                                }
                            }.padding(.horizontal, 50)
                            
                            // Delete button
                            // Changes the view to the deleteView (use NavigationLink)
                            Button(action: {print("Delete")}) {
                                ZStack {
                                    Circle()
                                        .foregroundColor(Color(rgb: ORANGE))
                                        .frame(width: UIScreen.main.bounds.size.width / 4, height: UIScreen.main.bounds.size.width / 4, alignment: .center)
                                    Text("-")
                                        .font(Font.custom("Comfortaa-Regular", size: 70))
                                        .foregroundColor(Color(rgb: DARK_GREY, alpha: 0.9))
                                        .offset(x: 1)
                                }
                                
                            }.padding(.horizontal, 50)
                        }
                        Spacer()
                    }
                    .navigationBarHidden(true)// end of VStack
                    
                ) // end of overlay
        }
        
    }
}

// rgba color picker
extension Color {
    init(rgb: [Int], alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double(rgb[0]) / 255,
            green: Double(rgb[1]) / 255,
            blue: Double(rgb[2]) / 255,
            opacity: alpha
        )
    }
}
