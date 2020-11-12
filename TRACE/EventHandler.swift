//
//  EventHandler.swift
//  TRACE
//
//  Created by William Dominski on 10/30/20.
//

import SwiftUI

struct EventHandler: View {
    @EnvironmentObject var data : Model
    // @Binding var eventMode: Bool
    // @Binding var email: String
    @State var editEvent: String
    @State var index = 0
//Var that tells is alert was chosen for the event
    @State var alertToggled = false
//Var that tells if cue was chosen for the event
    @State var cueToggled = false
//Var that tells if task was chosen for the event
    @State var taskToggled = false
//Var that holds the color selected for the event
    @State private var colorSelected = "No color chosen"
//Var that holds the description of the event
    @State var description = ""
//Vars to hold the date and time selected for the event
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
            ref.child("\(self.data.email)").child("\(event)").observeSingleEvent(of: .value, with: { (snapshot) in
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
//ZStack contains all elements in the add view
        ZStack {
            Color.black
//VStack wrapped in ZStack to get correct formatting
            VStack {
//Alert, Cue, and Task toggable buttons
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
//Description of the event field
                VStack(){
                    Text("Description of your event")
                    .font(.callout)
                    .bold()
                    TextField("Enter the description..", text:$description).colorInvert()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }.frame(width: 300, height: 75, alignment: .top).padding() //VStack
//Field for which color has been selected for the event
                VStack(){
                    TextField("Color: ", text: $colorSelected)
                        .font(.callout)
                }.frame(width: 300, height: 25, alignment: .top).padding() //VStack
                
                Divider()
//HStack of buttons to assign the color to the event
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
//SwiftUI's datepicker function
                VStack {
                    DatePicker("", selection: $selectedDate).accentColor(.green)
                    if self.taskToggled {
                        DatePicker("End time (Task only)", selection: $selectedEndDate, in: selectedDate...Calendar.current.date(byAdding: .day, value: 1, to: self.selectedDate)!).accentColor(.green)
                    }
                }.padding() //VStack
//HStack that contains the add and close buttons
                HStack{
                    Spacer()
//Close icon to revert back to the homepage
                    Button(action: {
                            withAnimation{self.data.views["eventMode"]!.toggle() }}) {
                        ZStack {
                            Circle()
                                .strokeBorder(Color(rgb: WHITE), lineWidth: 3)
                                .background(Circle().foregroundColor(Color(rgb: RED)))
                                .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.width / 4)
                            Image("close_icon")
                                .foregroundColor(Color(rgb: DARK_GREY, alpha: 0.9))
                                .scaleEffect(1.8)
                        }//ZStack
                    }//Close button end
                    Spacer()
                    Button(action: {
                            withAnimation{self.data.views["eventMode"]!.toggle();
//References to the database being pushed after clicking the add button
                                if editEvent == "" { // if not opened from editView (adding)
                                    ref?.child(self.data.email).updateChildValues([description: objType()])
                                    ref?.child(self.data.email).child(description).updateChildValues(["Start Date": "\(selectedDate)"])
                                    ref?.child(self.data.email).child(description).updateChildValues(["End Date": "\(selectedEndDate)"])
                                    ref?.child(self.data.email).child(description).updateChildValues(["Type": "\(objType())"])
                                    ref?.child(self.data.email).child(description).updateChildValues(["Color": "\(colorSelected)"])
                                    
                                    // self.data.events.append(Event(subject: description, start_time: selectedDate, end_time: selectedEndDate, color: colorSelected, type: objType()))
                                } else { // editing
                                    if editEvent != self.description {
                                        let updates = ["Start Date": "\(selectedDate)", "End Date": "\(selectedEndDate)", "Type": "\(objType())", "Color": "\(colorSelected)"]

                                        ref?.child(self.data.email).child(description).updateChildValues(updates)
                                        ref?.child(self.data.email).child(editEvent).removeValue()
                                    } else {
                                        ref?.child(self.data.email).child(editEvent).updateChildValues(["Start Date": "\(selectedDate)"])
                                        ref?.child(self.data.email).child(editEvent).updateChildValues(["End Date": "\(selectedEndDate)"])
                                        ref?.child(self.data.email).child(editEvent).updateChildValues(["Type": "\(objType())"])
                                        ref?.child(self.data.email).child(editEvent).updateChildValues(["Color": "\(colorSelected)"])
                                    }
                                } //Editing else statement
                                
                            }
                        CircleView.getEvents(email: self.data.email)
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
                        }//ZStack
                    }//End of add button
                    Spacer()
                }//HStack
            }.background(Color.black) //Vstack
        }.background(Color.black)
        .onAppear(perform: {
            presetValuesOnEdit(event: editEvent)
        })//ZStack
    }//Varbody
}//EventHandler Struct

//Switches the view back to the main homepage
struct EventHandler_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

