//
//  EditView.swift
//  TRACE
//
//  Created by stonecodecs on 10/27/20.
//

import SwiftUI
import Firebase

/*struct Segment : Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()

        p.addArc(center: CGPoint(x: 100, y:100), radius: 50, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: true)

        return p.strokedPath(.init(lineWidth: 3, dash: [5, 3], dashPhase: 10))
    }
}*/

struct EditView : View {
    /*
    @Binding var editMode: Bool
    @Binding var email: String
    @State var eventMode = false
    
     */
    @EnvironmentObject var data : Model
    @ObservedObject var attr : EventAttributes
    @State var eventStrings = [String]()
    @State var index = 0
    @State var amountDragged = CGSize.zero
    
    
    public func getEventList() -> Void {
        var eventNames = ""
        ref.child("\(self.data.parsedEmail)").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                
                eventNames += "|\(key)"
                var events = eventNames.components(separatedBy: "|")
                events.removeFirst()
                self.eventStrings = events

            }
        })
    }
    
    var body : some View {
        let drag = DragGesture()
            .onChanged {
                self.amountDragged = $0.translation
            }
            .onEnded {
                if $0.translation.height < -100 {
                    withAnimation {
                        if self.data.events.count > 0 {
                            print("parsedemailhere: \(self.data.parsedEmail)")
                            ref.child("\(self.data.parsedEmail)").child("\(self.data.events[self.index].get_subject())").removeValue()
                            self.data.events.remove(at: self.index)
                            self.data.currentEvent = self.data.getCurrentEvent()
                            self.data.nextEvent = self.data.getNextEvent()
                            print("curr#: \(self.data.currentEvent)")
                            print("next#: \(self.data.nextEvent)")
                            if self.index >= self.data.events.count {
                                self.index = self.data.events.count - 1
                            }
                            // self.data.updateEventsFromDB()
                            print("After remove, size is \(self.data.events.count)")
                            
                            if(self.index < 0) {
                                ref.child("\(self.data.parsedEmail)").setValue(1)
                            }
                        }
                        self.amountDragged = .zero
                    }
                } else {
                    self.amountDragged = .zero
                    
                }
            }
        GeometryReader { geo in
            ZStack {
                Color(rgb: [0, 0, 0], alpha: 0.3)
                    .ignoresSafeArea(.all)
                
                // Vertical structure
                VStack {
                    Text("Tap the Circle to edit\nSwipe up to delete.")
                        .font(Font.custom("Lato-Light", size: 18))
                        .foregroundColor(Color(rgb: WHITE))
                        .multilineTextAlignment(.center)
                        .offset(y: 30)
                    
                    if self.data.events.count > 0 {
                        // Events List
                        TabView(selection: self.$index) {
                            ForEach(0..<self.data.events.count, id: \.self) {item in
                                InfoView(index: self.$index, eventString: self.data.events[item].subject)
                                    .padding(.horizontal, 5)
                                    .scaleEffect(self.index == item ? 1.0 : 0.3)
                                    .offset(y: amountDragged.height < 0 ? 10 + amountDragged.height : 10)
                                    .disabled(amountDragged.height < -30 ? true : false)
                                    .tag(self.index)
                                    .gesture(drag)
                                    .environmentObject(data)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle())
                        //.offset(y: -70)
                        .animation(.easeOut)
                        .frame(height: UIScreen.main.bounds.height - 240)
                        .onAppear(perform: {self.index = self.data.currentEvent >= 0 ? self.data.currentEvent : 0} )
                        
                    } else {
                        Spacer()
                        Text("No scheduled events yet.\nMake one by using the + button on the homepage!")
                            .font(Font.custom("Lato-Light", size: 22))
                            .foregroundColor(Color(rgb: WHITE))
                            .multilineTextAlignment(.center)
                            .frame(width: UIScreen.main.bounds.width / 1.3)

                        Spacer()
                    }
                    // Exit Edit Mode
                    Button(action: {
                            withAnimation{ self.data.views["editMode"]! = false }}) {
                        ZStack {
                            Circle()
                                .strokeBorder(Color(rgb: WHITE), lineWidth: 3)
                                .background(Circle().foregroundColor(Color(rgb: RED)))
                                .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.width / 4)
                            Image("close_icon")
                                .foregroundColor(Color(rgb: DARK_GREY, alpha: 0.9))
                                .scaleEffect(1.8)
                        }
                    }
                }
                // End of VStack
                
                if self.data.views["eventMode"]! && self.data.views["editMode"]! {
                    EventHandler(editEvent: self.data.events[self.index].subject)
                        .environmentObject(data)
                        .environmentObject(attr)
                }
            }// End of ZStack
        }
    }
}

