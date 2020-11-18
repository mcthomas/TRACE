//
//  EventHandler.swift
//  TRACE
//
//  Created by William Dominski on 10/30/20.
//

import SwiftUI

struct EventHandler: View {
    @EnvironmentObject var data : Model
    @EnvironmentObject var attr : EventAttributes
    // @Binding var eventMode: Bool
    // @Binding var email: String
    
    let editEvent: String
    /*
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
 */
    
    var body : some View {
//ZStack contains all elements in the add view
        GeometryReader { geo in
        ZStack {
            Color.black
//VStack wrapped in ZStack to get correct formatting
            VStack {
//Alert, Cue, and Task toggable buttons
                VStack{
                    Divider()
                    let alertToggled = Binding<Bool>(get: { self.attr.alertToggled }, set: { self.attr.alertToggled = $0; self.attr.cueToggled = false; self.attr.taskToggled = false })
                    let cueToggled = Binding<Bool>(get: { self.attr.cueToggled }, set: { self.attr.alertToggled = false; self.attr.cueToggled = $0; self.attr.taskToggled = false })
                    let taskToggled = Binding<Bool>(get: { self.attr.taskToggled }, set: { self.attr.alertToggled = false; self.attr.cueToggled = false; self.attr.taskToggled = $0 })
                    Toggle("Alert event", isOn: alertToggled)
                    Divider()
                    Toggle("Cue event", isOn: cueToggled)
                    Divider()
                    Toggle("Task event", isOn: taskToggled)
                    Divider()
                } //VStack
//Description of the event field
                VStack(){
                    Text("Description of your event")
                    .font(.callout)
                    .bold()
                    TextField("Enter the description..", text: $attr.description).colorInvert()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }.frame(width: 300, height: 75, alignment: .top).padding() //VStack
//Field for which color has been selected for the event
                VStack(){
                    TextField("Color: ", text: $attr.colorSelected)
                        .font(.callout)
                }.frame(width: 300, height: 25, alignment: .top).padding() //VStack
                
                Divider()
//HStack of buttons to assign the color to the event
                HStack{
                    Button(action: {self.attr.colorSelected="RED"})
                        {
                        Text("Red")
                        }
                           .frame(width: 10, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                           .padding()
                           .foregroundColor(.red)
                           .background(Color.red)
                           .border(Color.black, width:2)
                    Button(action: {self.attr.colorSelected="BLUE"})
                        {
                        Text("Blue")
                        }
                           .frame(width: 10, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                           .padding()
                           .foregroundColor(.blue)
                           .background(Color.blue)
                           .border(Color.black, width:2)
                    Button(action: {self.attr.colorSelected="GREEN"})
                        {
                        Text("Green")
                        }
                           .frame(width: 10, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                           .padding()
                           .foregroundColor(.green)
                           .background(Color.green)
                           .border(Color.black, width:2)
                    Button(action: {self.attr.colorSelected="YELLOW"})
                        {
                        Text("Yellow")
                        }
                           .frame(width: 10, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                           .padding()
                           .foregroundColor(.yellow)
                           .background(Color.yellow)
                           .border(Color.black, width:2)
                    Button(action: {self.attr.colorSelected="ORANGE"})
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
                    DatePicker("", selection: $attr.selectedDate).accentColor(.green)
                    if self.attr.taskToggled {
                        DatePicker("End time (Task only)", selection: $attr.selectedEndDate, in: attr.selectedDate...Calendar.current.date(byAdding: .day, value: 1, to: self.attr.selectedDate)!).accentColor(.green)
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
                                if self.editEvent == "" { // if not opened from editView (adding)
                                    print("add, editevent empty")
                                    ref?.child(self.data.parsedEmail).updateChildValues([attr.description: attr.objType()])
                                    ref?.child(self.data.parsedEmail).child(attr.description).updateChildValues(["Start Date": "\(attr.selectedDate)"])
                                    ref?.child(self.data.parsedEmail).child(attr.description).updateChildValues(["End Date": "\(attr.selectedEndDate)"])
                                    ref?.child(self.data.parsedEmail).child(attr.description).updateChildValues(["Type": "\(attr.objType())"])
                                    ref?.child(self.data.parsedEmail).child(attr.description).updateChildValues(["Color": "\(attr.colorSelected)"])
                                    
                                    // self.data.events.append(Event(subject: description, start_time: selectedDate, end_time: selectedEndDate, color: colorSelected, type: objType()))
                                } else { // editing
                                    if self.editEvent != self.attr.description {
                                        let updates = ["Start Date": "\(attr.selectedDate)", "End Date": "\(attr.selectedEndDate)", "Type": "\(attr.objType())", "Color": "\(attr.colorSelected)"]

                                        ref?.child(self.data.parsedEmail).child(attr.description).updateChildValues(updates)
                                        print("here, \(editEvent)")
                                        ref?.child(self.data.parsedEmail).child(editEvent).removeValue()
                                    } else {
                                        print("description not changed")
                                        ref?.child(self.data.parsedEmail).child(editEvent).updateChildValues(["Start Date": "\(attr.selectedDate)"])
                                        ref?.child(self.data.parsedEmail).child(editEvent).updateChildValues(["End Date": "\(attr.selectedEndDate)"])
                                        ref?.child(self.data.parsedEmail).child(editEvent).updateChildValues(["Type": "\(attr.objType())"])
                                        ref?.child(self.data.parsedEmail).child(editEvent).updateChildValues(["Color": "\(attr.colorSelected)"])
                                    }
                                } //Editing else statement
                                
                            }
                        CircleView.getEvents(email: self.data.parsedEmail)
                        CircleView.allocateAngles()
//same stuff as whats in contentview for notifications this is just for when the user adds a new notification so the system doesnt have to grab from the db
                        var now = Date()
                        let interval = attr.selectedDate.timeIntervalSince(now)
                        now.addTimeInterval(interval)
                        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
                        let targetYear = components.year ?? 0
                        let targetMonth = components.month ?? 0
                        let targetDay = components.day ?? 0
                        let targetHour = components.hour ?? 0
                        let targetMinute = components.minute ?? 0
                        let targetSecond = components.second ?? 0
                        data.notificationManager.notifications = [Notification(ident: "event-\(attr.idcounter)",desc: self.attr.description, datetimes: DateComponents(calendar: Calendar.current, year: targetYear, month: targetMonth, day: targetDay, hour: targetHour, minute: targetMinute, second: targetSecond))]
                        attr.idcounter += 1
                        print("Eventhandler notifs \(data.notificationManager.notifications)")
                        data.notificationManager.schedule()
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
            }.background(Color.black)
            .onAppear(perform: {
                self.attr.presetValuesOnEdit(email: self.data.parsedEmail, event: self.editEvent)
                print("Event: \(self.editEvent)")
            }) //Vstack
        }.background(Color.black)
        //ZStack
        }
    }//Varbody
}//EventHandler Struct

//Switches the view back to the main homepage
struct EventHandler_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

