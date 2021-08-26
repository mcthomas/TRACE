<img src="readme images/icon.png" width="200"/>

# TRACE

TRACE is an iOS application which aims to aggregate the use of calendar events, alarms, and reminders- with single-dimensional UI naunces.  In practice, TRACE decreases the time spent hopping between native apps and visually simplifies your mental view of your daily flow.  Development on TRACE began in academia at UW-Madison with the intent of demonstrating principles of Software Engineering & UX best practices.  This readme comprises our original Design & Planning Documentation.  

Contributors:

- [Ethan Schnaser](mailto:schnaser@wisc.edu)
- [Matt Thomas](mailto:mcthomas4@wisc.edu) 
- [Nathan Frank](mailto:ncfrank@wisc.edu)
- [Stone Yang](mailto:syang477@wisc.edu)
- [Tony Schulz](mailto:schulz22@wisc.edu)
- [Travor Hamilton](mailto:thamilton5@wisc.edu)
- [Will Dominski](mailto:wdominski@wisc.edu)

## Contents

- [1. System Architecture](#System-Architecture "System Architecture")
    - 1.1. Overview
    - 1.2. Event-Based architecture 
    - 1.3. Notification Service
    - 1.4. Alternate architectural Design
    - 1.5. Design Risks

- [2. Design Details](#Design-Details "Design Details")
    - 2.1. iOS Backend Design
    - 2.2. iOS User Interface Design 
    - 2.3. Notifications Design
    - 2.4. UI View Details

- [3. Implementation Plan](#Implementation-Plan "Implementation Plan")
    - 3.1. Dependencies

- [4. Testing Plan](#Testing-Plan "Testing Plan")
    - 4.1. Unit Testing
    - 4.2. Integration Testing
    - 4.3. System Testing
    - 4.4. Performance Testing 
    - 4.5. Compatibility Testing 
    - 4.6. Regression Testing 
    - 4.7. Beta Testing

- [5. Prototype Presentations](#Prototype-Presentations "Prototype Presentations")

## System Architecture

### 1.1 Overview

The Trace application will use an Event-Based Software Architecture. We chose this architecture over others because minimalism is the core foundation of the design for this app. Trace is curated for the individual, a basic tool for the user to be able to plan and execute their daily routine, while accommodating outside factors (unknown plans or events). This means having an application that is meant to mostly display data to the user, while allowing them to trigger specific events to occur, such as adding specific tasks, cues and alerts.

### 1.2 Event-Based Architecture

#### 1.2.1 Events

An event is any significant change that affects the software or hardware of the application. In the case of Trace, an event could come from the user, by adding or removing tasks, alerts, or cues from their timelines, changing any of the notifications settings for Tasks, Cues or Alerts, or altering the preferences for the application as a whole. Events could also come from the application itself in the form of notifications being sent to the users device regarding specific events that the user has set up to be notified of.

#### 1.2.2 User Interface Architecture

The iOS application interface IDE, Xcode, serves as the dev view for this application. The user interface is developed completely in Swift. The individual screens and functions of the UI can be accomodated with the Action Sequence Flow pictured below. Each individual screen is depicted by a light green oval, though initially the timeline home screen will be displayed to the user. This is where the user will be able to see their Tasks, Alerts and Cues that they have set up to be displayed prior. From there, the user has the option to go to the Notification Settings screen. This screen will consist of tabs for Tasks, Alert and Cues that will drop down into specific settings such as time and frequency of notifications. From the Display Timeline screen, the user will also be able to add Tasks, Alerts and Cues, by pressing the add button, which will present a pop up allowing them to set the description and time of the tool they selected. The user will also be able to delete a tool by pressing the delete button, which will present a pop-up menu overlay listing the tools they already have set in place. Finally, from the Display Timeline screen, the user will be able to navigate to the Options screen by pressing the Options button, which will allow them to select the display type, toggle color blind mode, toggle dark mode, and choose their time format.

<img src="readme images/action-sequence-flow.png" width="600"/>

### 1.3 Notification Service

The application will make use of the Apple Push Notification service for the notification purposes. As described in the 1.2.1, notifications would be sent to the user by the system based on the settings and preferences that the user has set for each of the Tasks, Alerts and Cues they have created.

### 1.4 Alternate Architecture Design

An alternative architecture design for our application would be using passing information between the user and the application through a server. We have implemented server-side data via Firebase for those that want to access their data through an account, to improve accessibility between separate devices.

### 1.5 Design Risks

The design risks of our implementation of Event-Based architecture are few to none. One risk of this design would be if a user were to lose or damage the device that contains the application, if they have not opted to store their data server-side. 

## Design Details

### 2.1 iOS Backend Design

<img src="readme images/backend-design.png" width="600"/>

#### 2.1.1 Class Descriptions

This class diagram only shows the core classes in our application and how they relate to each other on a highly-abstracted level. In section 2.2 we go over the upper level classes such as AppDelegate, ContentView, and UIapplication.  

#### 2.1.1.1 Alert/Task/Cue

These classes serve the purpose of instantiating the different events that will go on the timeline. When the add_alert/cue/task() button is clicked then the respective class will be called and the screen will switch to a view where start_time, end_time, subject, and the colorHex will be filled out. 

###### Methods

set_subject(): void
			Sets the respective event’s subject matter.  
get_subject(): String
			Retrieves the subject matter of the tracked event.
set_start_time(): void
			Sets the respective event’s start time.
get_start_time(): Double
			Retrieves the respective event’s start time.
set_end_time(): void
			Sets the respective event’s end time.
get_end_time(): Double
			Retrieves the respective events end time.
set_colorHex(): void
			Sets the respective event’s color according to the hex value.
get_colorHex(): String
			Retrieves the respective event’s hex color value. 
###### Attributes

subject: String
This string contains the subject matter of the event.

start_time: Double
This double contains the start time for the event.

end_time: Double
This double contains the end time for the event.

colorHex: String
This string contains the color of the event in its hex value.

alert/task/cue_name: String
This string allows the user to switch the names of the Alert, Cue, or Task events.  

	
#### 2.1.1.2 Settings

###### Methods

set_alert/task/cue_name(): void
If the user wishes to change the name of alert/task/cue then they can with this function. 

get_alert/task/cue_name(): Alert/Task/Cue
This function returns the name of the specific event being called.

###### Attributes

timeline_type: Boolean
This boolean variable allows the user to change the design of the timeline. We will be giving the operator the option of a circular, roundabout design, or a linear one. Having it set as a boolean makes the switch easy.

colorblind_mode: Boolean
As the different events in the timeline rely on hex color values for differentiation, we plan to allow the user the option of colorblind_mode. Changing the value from 0 to 1 will activate the change helping someone who has difficulty seeing certain colors some relief. 

alert_name: String
This string specifies the name of the alert event.

task_name: String
This string specifies the name of the task event.

cue_name: String
This string specifies the name of the cue event.

#### 2.1.1.3 Timeline

###### Methods

is_active(): Boolean
This method will be connected to an exit button. When the button is pressed then the boolean value will change to 0, exiting the app. 

switch_to_settings(): Settings
This method will be called when the settings icon is clicked. It calls the settings class which changes the view and provides options to customize.

notify(): void
This function will notify the user when one of the events has reached its start time. 

add_alert(): Alert
This function when called will change the timeline to a different view where the user inputs the fields for the alert class. 

delete_alert(): void
This function will remove the selected alert from the Swift Database.  

add_task(): Task
This function when called will change the timeline to a different view where the user inputs the fields for the task class. 

delete_task(): void
This function will remove the selected task from the Swift Database. 

add_cue(): Cue
This function when called will change the timeline to a different view where the user inputs the fields for the cue class. 

delete_cue(): void
This function will remove the selected cue from the Swift Database.

###### Attributes

day: Int
This Int will keep track of which days the events are stored in so the app can accurately remind the user of said event on that date.

monthName: String
This string will keep track of which month the events are stored in so the app can accurately remind the user of said event on that date.

year: Int
This Int will keep track of the year the events are stored in so the app can accurately remind the user of said event on that date.

events: Swift Dictionary
This variable will keep track and store all of the events that are created on our app. We’re utilizing a Swift Dictionary to store the data as a Key, Value combo. The key will be the name of the task and all the fields in the alert/task/cue class will be stored as the value. 

selected_event: String
The selected_event variable will keep track of an event that the user has clicked on. This would be used in the delete method and for fine tuning of a specific event. 

### 2.2 iOS User Interface Design

#### Model

The iOS user interface will be designed with a top-level controller instance, ApplicationUI(), which would call ContentView() after it is initialized by AppDelegate() via AppDelegate()’s call to @main.  The main structural logic of the application will be a series of event-driven calls to update the structs and UI components whenever they request such, relying on ApplicationUI() to listen accordingly.  In this way, AppDelegate() will initialize the application with its main reference, though it will then hand control to ApplicationUI() so that it can drive the application’s updates.  

#### View/Controller

We are considering implementing a hybrid approach for the lower levels which may best accommodate UI components, if ContentView() serves the “View” role and ApplicationUI() acts as a ghost “Controller” for the user, accommodating all of their inputs.  The “Model” would be decentralized amongst calls outbound from ApplicationUI(), to conform to the higher-level event-driven approach. 


###### Top-Level Event Driven Visual: (Class Diagram):

<img src="readme images/class-diagram.png" width="800"/>

#### Class/Var/Method Breakdown

###### App

ApplicationUI():
Enables the UIApplication instance and the launch options for initialization.

Struct App:
Intializes ContentView() to compose a Scene object.

###### UIApplication

applicationState:
The app’s current state, or that of its most active scene.

connectedScenes:
The app's currently connected scenes.

openSessions:
The sessions whose scenes are either currently active or archived by the system.

requestSceneSessionActivation():
Asks the system to activate an existing scene, or create a new scene and associate it with your app.

requestSceneSessionDestruction():
Asks the system to dismiss an existing scene and remove it from the app switcher.

requestSceneSessionRefresh():
Asks the system to update any system UI associated with the specified scene.

applicationIconBadgeNumber:
The number currently set as the badge of the app icon in Springboard.

userInterfaceLayoutDirectionUI:
Returns the layout direction of the user interface.

UIUserInterfaceLayoutDirection:
Enum which specifies the directional flow of the user interface.

sendEvent(UIEvent):
Dispatches an event to the appropriate responder objects in the app.

sendACtion(to, from, for):
Sends an action message identified by selector to a specified target.

###### ContentView

lightMode:
A boolean to indicate whether the colors should be inverted, as toggled with input to the respective settings overlay

Imperial:
A boolean to indicate whether the unit  ticks along either of the timeline UIs should display in imperial or metric units

isCircle:
A boolean to determine whether to display the circle timeline ui or the linear line

showCal:
A boolean to indicate whether the calendar UI should be rotated into view to allow the user a broader view of their schedule.

curCircle:
Maintains the instance of the Circle UI object instantiated, to be read from or manipulated.

curLine:
Maintains the instance of the Line UI object instantiated, to be read from or manipulated.

curCalView:
Maintains the instance of the CalView UI object instantiated, to be read from or manipulated.

Body:
Maintains finer details of the current view for assembly and updates.

###### CircleView

Tasks:
An array of Task instances maintained.

Alerts:
An array of Alert instances maintained.

Cues:
An array of Cue instances maintained.

arrangeChrono(tasks, alerts, cues):
Orders the related instances in chronological order.

allocateAngles(task, alerts, cues):
Method to accordingly bound the color arcs according to the instance durations/time stamps.

assignColors(tasks, alerts, cues):
Chooses hex values to assign to the color segments.

scale(int):
Tracks the value with which to scale the unit ticks.

Line (ident to above, considering inheritance)

CalView (inherits first 5 specs from above)

printObjects(tasks, alerts, cues):
Prints respective info about data tied to the Task/Alert/Cue instances.

###### Overlays

masterAdd():
Correlates to UI button “+” to add (instantiate) a Task, Alert, or Cue.

masterRemove():
Correlates to UI button “-” to add (instantiate) a Task, Alert, or Cue.

viewCal():
Assembles respective UI components w/ data from the Task/Alert/Cue instances.

viewSettings():
Displays respective UI components for personalization toggles, referenced by ContentView() booleans.

viewNotifications():
Displays respective UI components for active notification listings, tied to instances of Task/Alert/Cue.

viewTicks(Int):
Displays respective UI components for unit ticks over the Circle or Line timeline, with reference to the scale factor Int.

###### Simplified Model-View-Controller Visual, to operate below ApplicationUI():

<img src="readme images/mvc.png" width="400"/>

###### User Model Sequence Diagram:

<img src="readme images/ums.png" width="800"/>

###### UI Risks

We must ensure that our application excludes any and all depreciated library classes, structs, and functions.  These may disqualify our app from being approved by Apple for deployment on the iOS App Store.  We must also ensure that there is continuity and cohesiveness across our visual design in order to ensure that it looks presentable and meets their standards.  Another risk for rejection is the existence of exploits or significant similarities to other existing apps on their store.  The former won’t be a concern since we are using native frameworks and disclosing data privacy notices for users that choose to keep their data server-side.  The latter is addressed with our unique visual approach and consolidation techniques, which we are prepared to defend as being novel.

### 2.3 Notifications Design

Our notification system currently relies on the Apple Local Notification system to be manipulated by our Driver class. IOS Development in Xcode provides a multitude of classes and objects for our driver to create new notifications and request to remove current notifications that the user has already created. E.g. the removePendingNotificationRequests method, provided in the UNUserNotificationCenter class, provided with the Notification content and triggers.

#### 2.3.1 Client Side Notification Handling

To set up notifications, the client would only need to provide the description of the Event/Notification and the time and date they want it delivered. To remove existing notifications, the user would simply select an already present Event/Notification that they had already created and press delete.

#### 2.3.2 Driver-Side Notification Handling

When the user inputs the description, time, and date for the notification, it would be the driver’s responsibility to access the UNMutableNotificationContent, UNCalendarNotificationTrigger, UNNotificationRequest, and UNUserNotificationCenter objects, which use the data inputted to create a new notification request, or possibly delete an existing one if that is what the user opted to do.

### 2.4 UI View Details

#### 2.4.1 Homepage: Starting page on application launch

<img src="readme images/home-screen-table.png" width="600"/>

#### 2.4.2 Delete Event Page: Page requests the user to delete the desired tasks/cues/alerts

<img src="readme images/delete-screen-table.png" width="600"/>

#### 2.4.3 Add Event Page: Requests user input to create a new event

<img src="readme images/add-event-screen-table.png" width="600"/>

#### 2.4.4 Menu Tab: Displays all additional options

<img src="readme images/menu-tab-screen-table.png" width="600"/>

#### 2.4.5 Notifications Tab: Displays all notifications relating to upcoming tasks/cues/alerts

<img src="readme images/notifications-tab-screen-table.png" width="600"/>

#### 2.4.6 Calendar View: Displays a more shallow, but broader view of events throughout the span of a month

<img src="readme images/calendar-screen-table.png" width="600"/>

## Implementation Plan

### 3.1 Dependencies:

The development process of this phase is split into key major components:

- iOS client development
- Back-end local & remote database: Scheduling on a certain time/date, different functionality between types of events
- Front-end User Interface: Overall design, homepage, event creation page, event deletion page, menu tab
- Testing (Section 4)

The back-end, front-end, and testing development can easily be done in conjunction with one another. The front-end UI design can be implemented completely independent from the back-end, and a simple linking of functions to UI is all that’s needed. This linking is the one part where the front-end is dependent on the backend status, but the time this will take isn’t significant.

In the initial development phase, we plan to start with the most barebones functionality in the backend and the frontend, such as adding/deleting events to the timeline and implementing the UI design. Additional functionality that’s not completely necessary, such as the menu tab’s additional features- like color-blind mode or data export- will be delayed until the basic functionality is implemented and present.

## Testing Plan

### 4.1 Unit Testing

#### Our unit testing will cover the following:

###### Core class and database functions:

- Task class data members and functions - constructor, get/set, etc
- Alert class data members and functions - constructor, get/set, etc
- Cue class data members and functions - constructor, get/set, etc
- Database system key functions - constructor

###### Basic UI testing

- AppDelegate
- Various Views
- These can be done with XCTests as well - Xcode has a UI testing platform built-in

The goal here is to ensure that all the basic parts work on their own and do what we expect them to do. This is often the most straightforward step in the testing process, but strong coverage is critical to avoiding various issues down the line.

These tests will be carried out using Xcode’s built-in testing library for Swift, XCTests.

### 4.2 Integration Testing

Our integration testing will cover the following:

- Core class integration
    - Syncing a task/alert/cue - we want users to be able to link these objects together (e.g. getting an alert for a task)
- Database functionality with each class
    - Ensure that database holds all of these classes and any relevant information about linked objects
- UI/backend integration
    - Complete actions on the UI to initiate the proper commands in the backend
        - e.g. ‘add task’ flow in UI results in a new task in database
    - Changing/updating information in the backend resulting in the proper changes in the UI
        - e.g. changing data for a task object results in the new data being shown in the UI

Here we are looking to guarantee that all of the pieces of our dev project communicate with each other as expected. These tests will be more involved and will likely require more coordination between QA devs and the backend/UI devs, as well as meetings which include all three role groups.

These tests will be carried out using Xcode’s built-in testing library for Swift, XCTests.

### 4.3 System Testing

Our system tests will focus on the program as a whole, extending on the integration tests and analyzing full-flow cases, such as:
- A user adding several tasks/events/cues, deleting some, adding more
- More in-depth testing of the UI: is there any button or series of buttons that can break our app?
- Adding dozens of objects, linking/unlinking, editing, and deleting - all in a single test

With these tests, we can begin examining more realistic use cases which involve more or all of the application's functions. This will prepare us for compatibility and acceptance testing, in which users will be directly interfacing with the app.

These tests will be carried out using Xcode’s built-in testing library for Swift, XCTests, as well as some testing of the UI through the iOS simulator app, an Apple developer tool which allows us to test our app on a virtual iOS device emulator.
	
### 4.4 Performance Testing

For performance testing, we will mainly be focused on the number of tasks/cues/alerts, as well as how they are linked, with regard to the runtime of various key operations of the application. Our performance testing will likely begin as early as the unit tests, but will continue throughout development. These will be directed primarily at our database and measure the change in runtime of add/search/delete functions as the size of the DB changes. We will also run performance tests on the UI to ensure that adding graphic elements does not significantly inhibit the ‘smoothness’ of the application - no freezing/frame skipping.

These tests will be carried out using Xcode’s built-in testing library for Swift, XCTests.

### 4.5 Compatibility Testing

Our compatibility testing will mostly be centered on the UI/UX - seeing how users feel about their overall experience while working with the app. If we did our previous testing well enough, there should not be any significant concern for areas including performance, integration, or system testing. There should be few errors present at this stage, but we hope to find any if they exist. 

These tests will be carried out using the iOS Simulator.

### 4.6 Regression Testing

This will primarily focus on reiterating and redefining our unit/integration/performance tests as we continue to develop features and functionality. It will be an ongoing process throughout development with the goal of ensuring that new changes aren’t interfering with the execution and performance of existing code. 

These tests will be carried out using Xcode’s built-in testing library for Swift, XCTests, as well as some testing of the UI through the iOS Simulator.

### 4.7 Acceptance Testing

Our acceptance testing phase will be similar to the compatibility testing in that we’ll be giving the app to clients to test, in order to refocus on their feedback. However, this phase will be much more in-depth and rigorous and will be significantly more goal-oriented, in that the users/clients will be given several specific tasks/tests to perform (similar to the ones we used for system testing) instead of simpler, mono-task tests. Additionally, it will be longer than the compatibility testing phase since it will act as the final catch-all for any bugs or places of potential improvement for the application.

## Prototype Presentations

[Outcomes & Lessons Learned](TRACE - Outcomes & Lessons Learned.pdf)

[Demo & Alterations](TRACE - Demo & Alterations.pdf)
