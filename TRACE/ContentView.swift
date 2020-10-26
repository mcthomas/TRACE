//
//  ContentView.swift
//  TRACE
//
//  Created by Matt Thomas on 10/21/20.
//

// Defined pre-set colors
let DARK_GREY = [54, 52, 52]
let WHITE = [255, 255, 255]
let ORANGE = [247, 202, 89]
let RED = [252, 76, 93]
let LIME = [114,224,110]
let LIGHT_BLUE = [76,223,252]
let PURPLE = [129,79,255]
let HOT_PINK = [250,75,212]
let SETTINGS = ["Dark Mode", "24 Hour Format", "Colorblind Mode"]
let SETTINGS_ICONS = ["darkmode_icon", "24hr_icon", "colorblind_icon"]


import SwiftUI
// import Firebase

// var ref: DatabaseReference!

var writeChild: Void {
    
    return
}

struct ContentView: View {
    // Should probably put these in the environment using EnvironmentObject
    @State var currentDate = Date()         // gives current date/time
    @State var areNotifications = true      // if there are notifications
    @State var time24hr = false             // 24 format toggle (default: 12)
    @State var darkMode = true              // Dark mode toggle (default: dark)
    @State var showMenu = false
    
    var body: some View {
        let drag = DragGesture()
                    .onEnded {
                        if $0.translation.width > 50 {
                            withAnimation {
                                self.showMenu = true
                            }
                        }
                        if $0.translation.width < -50 {
                            withAnimation {
                                self.showMenu = false
                            }
                        }
                    }
        
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                HomePage(time24hr: self.$time24hr, darkMode: self.$darkMode, showMenu: self.$showMenu, currentDate: self.$currentDate, areNotifications: self.$areNotifications)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    //.disabled(self.showMenu ? true : false)
                    .gesture(drag)
                if self.showMenu {
                    Menu(showMenu: self.$showMenu, darkMode: self.$darkMode, time24hr: self.$time24hr)
                        .transition(.move(edge: .leading))
                        .animation(.spring())
                }
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct HomePage: View {
    
    @Binding var time24hr: Bool             // 24 format toggle (default: 12)
    @Binding var darkMode: Bool             // Dark mode toggle (default: dark)
    @Binding var showMenu: Bool             // Menu toggleable  (default: don't show)
    @Binding var currentDate: Date
    @Binding var areNotifications: Bool

    // Functions and variables used to create a functioning digital clock
    // Resource: https://medium.com/iu-women-in-computing/intro-to-swiftui-digital-clock-d0a60e05d394
    var timeFormat: DateFormatter {
        // ref = Database.database().reference()
        // ref.child("odd nums").setValue(13579)
        let formatter = DateFormatter()
        if !time24hr {
            formatter.dateFormat = "h:mm a"
        } else {
            formatter.dateFormat = "HH:mm"
        }
        return formatter
    }
    func timeToString(date: Date) -> String {
         let time = timeFormat.string(from: date)
         return time
    }
    var updateTimer: Timer {
                 Timer.scheduledTimer(withTimeInterval: 1, repeats: true,
                                      block: {_ in
                                         self.currentDate = Date()
                                       })
    }
    
    var body: some View {
        NavigationView {
            Color(rgb: self.darkMode ? DARK_GREY : WHITE)
                .ignoresSafeArea()
                .overlay(
                    ZStack (alignment: .leading) {
                        VStack {
                            // Digital Clock, Menu, and Notifications
                            HStack {
                                // Sketchy menu icon made from 2 Images
                                Button(action: {
                                    withAnimation {
                                        self.showMenu.toggle()
                                    }}) {
                                    HStack {
                                        Image("menu_icon")
                                            .resizable()
                                            .frame(width: 30, height: 40)
                                            .foregroundColor(self.darkMode ? Color.white : Color(rgb: DARK_GREY))
                                            .offset(x: 0, y: 13)

                                            Image("menu_arrow")
                                                .resizable()
                                                .frame(width: 10, height: 10)
                                                .foregroundColor(self.darkMode ? Color.white : Color(rgb: DARK_GREY))
                                                .offset(x: -12, y: 6)
                                                .rotationEffect(Angle(degrees: 270), anchor: .bottomLeading)
                                    }
                                }
                                
                                // Digital Clock
                                HStack {
                                    // Time will always result in "h:mm a" format in 12hr format, therefore
                                    // time[0] - h:mm
                                    // time[1] - AM/PM
                                    // Otherwise, if 24hr format, only time[0]
                                    let time = timeToString(date: currentDate).components(separatedBy: " ")
                                    Text("\(time[0])")
                                        .onAppear(perform: {
                                            let _ = self.updateTimer
                                        })
                                    .font(Font.custom("Comfortaa-Light", size: 60))
                                    .foregroundColor(self.darkMode ? Color.white : Color(rgb: DARK_GREY))
                                    
                                    if !time24hr {
                                        Text("\(time[1].lowercased())")
                                            .font(Font.custom("Comfortaa-Light", size: 20))
                                            .foregroundColor(self.darkMode ? Color.white : Color(rgb: DARK_GREY))
                                            .offset(x: -5, y: 10)
                                    }
                                }.offset(x: (time24hr) ? -6 : 7, y: 16)
                                .padding(.horizontal, 10)
                                .frame(width: 230, height: 55)
                                .fixedSize()
                                
                                // Notifications
                                ZStack {
                                    Image("notifications_bell")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(self.darkMode ? Color.white : Color(rgb: DARK_GREY))
                                        .offset(x: 0, y: 14)
                                    
                                    // if there are notifications
                                    if areNotifications {
                                        Circle()
                                            .frame(width: 10, height: 10, alignment: .trailing)
                                            .foregroundColor(Color(rgb: RED))
                                            .offset(x: 10, y: 5)
                                    }
                                }
                                
                            }
                            
                            // Circular Timeline ZStack
                            ZStack {
                                // Orbital Circle
                                // Should rotate with the time
                                // Should have colored arcs for separate events
                                Circle()
                                    .strokeBorder(self.darkMode ? Color.white : Color(rgb: DARK_GREY, alpha: 0.9), lineWidth: 8)
                                    .frame(width: UIScreen.main.bounds.size.width / 1.1)
                                
                                // Inner circle
                                // Color of the current task
                                Circle()
                                    .foregroundColor(Color(rgb: ORANGE))
                                    .frame(width: UIScreen.main.bounds.size.width / 1.4)
                                
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
                                        .font(Font.custom("Comfortaa-Regular", size: 18))
                                        .foregroundColor(Color(rgb: DARK_GREY, alpha: 0.9))
                                        .multilineTextAlignment(.center)
                                    
                                    Text("8:30pm - 10:30pm")
                                        .font(Font.custom("Comfortaa-Regular", size: 16))
                                        .foregroundColor(Color(rgb: DARK_GREY))
                                        .multilineTextAlignment(.center)
                                        .padding(.top, 1)
                                        
                                }.frame(width: UIScreen.main.bounds.size.width * 0.75, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            }.padding()
                            .offset(y: -20)

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
                            }.offset(y: -20)
                            Spacer()
                        }
                        .navigationBarHidden(true)
                        .preferredColorScheme(self.darkMode ? /*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/ : .light)
                        // end of VStack
                        
                    } // end of ZStack
                ) // end of overlay
        }
        
    }
    
}

// Menu View
struct Menu : View {
    @Binding var showMenu: Bool
    @Binding var darkMode: Bool
    @Binding var time24hr: Bool
    
    // might be bad practice
    // any button that gets pressed from settings
    // triggers an action based on the setting pressed
    func performSettingAction(setting: String) -> Void {
        switch(setting) {
        case SETTINGS[0]:
            self.darkMode.toggle()
        case SETTINGS[1]:
            self.time24hr.toggle()
        case SETTINGS[2]:
            print("placeholder for colorblind mode")
        default:
            print("Error: No action in settings for \(setting)")
        }
    }

    
    var body: some View {
        ZStack {
            Button(action: {withAnimation {self.showMenu.toggle()}}) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15.0)
                        .foregroundColor(Color(rgb: RED))
                        .frame(width: UIScreen.main.bounds.size.width / 4, height: 165, alignment: .leading)
                        .overlay(RoundedRectangle(cornerRadius: 15.0).stroke(Color.black.opacity(0.2), lineWidth: 2).shadow(radius: 3))

                    HStack {
                        Image("menu_icon")
                            .resizable()
                            .frame(width: 30, height: 40)
                            .foregroundColor(.white)
                            .offset(x: 0, y: 13)

                        Image("menu_arrow")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.white)
                            .offset(x: 2, y: 52)
                            .rotationEffect(Angle(degrees: 90), anchor: .bottomLeading)
                    }
                    .offset(x: 15, y: -10)
                }
            }.offset(x: 120, y: -330)
            
            VStack (alignment: .center, spacing: 12){
                ForEach(0..<SETTINGS.count) { set in
                    Button(action: {
                        performSettingAction(setting: SETTINGS[set])
                    }) {
                        VStack {
                            Image("\(SETTINGS_ICONS[set])")
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.width / 6)
                                .foregroundColor(Color(rgb: RED, alpha: 0.9))
                            Text("\(SETTINGS[set])")
                                .font(Font.custom("Comfortaa-Regular", size: 15))
                                .foregroundColor(self.darkMode ? Color.white : Color(rgb: DARK_GREY))
                                .frame(width: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 15)
                    }
                }
                Spacer()
            }
            .foregroundColor(.black)
            .frame(width: UIScreen.main.bounds.width / 3.5)
            .padding(.horizontal, 30)
            .padding(.top, 50)
            .background(self.darkMode ? Color(rgb: DARK_GREY) : Color.white)
            .overlay(Rectangle().stroke(Color.black.opacity(0.1), lineWidth: 3).shadow(radius: 3))
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
        } // end of ZStack
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
