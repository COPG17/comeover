Original App Design Project
===

# ComeOver

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
ComeOver is an event planning app for IOS devices. ComeOver allows users to view and create events they are planning. Additionally, ComeOver allows users to view and add people to an event's invitation list. 

When you want people to come over, use ComeOver!

### App Evaluation
- **Category:** Event Planning / Social Networking
- **Mobile:** App is primarily developed for mobile but may also be implemented to be a web based version.
- **Story:** Users will be able to use this app to help plan events. This includes creating an event and managing an event's invitation list.
- **Market:** This application can be used by any individual interested in planning events.
- **Habit:** This app can be used often according to how often someone would need to plan events.
- **Scope:** First, this app will start with allowing personal users to plan events, and then could evolve into an app that enables social networking (sending invations to other users, RSVP for events, etc.)

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can create an account
* User can login 
* User can logout 
* User remains logged in after closing the app 
* User can create events 
* User can view a list of their events 
* User can view a list of people they want to invite to the event
* User can view an event they created
* User can add people to an events invitation list

**Optional Nice-to-have Stories**

* User can create a gift wish list for an event
* User can create a food list for potlucks
* User can delete their account
* User can remove an event
* User can remove people from an events invitation list

### 2. Screen Archetypes

* Login Screen / Signup Screen
    * User can create an account
    * User can login 
    * User remains logged in after closing the app
    * User can logout
* My Events Screen
    * User can view a list of their events
    * User can logout
* Create Event Screen
    * User can create events
* Individual Event Screen
    * User can view an event they created 
    * User can view a list of people they want to invite to the event
* Invitation Screen
    * User can add people to an events invitation list 
   

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* My events - displays events that you created
* Add Event - screen that allows you to create a new event

**Flow Navigation** (Screen to Screen)

* Forced Login -> Account creation if no login is available
* My Events -> clicking event navigates to individual event screen for that event
* My Events -> Navigates to Create Event Screen 
* Create Event Screen -> select photo for event, input name for event, choose date for event, input description of event, navigate back to my events when "create event" button is pressed (or navigate back if back button is pressed)
* Individual Event Screen -> Jump to Invitation Screen when "+" button is pressed 
* Invitation Screen -> type in name of person you want to invite, press "invite" button. Add more people or click back arrow to go back to individual event screen
* My Events -> Jump to login screen (when "logout" button is pressed) 

## Wireframes
<img src="https://i.imgur.com/wMvwAuh.png" width=600>

## Schema 
### Models
| Property | Type | Description |
| --- | --- | --- |
| eventId | String | Id for user event post |
| author | Pointer to user | Author of event post |
| image | File | Image that user posts tied to the event |
| eventDescription | String | Caption detailing information for the event post |
| eventInvitee | Object | Name of person invited to event and the Id of the event |
### Networking
* Login Screen / Signup Screen
   * 
* My Events Screen
   * (Read/GET) Query all events posted by user
   ```
   let query = PFQuery(className: "events")
       query.includeKeys(["author", "eventDescription"])
       query.findObjectsInBackground{(Events, error) in
            if events != nil {
               print("Successfully retrieved \(events.count) posts.")
            } else if let error = error {
              print(error.localizedDescription)
   }
   ```
   * (Delete) Delete existing event
   * (Update/PUT) Update any existing events from logged in user
* Create Event Screen
   * (Create/POST) Create a new event for logged in user
* Individual Event Screen
   * (Update/PUT) Update description for event
   * (Create/POST) Add person to an events invitation list
   ```
        let invitation = PFObject(className: "Invitations")
        invitations["text"] = text
        invitations["post"] = selectedEvent
        invitations["author"] = PFUser.current()!
        selectedEvent.add(invitation, forKey: "invitations")

        selectedEvent.saveInBackground{(success, error) in
            if success {
                print("Invite Saved")
            }
            else{
                print("Error saving invite")
            }
        }
        
   ```
* Invitation Screen
   * (Read/GET) Query of an events invitation
   ```
   let query = PFQuery(className: "invitations")
       query.includeKeys(["author", "eventInvitee"])
       query.findObjectsInBackground{(Invitations, error) in
            if invitations != nil {
               print("Successfully retrieved \(invitations.count) invitations.")
            } else if let error = error {
              print(error.localizedDescription)
   }
   ```
