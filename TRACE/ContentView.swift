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
let GREEN = [114,224,110]
let BLUE = [76,223,252]
let YELLOW = [255,249,51]
let PURPLE = [129,79,255]
let HOT_PINK = [250,75,212]
let SETTINGS = ["Dark Mode", "24 Hour Format", "Colorblind Mode", "Line Mode"]
let SETTINGS_ICONS = ["darkmode_icon", "24hr_icon", "colorblind_icon", "linemode_icon"]
let HOURS = 24;

import SwiftUI
import Firebase
import GoogleSignIn
import UserNotifications

 var ref: DatabaseReference!

// Class to hold all environment objects
class Model : ObservableObject {
    // Will be a list of event objects
    @Published var events : [Event]
    @Published var settings : Dictionary<String, Bool>
    @Published var views : Dictionary<String, Bool>
    @Published var areNotifications : Bool
    @Published var loggedIn : Bool
    @Published var email : String
    @Published var parsedEmail : String
    @Published var currentDate : Date
//Variable to reference the UserNotifications class
    @Published var notificationManager = UserNotifications()
//Variable that toggles if notifications are enabled or disabled
    @Published var notificationsToggle : Bool
    init() {
        self.events = [Event]()
        self.settings = [
            "time24hr": false,
            "darkMode": true,
            "lineMode": false
        ]
        self.views = [
            "showMenu": false,
            "editMode": false,
            "eventMode": false
        ]
        self.areNotifications = true
        self.loggedIn = false
        self.email = ""
        self.parsedEmail = ""
        self.currentDate = Date()
        self.notificationManager = UserNotifications()
        self.notificationsToggle = false
    }
    
    // Updates Event list,
    func updateEventsFromDB(){
        var eventList = [Event]()
        // for each key, get values and append to Event list
        ref.child("\(self.parsedEmail)").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                
                ref.child(self.parsedEmail).child("\(key)").observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let start = value?["Start Date"] as? String ?? ""
                    let end = value?["End Date"] as? String ?? ""
                    let type = value?["Type"] as? String ?? ""
                    let color = value?["Color"] as? String ?? ""
                    let dateFormatter = DateFormatter()
                    var startDate = Date()
                    var endDate = Date()
                    
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                    
                    startDate = dateFormatter.date(from: start)!
                    endDate = dateFormatter.date(from: end)!
                    eventList.append(Event(subject: "\(key)", start_time: startDate, end_time: endDate, color: color, type: type))
                    self.events = eventList
                })
            }
        })
    }
    
    func calcAngles(start: Date, end: Date) -> [Double] {
        var newTaskAngles = [Double]()
        let startOffset = Calendar.current.dateComponents([.minute], from: Date(), to: start)
        let minutesFromStart = Int(startOffset.minute!)
        let endOffset = Calendar.current.dateComponents([.minute], from: Date(), to: end)
        let minutesFromEnd = Int(endOffset.minute!)
        var startInput = Double(360*minutesFromStart/1440)
        var endInput = Double(360*minutesFromEnd/1440)
        
        if startInput < 0 || startInput > 360 { startInput = 0 }
        if endInput < 0 || endInput > 360 { endInput = 0 }
        
        // Returns list of 2 (for alert & cue, only start is looked at)
        newTaskAngles.append(startInput)
        newTaskAngles.append(endInput)
        return newTaskAngles
    }
}

class EventAttributes : ObservableObject {
    @Published var index : Int
//Var that tells is alert was chosen for the event
    @Published var alertToggled : Bool
//Var that tells if cue was chosen for the event
    @Published var cueToggled : Bool
//Var that tells if task was chosen for the event
    @Published var taskToggled : Bool
//Var that holds the color selected for the event
    @Published var colorSelected : String
//Var that holds the description of the event
    @Published var description : String
//Vars to hold the date and time selected for the event
    @Published var selectedDate : Date
    @Published var selectedEndDate : Date
    @Published var idcounter: Int
    init() {
        index = 000
        alertToggled = true
        cueToggled = false
        taskToggled = false
        colorSelected = "RED"
        description = ""
        selectedDate = Date()
        selectedEndDate = Date(timeIntervalSinceReferenceDate: 0)
        idcounter = 0
    }
    
