//
//  EventHandler.swift
//  TRACE
//
//  Created by William Dominski on 10/30/20.
//

import SwiftUI

struct EventHandler: View {
@Binding var eventMode: Bool
@State var index = 0
@State var amountDragged = CGSize.zero
@State var alertToggled = false
@State var cueToggled = false
@State var taskToggled = false
@State private var colorSelected = "No color chosen"
@State var description = " "
@State var selectedDate = Date()
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
                    Button(action: {self.colorSelected="Selected color: Red"})
                        {
                        Text("Red")
                        }
                           .frame(width: 10, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                           .padding()
                           .foregroundColor(.red)
                           .background(Color.red)
                           .border(Color.black, width:2)
                    Button(action: {self.colorSelected="Selected color: Blue"})
                        {
                        Text("Blue")
                        }
                           .frame(width: 10, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                           .padding()
                           .foregroundColor(.blue)
                           .background(Color.blue)
                           .border(Color.black, width:2)
                    Button(action: {self.colorSelected="Selected color: Green"})
                        {
                        Text("Green")
                        }
                           .frame(width: 10, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                           .padding()
                           .foregroundColor(.green)
                           .background(Color.green)
                           .border(Color.black, width:2)
                    Button(action: {self.colorSelected="Selected color: Yellow"})
                        {
                        Text("Yellow")
                        }
                           .frame(width: 10, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                           .padding()
                           .foregroundColor(.yellow)
                           .background(Color.yellow)
                           .border(Color.black, width:2)
                    Button(action: {self.colorSelected="Selected color: Orange"})
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
//                            Text("Your selected date: \(selectedDate)")
                }.padding()
                HStack{
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
                    Button(action: {
                            withAnimation{self.eventMode.toggle() }}) {
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
                    
                }//VStack
        }.background(Color.black)//Zstack
        }.background(Color.black)//Body
}//Struct

struct EventView : View {
let index: Int
let mockData: String  // replace with data element from database

init(index: Int, mockData: String) {
    self.index = index
    self.mockData = mockData
    UIScrollView.appearance().bounces = false
}


var body : some View {
    HStack {
        // Circle Subject Matter
        
        // Button to go to "AddView" (in edit mode)
        Button(action: {print("works")}) {
            
        }
    
    }
}
struct EventHandler_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
}
}
