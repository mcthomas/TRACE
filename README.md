# TRACE

<img src="trace.png" width="600"/>

### Contents

  - [Problem Description](#Problem-Description "Problem Description")
  - [The Customer](#The-Customer "The Customer")
  - [System Description](#System-Description "System Description")
  - [Testing and Demoing](#Testing-and-Demoing "Testing and Demoing")
  - [Feasibility](#Feasibility "Feasibility")
  - [Concept Images](#Concept-Images "Concept Images")

## Problem Description: 
During a time when our workflow is entirely digital, self-organization is a necessity to best manage our time and to maintain our sanity. Most of us favor our mobile devices for scheduling events, reminders, and alarms. We’ve adapted with heavy use of respective native iOS and Android apps, as well as with third-party replacements. I would like to improve on this model with respect to (1) decreasing time spent hopping between these apps and (2) visually minimizing our mental view of our workflow. Swiping between pages of apps, with multiple accounts, between multiple storage mediums is not ideal. Rummaging through their notifications is not ideal. Opening your calendar and seeing all your personal and scholarly events stacked together is not ideal. In fact, it’s overwhelming, and many of these functions are managed by third-parties. Self-managing the personal events, alerts, and alarms that matter most to you, in one place, is ideal. Being able to trace your days, one step at a time, as one would read a line of text would be ideal. Aggregating time-management tools into a single app is not unheard of, but doing so gracefully and with a single- dimensional nuance would be novel.

## The Customer: 
Friends and other students struggling to mono-task and focus, i.e. my roommates. With their own needs in mind, they can supply a consistent flow of suggestions for refinement and improvement of the system.

## System Description: 
The system will aim to aggregate three personal time- management tools, presented with a single-dimensional user interface. Trace would phrase alarms as alerts, reminders as cues, and calendar events as tasks. Intended to help the user focus on their present objectives, minimalism is a must. Instances of these three items can be expanded for access to their three fields, but otherwise the user scales and scrolls along a linear time line. Trace eliminates the need for three separate apps for the majority of a user’s needs. The primary attraction of Trace is the user interface, geared towards those seeking an increased focus on productivity.

## Testing and Demoing: 
The system would be tested frequently amongst a consistent group of users most interested in its concept. At this point, these users would consist of my roommates and another friend. Apart from the testing group, others could be recruited for more diverse feedback. In this case, the target users are not differentiated from the “customers.” Demoing the system at all stages demands a development flow that begins with the UI and scrolling, such that the that the visual is a consistent component available for critique. Then the tools would be incrementally introduced, one at a time, at varying levels of functionality. Stage one could be insertions, (of blank alerts, cues, and tasks) followed by implementing component input fields, and finally I/O functions such as outputting sounds, settings, etc.

## Feasibility: 
Luckily, the concept of Trace primarily consists of back-end functionality, as the UI would be maximally minimal, and there aren’t any original graphics or assets required of it. Furthermore, development in Xcode with Swift won’t present any extraneous challenges beyond the inclusion of optional libraries to ease the development timeline. More than half the team could focus on the breakdown of algorithms and APIs for implementing the three primary tools for Trace, while the rest could be tasked with implementing and refining the application’s I/O and quality control for the user. Prototypes can be continuously deployed from Xcode on a designated iOS device for the purpose of demoing. Users’ own devices can also host the prototypes for multi-day trial feedback.

## Concept Images:
⃞♢ = c u e s ⊠ = alerts
Colors indicate tasks