    public func objType() -> String {
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
    
    public func presetValuesOnEdit(email: String, event: String) -> Void {
        if event == "" {
            index = 0
            alertToggled = false
            cueToggled = false
            taskToggled = false
            colorSelected = "RED"
            description = ""
            selectedDate = Date()
            selectedEndDate = Date(timeIntervalSinceReferenceDate: 0)
        } else {
            ref.child("\(email)").child("\(event)").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let start = value?["Start Date"] as? String ?? ""
                let end = value?["End Date"] as? String ?? ""
                let type = value?["Type"] as? String ?? ""
                let color = value?["Color"] as? String ?? ""
                
                self.description = event
                let dateFormatterOrig = DateFormatter()
                
                dateFormatterOrig.locale = Locale(identifier: "en_US_POSIX")
                dateFormatterOrig.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                self.selectedDate = dateFormatterOrig.date(from: start)!
                self.selectedEndDate = dateFormatterOrig.date(from: end)!
                
                if type == "alert" {
                    self.alertToggled = true
                    self.cueToggled = false
                    self.taskToggled = false
                }
                else if type == "cue" {
                    self.alertToggled = false
                    self.cueToggled = true
                    self.taskToggled = false
                }
                else {
                    self.alertToggled = false
                    self.cueToggled = false
                    self.taskToggled = true
                }
                
                self.colorSelected = color
            })
        }
    }
}

//Struct to hold the elements needed to push a notification
struct Notification {
    var id: String
    var title : String
    var datetime : DateComponents
    init(ident: String, desc: String, datetimes: DateComponents) {
        id = ident
        title = desc
        datetime = datetimes
    }
  
}
class UserNotifications {
//Keeps track of the unique id for each event in the database
    var idcounter = 0
//Holds the notifications to be scheduled
    var notifications : [Notification] = [Notification]()
//Prompts the user to allow notifications to be pushed
    private func registerForLocalNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
//if authorization is given and notifications are enabled then schedule the notifications
            if granted == true && error == nil{
                self.scheduleNotifications()
            }
        }
    }
//Public function to call the notifications class for scheduling
    func schedule() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
//Pushes to the user if they want to authorize notifications
                self.registerForLocalNotifications()
            case .authorized, .provisional:
//calls the schedulenotifications function is authorization is given
                self.scheduleNotifications()
            default:
                break //Do nothing
            }
        }
    }
    private func scheduleNotifications()
    {
//Iterates through the notifications array scheduling each one for its respective time
        for notification in notifications
        {
//Variables used in trigger and request
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.sound = .default
            let trigger = UNCalendarNotificationTrigger(dateMatching: notification.datetime, repeats: false)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
//Adds the most recent event to the notification center to prompt the user at its designated time
            UNUserNotificationCenter.current().add(request)
            { error in
                guard error == nil else { return }
                // print ("Notification scheduled!")
 //           }
            }
        }
    }
//Not populating notifications at the moment but this function retrieves the events from the database when the user signs in
    func retrieveFromDB (email: String){
//the users parsed email
        let userEmail = email
        var eventNames = ""
//grabs the current date and time
        var now = Date()
//child gives a snapshot reference to the database
        ref.child("\(userEmail)").observeSingleEvent(of: .value, with: { (snapshot) in
//iterates over each event in the database
            for child in snapshot.children {
//formats all the children from the database to be stored in eventNames as a list like object
                let snap = child as! DataSnapshot
                let key = snap.key
                eventNames += "|\(key)"
//Holds all the names of the events
                var events = eventNames.components(separatedBy: "|")
//removes the first empty entry in from initialization of eventNames
                events.removeFirst()
//Loops through all the events to parse the start date for each one
                for event in events {
//creates a snapshot of the database to acquire the startdate and description
                        ref.child("\(userEmail)").child("\(event)").observeSingleEvent(of: .value, with: { [self] (snapshot) in
                        let value = snapshot.value as? NSDictionary
//grabs the start date as a string as thats how it is stored in Firebase
                        let start = value?["Start Date"] as? String ?? ""
//These format the start date string back to the Date type
                        let dateFormatterOrig = DateFormatter()
                        dateFormatterOrig.locale = Locale(identifier: "en_US_POSIX")
                        dateFormatterOrig.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
//selecteddate is of the right type to schedule for notifications
                        let selectedDate = dateFormatterOrig.date(from: start)!
//figures out how much time (in seconds) is inbetween the selected date and now
                        let interval = selectedDate.timeIntervalSince(now)
//adds the difference between the two dates to allow the system to know when to prompt the user
                        now.addTimeInterval(interval)
              //                 print("now \(now)")
//Parses the Date object to individual ints
                        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
                        let targetYear = components.year ?? 0
                        let targetMonth = components.month ?? 0
                        let targetDay = components.day ?? 0
                        let targetHour = components.hour ?? 0
                        let targetMinute = components.minute ?? 0
                        let targetSecond = components.second ?? 0
//increments the id for the next notification
//populates the notifications array with the current notifications
                        let notificationHolder = Notification(ident: "event-\(self.idcounter)",desc: event, datetimes: DateComponents(calendar: Calendar.current, year: targetYear, month: targetMonth, day: targetDay, hour: targetHour, minute: targetMinute, second: targetSecond))
                        notifications.append(notificationHolder)
//schedules the notifcation grabbed from the database
                        scheduleNotifications()
                        self.idcounter += 1
                        })
                }
            }
        })
    }
}
//if user.isLoggedIn {
//        MainView()
//    } else {
//        LoginView()


