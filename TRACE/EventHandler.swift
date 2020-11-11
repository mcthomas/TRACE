//
//  EventHandler.swift
//  TRACE
//
//  Created by William Dominski on 10/30/20.
//

import SwiftUI

struct EventHandler: View {
    @Binding var eventMode: Bool
    @Binding var email: String
    @State var editEvent: String
    @State var index = 0
    @State var alertToggled = false
    @State var cueToggled = false
    @State var taskToggled = false
    @State private var colorSelected = "No color chosen"
    @State var description = ""
    @State var selectedDate = Date()
    @State var selectedEndDate = Date(timeIntervalSinceReferenceDate: 0)
    
    
    private func objType() -> String {
        if (alertToggled) {
            return "alert"
        }
        else if (cueToggled) {
            return "cue"
        }
        else {
            return "task"
        }
    }

    private func presetValuesOnEdit(event: String) -> Void {
        if event == "" {
            return
        } else {
            ref.child("\(email)").child("\(event)").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let start = value?["Start Date"] as? String ?? ""
                let end = value?["End Date"] as? String ?? ""
                let type = value?["Type"] as? String ?? ""
                let color = value?["Color"] as? String ?? ""
                
                let dateFormatterOrig = DateFormatter()
                
                dateFormatterOrig.locale = Locale(identifier: "en_US_POSIX")
                dateFormatterOrig.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                self.selectedDate = dateFormatterOrig.date(from: start)!
                self.selectedEndDate = dateFormatterOrig.date(from: end)!
                
                if type == "alert" {
                    self.alertToggled = true
                }
                else if type == "cue" {
                    self.cueToggled = true
                }
                else {
                    self.taskToggled = true
                }
                
                self.colorSelected = color
            })
            self.description = event
        }
    }
    
    var body : some View {
        ZStack {
            Color.black
            VStack {
                VStack{
                    Divider()
                    let alertToggled = Binding<Bool>(get: { self.alertToggled }, set: { self.alertToggled = $0; self.cueToggled = false; self.taskToggled = false })
                    let cueToggled = Binding<Bool>(get: { self.cueToggled }, set: { self.alertToggled = false; self.cueToggled = $0; self.taskToggled = false })
                    let taskToggled = Binding<Bool>(get: { self.taskToggled }, set: { self.alertToggled = false; self.cueToggled = false; self.taskToggled = $0 })
                    Toggle("Alert event", isOn: alertToggled)
                    Divider()
                    Toggle("Cue event", isOn: cueToggled)
                    Divider()
                    Toggle("Task event", isOn: taskToggled)
                    Divider()
                }//VStack
                
                VStack(){
                    Text("Description of your event")
                    .font(.callout)
                    .bold()
                    TextField("Enter the description..", text:$description).colorInvert()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }.frame(width: 300, height: 75, alignment: .top).padding()
                
                VStack(){
                    TextField("Color: ", text: $colorSelected)
                        .font(.callout)
                }.frame(width: 300, height: 25, alignment: .top).padding()
                
                Divider()
                
                HStack{
                    Button(action: {self.colorSelected="RED"})
                        {
                        Text("Red")
                        }
                           .frame(width: 10, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                           .padding()
                           .foregroundColor(.red)
                           .background(Color.red)
                           .border(Color.black, width:2)
                    Button(action: {self.colorSelected="BLUE"})
                        {
                        Text("Blue")
                        }
                           .frame(width: 10, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                           .padding()
                           .foregroundColor(.blue)
                           .background(Color.blue)
                           .border(Color.black, width:2)
                    Button(action: {self.colorSelected="GREEN"})
                        {
                        Text("Green")
                        }
                           .frame(width: 10, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                           .padding()
                           .foregroundColor(.green)
                           .background(Color.green)
                           .border(Color.black, width:2)
                    Button(action: {self.colorSelected="YELLOW"})
                        {
                        Text("Yellow")
                        }
                           .frame(width: 10, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                           .padding()
                           .foregroundColor(.yellow)
                           .background(Color.yellow)
                           .border(Color.black, width:2)
                    Button(action: {self.colorSelected="ORANGE"})
                        {
                        Text("Orange")
                        }
                           .frame(width: 10, height: 10, alignment: .center)
                           .padding()
                           .foregroundColor(.orange)
                           .background(Color.orange)
                           .border(Color.black, width:2)
                }//HStack
                
                Divider()
                
                VStack {
//                    Text("Please pick a time..")
                    DatePicker("", selection: $selectedDate).accentColor(.green)
                    if self.taskToggled {
                        DatePicker("End time (Task only)", selection: $selectedEndDate, in: selectedDate...Calendar.current.date(byAdding: .day, value: 1, to: self.selectedDate)!).accentColor(.green)
                    }
                }.padding()
                HStack{
                    Spacer()
                    Button(action: {
                            withAnimation{self.eventMode.toggle() }}) {
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
                    Spacer()
                    Button(action: {
                            
                            withAnimation{self.eventMode.toggle();
                                if editEvent == "" { // if not opened from editView (adding)
                                    ref?.child(email).updateChildValues([description: objType()])
                                    ref?.child(email).child(description).updateChildValues(["Start Date": "\(selectedDate)"])
                                    ref?.child(email).child(description).updateChildValues(["End Date": "\(selectedEndDate)"])
                                    ref?.child(email).child(description).updateChildValues(["Type": "\(objType())"])
                                    ref?.child(email).child(description).updateChildValues(["Color": "\(colorSelected)"])
                                } else { // editing
                                    if editEvent != self.description {
                                        let updates = ["Start Date": "\(selectedDate)", "End Date": "\(selectedEndDate)", "Type": "\(objType())", "Color": "\(colorSelected)"]

                                        ref?.child(email).child(description).updateChildValues(updates)
                                        ref?.child(email).child(editEvent).removeValue()
                                    } else {
                                        ref?.child(email).child(editEvent).updateChildValues(["Start Date": "\(selectedDate)"])
                                        ref?.child(email).child(editEvent).updateChildValues(["End Date": "\(selectedEndDate)"])
                                        ref?.child(email).child(editEvent).updateChildValues(["Type": "\(objType())"])
                                        ref?.child(email).child(editEvent).updateChildValues(["Color": "\(colorSelected)"])
                                    }
                                }
                                
                            }
                        CircleView.getEvents(email: email)
                        CircleView.allocateAngles()
                    }) {
                        ZStack {
                            Circle()
                                .strokeBorder(Color(rgb: WHITE), lineWidth: 3)
                                .background(Circle().foregroundColor(Color(rgb: RED)))
                                .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.width / 4)
                            Image("add_icon")
                                .foregroundColor(Color(rgb: DARK_GREY, alpha: 0.9))
                                .scaleEffect(1.8)
                        }
                    }
                    Spacer()
                }//HStack
            }.background(Color.black) //Vstack
        }.background(Color.black)
        .onAppear(perform: {
            presetValuesOnEdit(event: editEvent)
        })//ZStack
    }
}

struct EventHandler_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

