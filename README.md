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

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='https://imgur.com/dXTEC4O.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

<img src='https://i.imgur.com/BPuBItE.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

![ezgif-3-d7592e5f9e](https://user-images.githubusercontent.com/66039575/203442218-32f73b73-0a7e-4a43-8b79-84be3fd97264.gif)

![ezgif-3-5e89ad5a28](https://user-images.githubusercontent.com/66039575/203442884-a016dd29-a447-44ce-a3e7-46ff6c62219a.gif)



## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- [x] User can create an account
- [x] User can login 
- [x] User can logout 
- [x] User remains logged in after closing the app 
- [x]  User can create events 
- [x]  User can view a list of their events 
- [x]  User can view a list of people they want to invite to the event
- [x]  User can view an event they created
- [x]  User can add people to an events invitation list

**Optional Nice-to-have Stories**

- [ ] User can create a gift wish list for an event
- [ ] User can create a food list for potlucks
- [ ] User can delete their account
- [ ] User can remove an event
- [ ] User can remove people from an events invitation list

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
  Signup
  ```
   let user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
        user.signUpInBackground {(success, error) in
           if success {
               self.performSegue(withIdentifier: "loginSegue", sender: nil)
           } else {
               print("Error: \(error?.localizedDescription ?? "Error")")
           }
        }
  ``` 
  Login
  ```
    let username = usernameField.text!
           let password = passwordField.text!

           PFUser.logInWithUsername(inBackground: username, password: password)
               { (user, error) in
               if user != nil {
                   self.performSegue(withIdentifier: "loginSegue", sender: nil)
               } else {
                   print("Error: \(error?.localizedDescription ?? "Error")")
               }
           }
  ``` 
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
    ```
      let query = PFQuery(className: "events")
      query.whereKey("eventID", equalTo: selectedEventID)
      query.findObjectsInBackgroundWithBlock {
      (objects: [AnyObject]?, error: NSError?) -> Void in
        for event in events {
            event.deleteEventually()
        }
      }
    ```
   * (Update/PUT) Update any existing events from logged in user
   ```
   var query = PFQuery(className:"events")
   query.getObjectInBackgroundWithId(selectedEventID) {
     (player: PFObject?, error: NSError?) -> Void in
     if error != nil {
       print(error)
     } else if let event = event {
       event["description"] = descriptionField.text!
       player.saveInBackground()
     }
   }
   ```
   Logout
  ```
   PFUser.logOut()
   
    let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let
                delegate = windowScene.delegate as? SceneDelegate else {return}
        
        delegate.window?.rootViewController = loginViewController
    }
  ``` 
* Create Event Screen
   * (Create/POST) Create a new event for logged in user
   ```
        let event = PFObject(className: "events")
        
        event["description"] = descriptionField.text!
        event["author"] = PFUser.current()!
        
        let imageData = imageView.image!.pngData()
        let file = PFFileObject(name: "image.png", data: imageData!)
        
        event["image"] = file
        
        event.saveInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("Saved!")
            } else {
                print("Error!")
            }
    ```     
* Individual Event Screen
   * (Update/PUT) Update description for event
   ```
   var query = PFQuery(className:"events")
   query.getObjectInBackgroundWithId(selectedEventID) {
     (player: PFObject?, error: NSError?) -> Void in
     if error != nil {
       print(error)
     } else if let event = event {
       event["description"] = descriptionField.text!
       player.saveInBackground()
     }
   }
   ```
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
