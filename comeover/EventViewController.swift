//
//  EventViewController.swift
//  comeover
//
//  Created by Vincent Joel Morales on 11/21/22.
//

import UIKit
import AlamofireImage
import Parse

class EventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var UIImageView: UIImageView!
    
    @IBOutlet weak var eventNameField: UITextField!
    
    @IBOutlet weak var datePickerWheel: UIDatePicker!
    
    @IBOutlet weak var eventDescriptionField: UITextView!
    
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
  
    
    @IBAction func onCreateButton(_ sender: Any) {
        let event = PFObject(className: "Events")
        
        event["eventName"] = eventNameField.text!
        event["eventHost"] = PFUser.current()!
        event["eventDate"] = datePickerWheel.date
        event["eventDescription"] = eventDescriptionField.text!
        
        let imageData = UIImageView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        
        event["eventImage"] = file
        
        
        event.saveInBackground{(success,error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("saved!")
            } else {
                print("error!")
            }
        }
        
        
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af.imageScaled(to: size)
        
        UIImageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Looks for single or multiple taps.
             let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

            //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
            //tap.cancelsTouchesInView = false

            view.addGestureRecognizer(tap)
        eventDescriptionField.becomeFirstResponder()
        
      
        
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
