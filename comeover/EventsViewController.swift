//
//  EventsViewController.swift
//  comeover
//
//  Created by Zayne Melnick on 11/11/22.
//

import UIKit
import Parse
import AlamofireImage

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var events = [PFObject]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
       
        let event = events[indexPath.row]
        cell.nameLabel.text = event["eventName"] as! String
        let date = event["eventDate"] as! Date
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        
        cell.dateLabel.text = formatter.string(from: date) as! String
        let imageFile = event["eventImage"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        cell.photoView.af.setImage(withURL: url)
        return cell
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className:"Events")
        query.whereKey("eventHost", equalTo: PFUser.current())
        
        query.findObjectsInBackground{(events, error) in
            if events != nil {
                self.events = events!
                self.tableView.reloadData()
            }
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EventDetailsSegue"{
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        //note: sender is the cell/event that was tapped on
        print("Loading Event Details Screen")
        //find selected event
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let event = events[indexPath.row]
        //pass the selected event to the details view controller
        let nav = segue.destination as! UINavigationController
        let svc = nav.topViewController as! EventDetailsViewController
        svc.event = event
        
        tableView.deselectRow(at: indexPath, animated: true)
        }
    }
   
    
    
    @IBAction func onLogoutButton(_ sender: Any) {
        
        PFUser.logOut()
            let main = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = main.instantiateViewController(identifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,  let delegate = windowScene.delegate as? SceneDelegate else { return }
            delegate.window?.rootViewController = loginViewController
    }
    

}
