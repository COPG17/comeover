//
//  GuestViewController.swift
//  comeover
//
//  Created by Zayne Melnick on 11/29/22.
//

import UIKit
import MessageInputBar
import Parse
class GuestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitations.count + 1
    }
    let commentBar = MessageInputBar()
    var event = PFObject(className: "Events")
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            showsCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
        }
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        let eventId = event.objectId
        let guest = PFObject(className: "Guests")
        guest["name"] = text
        guest["eventId"] = eventId! as String
        guest["author"] = PFUser.current()!
        
        guest.saveInBackground{(success,error) in
            if success {
                print("saved!")
                let eventHost = self.event as! PFObject
                let eventId = eventHost.objectId
                let query = PFQuery(className: "Guests")
                query.whereKey("eventId", equalTo: eventId)
                query.findObjectsInBackground {(invitations, error) in
                    if invitations != nil { self.invitations = invitations!
                        self.tableView.reloadData()
                  }
                }
            } else {
                print("error!")
            }
        }
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
 
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let guest = invitations[indexPath.row - 1]
            guest.deleteInBackground()
            self.invitations.remove(at: indexPath.row - 1)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row)
        if invitations.count != 0 && indexPath.row > 0{
        let cell = tableView.dequeueReusableCell(withIdentifier: "GuestCell") as! GuestCell
        let invitation = invitations[indexPath.row-1]
        cell.nameLabel.text = invitation["name"] as! String
        return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
        return cell
    }
    

    var invitations = [PFObject]()
    @IBOutlet weak var tableView: UITableView!
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    var showsCommentBar = false
    
    override var canBecomeFirstResponder: Bool {
        return showsCommentBar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        commentBar.inputTextView.placeholder = "Add a guest..."
        commentBar.sendButton.title = "Add"
        commentBar.delegate = self
        // Do any additional setup after loading the view.
        tableView.keyboardDismissMode = .interactive
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillBeHidden(note: Notification){
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        let eventHost = event as! PFObject
        let eventId = eventHost.objectId
        let query = PFQuery(className: "Guests")
        query.whereKey("eventId", equalTo: eventId)
        query.findObjectsInBackground {(posts, error) in
            if posts != nil { self.invitations = posts!
                self.tableView.reloadData()
          }
        }
    }
    
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    }