struct ContentView: View {
    @EnvironmentObject var data: Model
    @EnvironmentObject var attr : EventAttributes
    // Should probably put these in the environment using EnvironmentObject
    /*
    @State var currentDate = Date()         // gives current date/time
    @State var areNotifications = true      // if there are notifications
    @State var time24hr = false             // 24 format toggle (default: 12)
    @State var darkMode = true              // Dark mode toggle (default: dark)
    @State var lineMode = false             // Line mode toggle (default: off)
    @State var showMenu = false             // Toggle Menu View
    @State var editMode = false
    @State var eventMode = false
    @State var loggedIn = false
    @State var pEmail = ""
    
    @State private var email: String = ""
    @State private var isPresentingSheet = false
    */
    @State var pEmail = ""
    @State var isPresentingSheet = false
    /// This property will cause an alert view to display when it has a non-null value.
    @State private var alertItem: AlertItem? = nil
    
    var body: some View {
        ZStack {
            //Segment()
            let drag = DragGesture()
                        .onEnded {
                            if $0.translation.width > 50 {
                                withAnimation {
                                    data.views["showMenu"] = true
                                }
                            }
                            if $0.translation.width < -50 {
                                withAnimation {
                                    data.views["showMenu"] = false
                                }
                            }
                        }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // HomePage(time24hr: self.$time24hr, darkMode: self.$darkMode, lineMode: self.$lineMode, showMenu: self.$showMenu, editMode: self.$editMode,eventMode: self.$eventMode, currentDate: self.$currentDate, areNotifications: self.$areNotifications)
                    HomePage()
                        .environmentObject(data)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .disabled(self.data.views["editMode"] == true ? true : false)
                        .blur(radius: self.data.views["editMode"]! ? 10 : 0)
                        .gesture(drag)
                    if self.data.views["showMenu"]! {
                        Menu()
                            .environmentObject(data)
                            .transition(.move(edge: .leading))
                            .animation(.spring())
                            .gesture(drag)
                    }
                    
                    if self.data.views["editMode"]! {
                        EditView(attr: self.attr)
                            .environmentObject(data)
                            .animation(.easeOut(duration: 1.5))
                    }
                    //Switches to addpage when the eventMode is toggled
                    if self.data.views["eventMode"]! && !self.data.views["editMode"]! {
                        EventHandler(editEvent: "")
                            .environmentObject(data)
                            .environmentObject(attr)
                    }
                }
            }
            if !self.data.loggedIn {
                NavigationView {
                      VStack(alignment: .leading) {
                        Spacer()
                        Text("Authenticate with your email:")
                          .padding(.bottom, 60)
                        CustomStyledTextField(placeholder: "Email", symbolName: "person.circle.fill"
                            //if()
                        
                        
//                        ref.child("user_id").child("child").setValue(123456)
//                        //ref.child("odd nums").child.setValue(13579)
//
//                        ref.child("odd nums").observeSingleEvent(of: .value, with: { (snapshot) in
//                        if let id = snapshot.value as? Int {
//                        print("The value from the database: \(id)")
//                        }
//                        })
                        
                        ).environmentObject(data)

                        CustomStyledButton(title: "Send Sign In Link / Login", action: {
                            sendSignInLink()
                            data.notificationManager.retrieveFromDB(email: data.parsedEmail)
//                            data.notificationManager.schedule()
                        })
                            .disabled(self.data.email.isEmpty)
                        Spacer()
                      }
                      .padding()
                      .navigationBarTitle("Passwordless Login")
                    }
                
                    .onOpenURL { url in
                      let link = url.absoluteString
                      if Auth.auth().isSignIn(withEmailLink: link) {
                        passwordlessSignIn(email: self.data.email, link: link) { result in
                          switch result {
                          case let .success(user):
                            isPresentingSheet = user?.isEmailVerified ?? false
                          case let .failure(error):
                            isPresentingSheet = false
                            alertItem = AlertItem(
                              title: "An authentication error occurred.",
                              message: error.localizedDescription
                            )
                          }
                        }
                      }
                    }
                .sheet(isPresented: self.$isPresentingSheet, onDismiss:
                        { self.data.loggedIn = true }) {
                    SuccessView(email: self.data.email)

                    }
                
                
                
                .alert(item: $alertItem) { alert in
                    SwiftUI.Alert(
                        title: Text(alert.title),
                        message: Text(alert.message)
                    )
                }
                
                .onDisappear {
                    data.updateEventsFromDB()
                    // CircleView.getEvents(email: self.data.email)
                    // CircleView.allocateAngles()
                }
            } // end of if statement
        }
    }

    
    private func sendSignInLink() {
        var validEmail = true
        var validAcct = false
        
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://matt.page.link/vAA2")
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        
        self.pEmail = self.data.email.replacingOccurrences(of: "@", with: "", options: NSString.CompareOptions.literal, range: nil)
        self.pEmail = pEmail.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        self.data.parsedEmail = pEmail
        
        ref.child(pEmail).observe(.value) { (snapshot) in
            
            if snapshot.exists() {
                    validAcct = true
                    self.data.loggedIn = true
            }
            else {
                if(validAcct == false) {
                Auth.auth().sendSignInLink(toEmail: self.data.email, actionCodeSettings: actionCodeSettings) { error in
                  if let error = error {
                    alertItem = AlertItem(
                      title: "The sign in link could not be sent.",
                      message: error.localizedDescription
                    )
                    validEmail = false
                  }
                    if(validEmail) {
                        
                        if(!validAcct) {
                            //ref.child(pEmail).setValue(1)
                        }
                        EventHandler(editEvent: "")
                            .environmentObject(data)
                            .environmentObject(attr)
                        //POPULATE OBJECTS
                    }
                }
                }
            }
        }
        
        
      }
    
    
    
    private func passwordlessSignIn(email: String, link: String,
                                      completion: @escaping (Result<User?, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, link: link) { result, error in
          if let error = error {
            print("ⓧ Authentication error: \(error.localizedDescription).")
            completion(.failure(error))
          } else {
            print("✔ Authentication was successful.")
            completion(.success(result?.user))
            ref.child(pEmail).setValue(1)
          }
        }
      }
    
    }


