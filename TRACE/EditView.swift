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
    @Binding var editMode: Bool
    @Binding var email: String
    @State var eventMode = false
    @State var data = [String]()
    @State var index = 0
    @State var amountDragged = CGSize.zero
    
    public func getEventList() -> Void {
        var eventNames = ""
        ref.child("\(self.email)").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                
                eventNames += "|\(key)"
                var events = eventNames.components(separatedBy: "|")
                events.removeFirst()
                self.data = events
                print(self.data)
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
                        if self.data.count > 0 {
                            ref.child("\(self.email)").child("\(self.data[self.index])").removeValue()
                            self.data.remove(at: self.index)
                            if self.index >= self.data.count {
                                self.index = self.data.count - 1
                            }
                            print("After remove, size is \(self.data.count)")
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
                        .font(Font.custom("Comfortaa-Regular", size: 18))
                        .foregroundColor(Color(rgb: WHITE))
                        .multilineTextAlignment(.center)
                        .offset(y: 30)
                    
                    if self.data.count > 0 {
                        // Events List
                        TabView(selection: self.$index) {
                            ForEach(0..<self.data.count, id: \.self) {item in
                                InfoView(eventMode: self.$eventMode, index: self.$index, eventString: self.data[item], email: self.email)
                                    .padding(.horizontal, 5)
                                    .scaleEffect(self.index == item ? 1.0 : 0.3)
                                    .offset(y: amountDragged.height < 0 ? 10 + amountDragged.height : 10)
                                    .disabled(amountDragged.height < -30 ? true : false)
                                    .tag(self.index)
                                    .gesture(drag)
                                }
                        }
                        .tabViewStyle(PageTabViewStyle())
                        //.offset(y: -70)
                        .animation(.easeOut)
                        .frame(height: UIScreen.main.bounds.height - 240)
                        .onChange(of: self.eventMode, perform: { value in
                            self.getEventList()
                        })
                        
                    } else {
                        Spacer()
                        Text("No scheduled events yet.\nMake one by using the + button on the homepage!")
                            .font(Font.custom("Comfortaa-Regular", size: 22))
                            .foregroundColor(Color(rgb: WHITE))
                            .multilineTextAlignment(.center)
                            .frame(width: UIScreen.main.bounds.width / 1.3)

                        Spacer()
                    }
                    // Exit Edit Mode
                    Button(action: {
                            withAnimation{ self.editMode = false }}) {
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
                } // End of VStack
                
                if self.eventMode && self.editMode {
                    EventHandler(eventMode: self.$eventMode, email: self.$email, editEvent: self.data[self.index])
                }
            }.onAppear(perform: {
                self.getEventList()
            })// End of ZStack
        }
    }
}

struct InfoView : View {
    @Binding var eventMode: Bool
    @Binding var index: Int
    @State var startDate = ""
    @State var endDate = ""
    @State var eventType = ""
    @State var startComp = [" ", " ", " "]
    @State var endComp = [" ", " ", " "]
    @State var eventColor = "DARK_GREY"
    let eventString: String  // replace with data element from database
    let email: String
    let editMode = true
    
    
    func setDates() -> Void {
        ref.child("\(email)").child("\(eventString)").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let start = value?["Start Date"] as? String ?? ""
            let end = value?["End Date"] as? String ?? ""
            let type = value?["Type"] as? String ?? ""
            let color = value?["Color"] as? String ?? ""
            let dateFormatterOrig = DateFormatter()
            let dateFormatterPost = DateFormatter()
            
            dateFormatterOrig.locale = Locale(identifier: "en_US_POSIX")
            dateFormatterOrig.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            
            // if 24 hours format
            // dateFormatterPost.dateFormat = "MM/dd/yyyy HH:mm"
            
            // am/pm format
            dateFormatterPost.dateFormat = "MM/dd/yyyy hh:mm a"
            
            // startDate = dateFormatter.date(from:start)!
            // endDate = dateFormatter.date(from:end)!
            eventType = type
            eventColor = color
            
            if let date = dateFormatterOrig.date(from: start) {
                self.startDate = dateFormatterPost.string(from: date)
                
            } else {
               print("There was an error decoding the string")
            }
            
            if let date = dateFormatterOrig.date(from: end) {
                self.endDate = dateFormatterPost.string(from: date)
                
            } else {
               print("There was an error decoding the string")
            }
            
            print(startDate)
            print(endDate)
            
            startComp = startDate.components(separatedBy: " ")
            endComp = endDate.components(separatedBy: " ")
            
            print(eventType)
        })
        
    }
    
    func translateColor(color: String) -> [Int] {
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
            Button(action: { self.eventMode.toggle() }) {
                ZStack {
                    Circle()
                        .foregroundColor(Color(rgb: translateColor(color: eventColor)))
                        .frame(width: UIScreen.main.bounds.width / 1.4, height: UIScreen.main.bounds.width / 1.4)
                        .shadow(color: Color(rgb: translateColor(color: eventColor)), radius: 6)
                    Text("\(eventString)")
                        .font(Font.custom("Comfortaa-Light", size: 40))
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
                    .foregroundColor(Color(rgb: translateColor(color: eventColor)))
                    .frame(width: UIScreen.main.bounds.size.width * 0.70, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .shadow(color: Color(rgb: translateColor(color: eventColor)), radius: 3)
               
                // start and end date strings in format MM/dd/yyyy hh:mm a (split into 3 components)
                VStack {
                    HStack {
                        Text("\(startComp[0])")
                            .font(Font.custom("Comfortaa-Light", size: 18))
                            .foregroundColor(Color(rgb: DARK_GREY, alpha: 0.9))
                            .multilineTextAlignment(.center)
                        if eventType == "task" && endComp[0] != startComp[0] {
                            Text("- \(endComp[0])")
                                .font(Font.custom("Comfortaa-Light", size: 18))
                                .foregroundColor(Color(rgb: DARK_GREY, alpha: 0.9))
                                .multilineTextAlignment(.center)
                        }
                    }
                    HStack {
                        Text("\(startComp[1])\(startComp[2])")
                            .font(Font.custom("Comfortaa-Light", size: 22))
                            .foregroundColor(Color(rgb: DARK_GREY, alpha: 0.9))
                            .multilineTextAlignment(.center)
                            //.offset(y: 5)
                        if eventType == "task" {
                            Text("- \(endComp[1])\(endComp[2])")
                                .font(Font.custom("Comfortaa-Light", size: 22))
                                .foregroundColor(Color(rgb: DARK_GREY, alpha: 0.9))
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
            
        }.onAppear(perform: {
            self.setDates()
        })
        .onChange(of: self.eventMode, perform: { value in
            self.setDates()
        })
        // end of VStack
        
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