struct InfoView : View {
    // @Binding var eventMode: Bool
    @EnvironmentObject var data : Model
    @Binding var index: Int
    @State var startDate = ""
    @State var endDate = ""
    @State var startComp = [" ", " ", " "]
    @State var endComp = [" ", " ", " "]
    let eventString: String  // replace with data element from database
    let editMode = true
    let baseDate = Date(timeIntervalSinceReferenceDate: 0) // probably terrible practice
    
    
    func setDates(index: Int) -> Void {
        let dateFormatterPost = DateFormatter()
        
        // if 24 hours format
        // dateFormatterPost.dateFormat = "MM/dd/yyyy HH:mm"
        
        // am/pm format
        dateFormatterPost.dateFormat = "MM/dd/yyyy hh:mm a"
        
        // startDate = dateFormatter.date(from:start)!
        // endDate = dateFormatter.date(from:end)!
        
        if index >= 0 && index < self.data.events.count {
            self.startDate = dateFormatterPost.string(from: self.data.events[index].get_start_time())
            self.endDate = dateFormatterPost.string(from: self.data.events[index].get_end_time())
        }
        
        startComp = startDate.components(separatedBy: " ")
        endComp = endDate.components(separatedBy: " ")
    }
    
    static func translateColor(color: String) -> [Int] {
        if color == "DARK_GREY" {
            return DARK_GREY
        }
        else if color == "ORANGE" {
            return ORANGE
        }
        else if color == "RED" {
            return RED
        }
        else if color == "GREEN" {
            return GREEN
        }
        else if color == "BLUE" {
            return BLUE
        }
        else if color == "YELLOW" {
            return YELLOW
        }
        else if color == "PURPLE" {
            return PURPLE
        }
        else if color == "HOT_PINK" {
            return HOT_PINK
        }
        else {
            return WHITE
        }
    }
    
    var body : some View {
        VStack {
            // Circle Subject Matter
            
            // Button to go to "AddView" (in edit mode)
            Button(action: { self.data.views["eventMode"]!.toggle() }) {
                ZStack {
                    Circle()
                        .foregroundColor(Color(rgb: InfoView.translateColor(color: (index >= 0 && index < self.data.events.count) ? self.data.events[index].get_color() : "WHITE")))
                        .frame(width: UIScreen.main.bounds.width / 1.4, height: UIScreen.main.bounds.width / 1.4)
                        .shadow(color: Color(rgb: InfoView.translateColor(color: (index >= 0 && index < self.data.events.count) ? self.data.events[index].get_color() : "WHITE")), radius: 6)
                    Text("\(eventString)")
                        .font(Font.custom("Lato-Light", size: 40))
                        .padding()
                        .foregroundColor(Color(rgb: DARK_GREY))
                        .frame(width: UIScreen.main.bounds.size.width - 145, height: UIScreen.main.bounds.size.width - 160, alignment: .center)
                        .multilineTextAlignment(.center)
                        .fixedSize()
                        .offset(y: 5)
                }
                
            }
            .padding(.bottom, 70)
            
            
            // Event Date & Time
            ZStack {
                RoundedRectangle(cornerRadius: 15.0)
                    .foregroundColor(Color(rgb: InfoView.translateColor(color: (index >= 0 && index < self.data.events.count) ? self.data.events[index].get_color() : "WHITE")))
                    .frame(width: UIScreen.main.bounds.size.width * 0.70, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .shadow(color: Color(rgb: InfoView.translateColor(color: (index >= 0 && index < self.data.events.count) ? self.data.events[index].get_color() : "WHITE")), radius: 3)
               
                // start and end date strings in format MM/dd/yyyy hh:mm a (split into 3 components)
                VStack {
                    HStack {
                        Text("\(startComp[0])")
                            .font(Font.custom("Lato-Light", size: 18))
                            .foregroundColor(Color(rgb: DARK_GREY, alpha: 0.9))
                            .multilineTextAlignment(.center)
                        if index >= 0 && index < self.data.events.count {
                            if self.data.events[index].get_type() == "task" && endComp[0] != startComp[0] {
                                Text("- \(endComp[0])")
                                    .font(Font.custom("Lato-Light", size: 18))
                                    .foregroundColor(Color(rgb: DARK_GREY, alpha: 0.9))
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                    HStack {
                        Text("\(startComp[1])\(startComp[2])")
                            .font(Font.custom("Lato-Light", size: 22))
                            .foregroundColor(Color(rgb: DARK_GREY, alpha: 0.9))
                            .multilineTextAlignment(.center)
                            //.offset(y: 5)
                        if index >= 0 && index < self.data.events.count {
                            if self.data.events[index].get_type() == "task" {
                                Text("- \(endComp[1])\(endComp[2])")
                                    .font(Font.custom("Lato-Light", size: 22))
                                    .foregroundColor(Color(rgb: DARK_GREY, alpha: 0.9))
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                }
            }
            
        }.onAppear(perform: {
            self.setDates(index: self.index)
        })
        .onChange(of: self.index, perform: { value in
            self.setDates(index: self.index)
        })
        .onChange(of: (self.index >= 0 && self.index < self.data.events.count) ? self.data.events[self.index].get_start_time() : baseDate) { value in
            self.setDates(index: self.index)
        }
        .onChange(of: (self.index >= 0 && self.index < self.data.events.count) ? self.data.events[self.index].get_end_time() : baseDate) { value in
            self.setDates(index: self.index)
        }
        // end of VStack
        
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