struct AlertItem: Identifiable {    // *
  var id = UUID()
  var title: String
  var message: String
}

struct CustomStyledTextField: View {
    @EnvironmentObject var data : Model
    let placeholder: String
    let symbolName: String

    var body: some View {
        HStack {
          Image(systemName: symbolName)
            .imageScale(.large)
            .padding(.leading)

            TextField(placeholder, text: $data.email)
            .padding(.vertical)
            .accentColor(.orange)
            .autocapitalization(.none)
        }
        .background(
          RoundedRectangle(cornerRadius: 16.0, style: .circular)
            .foregroundColor(Color(.secondarySystemFill))
        )
    }
}

/// A custom styled button with a custom title and action.
struct CustomStyledButton: View {
  let title: String
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      /// Embed in an HStack to display a wide button with centered text.
      HStack {
        Spacer()
        Text(title)
          .padding()
          .accentColor(.white)
        Spacer()
      }
    }
    .background(Color.orange)
    .cornerRadius(16.0)
  }
}


/// Displayed when a user successfuly logs in.
struct SuccessView: View {
  let email: String
    var body: some View {
    /// The first view in this `ZStack` is a `Color` view that expands
    /// to set the background color of the `SucessView`.
    ZStack {
      Color.orange
        .edgesIgnoringSafeArea(.all)

      VStack(alignment: .leading) {
        Group {
          Text("Welcome")
            .font(.largeTitle)
            .fontWeight(.semibold)

          Text(email.lowercased())
            .font(.title3)
            .fontWeight(.bold)
            .multilineTextAlignment(.leading)
        }
        .padding(.leading)

        Image(systemName: "checkmark.circle")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .scaleEffect(0.5)
      }
      .foregroundColor(.white)
    }
  }

}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct HomePage: View {
    @EnvironmentObject var data : Model
    /*
    @Binding var time24hr: Bool             // 24 format toggle (default: 12)
    @Binding var darkMode: Bool             // Dark mode toggle (default: dark)
    @Binding var lineMode: Bool             // Line mode toggle (default: off)
    @Binding var showMenu: Bool             // Menu toggleable  (default: don't show)
    @Binding var editMode: Bool
    @Binding var eventMode: Bool
    @Binding var currentDate: Date
    @Binding var areNotifications: Bool
    */
    @State var taskAngles = [[Angle]]()
    @State var tasks = CircleView.tasks
    @State var colors = [Color.blue, Color.red, Color.orange, Color.green, Color.yellow, Color.purple]
    // Functions and variables used to create a functioning digital clock
    var timeFormat: DateFormatter {
         
        ///////// DB TEST
        ref = Database.database().reference()
        ///////// DB TEST

        
        let formatter = DateFormatter()
        if !self.data.settings["time24hr"]! {
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
                                        self.data.currentDate = Date()
                                        if self.data.parsedEmail != "" && self.data.loggedIn {
                                            self.data.updateEventsFromDB()
                                        }
                                       })
    }
    
    struct Arc: Shape {
        var startAngle: Angle
        var endAngle: Angle
        var clockwise: Bool
        var inset: CGFloat = 0
        
        func path(in rect: CGRect) -> Path {
            let rotationAdjustment = Angle.degrees(90)
            let modifiedStart = -startAngle - rotationAdjustment
            let modifiedEnd = -endAngle - rotationAdjustment
            
            var path = Path()
            path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2.05, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)
            
            return path
        }
        
    }
    @ViewBuilder
    var body: some View {

        NavigationView {
            Color(rgb: self.data.settings["darkMode"]! ? DARK_GREY : WHITE)
                .ignoresSafeArea()
                .overlay(
                    ZStack (alignment: .leading) {
                        
                        VStack {
                            // Digital Clock, Menu, and Notifications
                            HStack {
                                // Sketchy menu icon made from 2 Images
                                Spacer()
                                Button(action: {
                                    withAnimation {
                                        self.data.views["showMenu"]!.toggle()
                                    }}) {
                                    HStack {
                                        Image("menu_icon")
                                            .resizable()
                                            .frame(width: 30, height: 40)
                                            .foregroundColor(self.data.settings["darkMode"]! ? Color.white : Color(rgb: DARK_GREY))
                                            .offset(x: 0, y: 13)

                                            Image("menu_arrow")
                                                .resizable()
                                                .frame(width: 10, height: 10)
                                                .foregroundColor(self.data.settings["darkMode"]! ? Color.white : Color(rgb: DARK_GREY))
                                                .offset(x: -12, y: 6)
                                                .rotationEffect(Angle(degrees: 270), anchor: .bottomLeading)
                                    }
                                }
                                Spacer()
                                // Digital Clock
                                HStack {
                                    // Time will always result in "h:mm a" format in 12hr format, therefore
                                    // time[0] - h:mm
                                    // time[1] - AM/PM
                                    // Otherwise, if 24hr format, only time[0]
                                    let time = timeToString(date: self.data.currentDate).components(separatedBy: " ")
                                    
                                    Text("\(time[0])")
                                        .onAppear(perform: {
                                            let _ = self.updateTimer
                                        })
                                    .font(Font.custom("Comfortaa-Light", size: 60))
                                        .foregroundColor(self.data.settings["darkMode"]! ? Color.white : Color(rgb: DARK_GREY))
                                    
                                    if !self.data.settings["time24hr"]! {
                                        Text("\(time[1].lowercased())")
                                            .font(Font.custom("Comfortaa-Light", size: 20))
                                            .foregroundColor(self.data.settings["darkMode"]! ? Color.white : Color(rgb: DARK_GREY))
                                            .offset(x: -7, y: 10)
                                    }
                                }.offset(x: (self.data.settings["time24hr"]!) ? -35 : -23, y: 16)
                                .padding(.horizontal, 10)
                                .frame(width: 230, height: 55)
                                .fixedSize()
                                Spacer()
                                /*
                                // Notifications
                                ZStack {
                                    Button(action: {
                                        withAnimation {
                                            data.notificationsToggle.toggle()
                                        }
                                    }){
                                        HStack {
                                            if (data.notificationsToggle == true) {
                                                Image("notifications_bell")
                                                    .resizable()
                                                    .frame(width: 40, height: 40)
                                                    .foregroundColor(self.data.settings["darkMode"]! ? Color.white : Color(rgb: DARK_GREY))
                                                    .offset(x: -10, y: 17)
                                            }
                                            else {
                                                Image("notifications_bell_muted")
                                                    .resizable()
                                                    .frame(width: 40, height: 40)
                                                    .foregroundColor(self.data.settings["darkMode"]! ? Color.white : Color(rgb: DARK_GREY))
                                                    .offset(x: -10, y: 17)
                                            }
                                        }
                                    }
                                    // if there are notifications
                                    if self.data.areNotifications {
                                        Circle()
                                            .frame(width: 15, height: 15, alignment: .trailing)
                                            .foregroundColor(Color(rgb: RED))
                                            .offset(x: 0, y: 5)
                                    }
                                }*/
                                
                            }
                            
                            
                            // ZStack containing both circular display and linear display
                            ZStack {
                                if self.data.settings["lineMode"]! {
                                    // Linear Timeline
                                    VStack(spacing: 80) {
                                        Text("")
                                        GeometryReader { fullView in
                                                                    
                                            // Top Arrow for indicating position on timeline
                                            Image("menu_arrow")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                                .foregroundColor(self.data.settings["darkMode"]! ? Color.white : Color(rgb: DARK_GREY))
                                            .offset(x: UIScreen.main.bounds.size.width/2, y: 15)
                                                                    
                                            // ScrollView that scales with HStack width
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                                        
                                                // HStack with top measurement indicators
                                                HStack {
                                                    ForEach (0 ..< HOURS) { i in
                                                        Rectangle()
                                                            .fill(self.data.settings["darkMode"]! ? Color.white : Color(rgb: DARK_GREY))
                                                            .frame(width: 1, height: 30)
                                                            .offset(y: -15)
                                                        Spacer().frame(width: UIScreen.main.bounds.size.width/4)
                                                    }
                                                }
                                                                        
                                                // HStack with placeholder icons and timeline segments
                                                HStack() {
                                                    Rectangle()
                                                        .fill(Color(rgb: RED))
                                                        .frame(width: UIScreen.main.bounds.size.width*1.5, height: 5)
                                                    Image("24hr_icon")
                                                        .resizable()
                                                        .frame(width: 25, height: 25)
                                                        .foregroundColor(self.data.settings["darkMode"]! ? Color.white : Color(rgb: DARK_GREY))
                                                    Rectangle()
                                                        .fill(Color(rgb: ORANGE))
                                                        .frame(width: UIScreen.main.bounds.size.width*1.5, height: 5)
                                                    Image("close_icon")
                                                        .resizable()
                                                        .frame(width: 25, height: 25)
                                                        .foregroundColor(self.data.settings["darkMode"]! ? Color.white : Color(rgb: DARK_GREY))
                                                    Rectangle()
                                                        .fill(Color(rgb: BLUE))
                                                        .frame(width: UIScreen.main.bounds.size.width*2, height: 5)
                                                }.frame(width: UIScreen.main.bounds.size.width*6, height: 20)
                                                                        
                                                // HStack with bottom measurement indicators
                                                HStack() {
                                                    ForEach (0 ..< HOURS) { i in
                                                        Rectangle()
                                                            .fill(self.data.settings["darkMode"]! ? Color.white : Color(rgb: DARK_GREY))
                                                        .frame(width: 1, height: 30)
                                                        .offset(y: 15)
                                                    Spacer().frame(width: UIScreen.main.bounds.size.width/4)
                                                }
                                            }
                                        }
                                                                    
                                        // Bottom Arrow for indicating position on timeline
                                        Image("menu_arrow")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(self.data.settings["darkMode"]! ? Color.white : Color(rgb: DARK_GREY))
                                            .rotationEffect(.degrees(180))
                                            .offset(x: UIScreen.main.bounds.size.width/2, y: 60)
                                    }
                            }.frame(width: UIScreen.main.bounds.size.width, height: 200, alignment: .center)
                        } else {
                            // Circular Timeline
                            // Orbital Circle
                            // Should rotate with the time -- DONE
                            // Should have colored arcs for separate events -- DONE
                            // Should have icons for alerts and cues
                            Circle()
                                .strokeBorder(self.data.settings["darkMode"]! ? Color.white : Color(rgb: DARK_GREY, alpha: 0.9), lineWidth: 8)
                                .frame(width: UIScreen.main.bounds.size.width / 1.1)
                                
                            // Arcs
                            // Should also rotate with time
                            ZStack {
                                ForEach(0 ..< self.data.events.count, id: \.self) { i in
                                    let interval = data.calcAngles(start: data.events[i].get_start_time(), end: data.events[i].get_end_time())
                                    if data.events[i].get_type() == "task" {
                                        Arc(startAngle: .degrees(interval[0]), endAngle: .degrees(interval[1]), clockwise: false)
                                            .stroke(Color(rgb: InfoView.translateColor(color: data.events[i].get_color())), lineWidth: 8)
                                            .frame(width: UIScreen.main.bounds.size.width/1.1, height: UIScreen.main.bounds.size.width/1.1, alignment: .center)
                                    }
                                }
                            }
                                            
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
                            
                            // Pointer
                            Image("menu_arrow")
                                .resizable()
                                .foregroundColor(self.data.settings["darkMode"]! ? .white : Color(rgb: DARK_GREY))
                                .frame(width: 30, height: 25)
                                .offset(y: -UIScreen.main.bounds.width / 2.15)
                                //.offset(y: -175)
                        }
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
                                Button(action: {withAnimation{self.data.views["eventMode"]!.toggle() }}) {
                                    ZStack {
                                        Circle()
                                            .foregroundColor(Color(rgb: ORANGE))
                                            .frame(width: UIScreen.main.bounds.size.width / 4, height: UIScreen.main.bounds.size.width / 4, alignment: .center)
                                        Text("+")
                                            .font(Font.custom("Comfortaa-Regular", size: 70))
                                            .foregroundColor(Color(rgb: DARK_GREY, alpha: 0.9))
                                            .offset(y: 5)
                                    }
                                }.padding(.horizontal, 50)
                                
                                // Delete button
                                // Changes the view to the deleteView (use NavigationLink)
                                Button(action: {
                                    withAnimation{self.data.views["editMode"]!.toggle(); for e in self.data.events {
                                        print("Subject: \(e.get_subject())")
                                        print("Angles: \(data.calcAngles(start: e.get_start_time(), end: e.get_end_time()))")
                                        print("\(e.get_color())")
                                        print("\(e.get_type())")
                                    } }}) {
                                    ZStack {
                                        Circle()
                                            .foregroundColor(Color(rgb: ORANGE))
                                            .frame(width: UIScreen.main.bounds.size.width / 4, height: UIScreen.main.bounds.size.width / 4, alignment: .center)
                                        Image("edit_icon")
                                            .foregroundColor(Color(rgb: DARK_GREY, alpha: 0.9))
                                            .scaleEffect(1.8)
                                            .offset(x: 1)
                                    }
                                    
                                }.padding(.horizontal, 50)
                            }.offset(y: -20)
                            Spacer()
                        }
                        .navigationBarHidden(true)
                        .preferredColorScheme(self.data.settings["darkMode"]! ? /*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/ : .light)
                        // end of VStack
                        
                    } // end of ZStack
                ) // end of overlay
        }
        
    }
    
}

// Menu View
struct Menu : View {
    @EnvironmentObject var data : Model
    // might be bad practice
    // any button that gets pressed from settings
    // triggers an action based on the setting pressed
    
    func performSettingAction(setting: String) -> Void {
        switch(setting) {
        case SETTINGS[0]:
            self.data.settings["darkMode"]!.toggle()
        case SETTINGS[1]:
            self.data.settings["time24hr"]!.toggle()
        case SETTINGS[2]:
            print("placeholder for colorblind mode")
        case SETTINGS[3]:
            self.data.settings["lineMode"]!.toggle()
        default:
            print("Error: No action in settings for \(setting)")
        }
    }

    
    var body: some View {
        ZStack {
            Button(action: {withAnimation {self.data.views["showMenu"]!.toggle()}}) {
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
                                .foregroundColor(self.data.settings["darkMode"]! ? Color.white : Color(rgb: DARK_GREY))
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
            .background(self.data.settings["darkMode"]! ? Color(rgb: DARK_GREY) : Color.white)
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
