# TRACE

Design and Planning Document

<img src="trace.png"/>

## Contents

  - [1. System Architecture](#System-Architecture "System Architecture")

1.1. Overview
1.2. Event-Based architecture 
1.3. Notification Service
1.4. Alternate architectural Design
1.5. Design Risks

  - [2. Design Details](#Design-Details "Design Details")

2.1. iOS Backend Design
2.2. iOS User Interface Design 
2.3. Notifications Design
2.4. UI View Details

  - [3. Implementation Plan](#Implementation-Plan "Implementation Plan")

3.1. Dependencies
3.2. Iteration 1
3.3. Iteration 2
3.4. Iteration 3

  - [4. Testing Plan](#Testing-Plan "Testing Plan")

4.1. Unit Testing
4.2. Integration Testing
4.3. System Testing
4.4. Performance Testing 
4.5. Compatibility Testing 
4.6. Regression Testing 
4.7. Beta Testing

## System Architecture

### 1.1 Overview

The Trace application will use an Event-Based Software Architecture. We chose this architecture over others because minimalism is the core foundation of the creation of this app. To fuel efficiency within our app, we plan to not need a server at all. Trace is very individual, a basic tool for the user to be able to plan and execute their daily routine, while accommodating outside factors (Unknown plans or events). This means having an application that is meant to mostly display data to the user, while allowing them to trigger specific events to occur, events such as adding specific tasks, cues and alerts.

### 1.2 Event-Based Architecture

#### 1.2.1 Events

An event is any significant change that affects the software or hardware of the application. In the case of Trace, an event could come from the user, by adding or removing tasks, alerts, or cues from their timelines, changing any of the Notifications settings for Tasks, Cues or Alerts, or altering the Options for the application as a whole. Events could also come from the application itself in the form of notifications being sent to the users device regarding specific events that the user has set up to be notified about.

#### 1.2.2 User Interface Architecture

The IOS application interface, Xcode, serves as the view for this application. The user interface is developed completely in Swift. The individual screens and functionality of the UI can be described with the Action Sequence Flow pictured below. Each individual screen is depicted by a light green oval, initially the timeline will be displayed to the user. This is where the user will be able to see their Tasks, Alerts and Cues that they have set up to be displayed previously. From there, the user has the option to go to the Notification Settings screen. This screen will consist of tabs for Tasks, Alert and Cues that will drop down into specific settings such as time and frequency of notifications. From the Display Timeline screen, the user will also be able to add Tasks, Alerts and Cues, by pressing the add button, which will present a pop up allowing them to set the description and time of the tool they selected. The user will also be able to delete a tool by pressing the delete button, which will present a pop up listing the tools they already have set in place. Finally, from the Display Timeline screen, the user will be able to navigate to the Options screen by pressing the Options button, which will allow them to select the display type, toggle color blind mode, toggle dark mode and choose their time format.

### 1.3 Notification Service

The application will make use of the Apple Push Notification service for the notification purposes. As described in the 1.2.1, notifications would be sent to the user by the system based on the settings and preferences that the user has set for each of the Tasks, Alerts and Cues they have set.

### 1.4 Alternate Architecture Design

An alternative architecture design for our application would be using passing information between the User and the application through a server. We reject this design because for this app specifically, using a server would add unnecessary steps in our application’s processes, defeating the concept of minimalism that we are trying to provide the user and achieve within the development of our application. Using a server would also add unnecessary risks when it comes to data retrieval and updates. These risks mainly revolve around the possibility of the server crashing while the user is in the application, or depending on a notification. A server crash while the User is attempting to update the features in their app would cause frustration and render the application useless at that point in time. Additionally, a server crash while the application is meant to notify the user about a potentially important event could cause the users to miss deadlines or events, effectively making the user’s life more difficult and adding stress, which is the opposite of the goal for our application.

### 1.5 Design Risks

The design risks of our implementation of Event-Based architecture are few to none. One risk of this design would be if a user were to lose or damage the device that contains the application. We will combat this risk by potentially setting up a database/server that the user could choose to use if they wanted to back up their data. 

## Design Details

### 2.1 IOS Backend Design

#### 2.1.1 Class Descriptions
This class diagram only shows the core classes in our application and how they relate to each other. In section 2.2 we go over the upper level classes such as AppDelegate, ContentView, and UIapplication.  

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
