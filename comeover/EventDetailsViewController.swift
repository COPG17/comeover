//
//  EventDetailsViewController.swift
//  comeover
//
//  Created by Anastasija Bulatovic on 11/22/22.
//

import UIKit
import Parse
import AlamofireImage
import Alamofire

class EventDetailsViewController: UIViewController {
    
    var event = PFObject(className: "Events")
   // var event: [String:Any]!
   // var events = [PFObject]()
    
    @IBOutlet weak var eventImageDetail: UIImageView!
    
    @IBOutlet weak var eventNameLabelDetail: UILabel!
    
    @IBOutlet weak var eventDescriptionLabelDetail: UILabel!
    
    @IBOutlet weak var eventTimeLableDetail: UILabel!
    
    
    
    
    
    
    
   
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GuestListSegue"{
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        //note: sender is the cell/event that was tapped on
        print(event)
        print("Loading Event Guest List Screen")
        //pass the selected event to the details view controller
        let nav = segue.destination as! UINavigationController
        let svc = nav.topViewController as! GuestViewController
        svc.event = event
        
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     // DETAIL VIEW CODE!
    //print(event["eventName"])
       //POPULATING THE TEXT FIELDS
        eventNameLabelDetail.text = event["eventName"] as! String
        eventDescriptionLabelDetail.text = event["eventDescription"] as! String
       
        
        //populating the time feild
        let date = event["eventDate"] as! Date
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        
        
        eventTimeLableDetail.text = formatter.string(from: date) as! String
        
        //POPULATING THE IMAGE
        let imageFile = event["eventImage"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        eventImageDetail.af.setImage(withURL: url)
        // Do any additional setup after loading the view.
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
