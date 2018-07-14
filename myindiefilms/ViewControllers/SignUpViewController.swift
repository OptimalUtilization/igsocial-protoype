//
//  SignUpViewController.swift
//  myindiefilms
//
//  Created by Vin on 12/2/17.
//  Copyright © 2017 Vin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class SignUpViewController: UIViewController {

    var inboxTableViewController: InboxTableViewController?
    
    private let MAIN_SEGUE = "MainTab";
    
    @IBOutlet weak var seguebutton: UIButton!
    @IBOutlet weak var signupbutton: UIButton!
    @IBOutlet weak var emailtextfield: UITextField!
    @IBOutlet weak var passwordtextfield: UITextField!
    @IBOutlet weak var usernametextfield: UITextField!
    @IBOutlet weak var profileimage: UIImageView!
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileimage.layer.cornerRadius = profileimage.frame.size.width/2
        profileimage.clipsToBounds = true
        
        emailtextfield.layer.borderWidth = 1
        emailtextfield.layer.borderColor = UIColor.white.cgColor
        emailtextfield.layer.cornerRadius = 20
        emailtextfield.clipsToBounds = true
        
        passwordtextfield.layer.borderWidth = 1
        passwordtextfield.layer.borderColor = UIColor.white.cgColor
        passwordtextfield.layer.cornerRadius = 20
        passwordtextfield.clipsToBounds = true
        
        usernametextfield.layer.borderWidth = 1
        usernametextfield.layer.borderColor = UIColor.white.cgColor
        usernametextfield.layer.cornerRadius = 20
        usernametextfield.clipsToBounds = true
        
        signupbutton.layer.cornerRadius = 20
        signupbutton.clipsToBounds = true
        
        seguebutton.layer.borderWidth = 1
        seguebutton.layer.borderColor = UIColor.white.cgColor
        seguebutton.layer.cornerRadius = 20
        seguebutton.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.handleimage))
        profileimage.addGestureRecognizer(tapGesture)
        profileimage.isUserInteractionEnabled = true
        
    
    }
    
    @objc func handleimage(){
        let pickercontroller = UIImagePickerController()
        pickercontroller.delegate = self
        present(pickercontroller, animated: true, completion: nil)
    }
    
    @IBAction func signuptapped(_ sender: Any) {
        
        
        //ERRor in line below
        if emailtextfield.text != "" && passwordtextfield.text != "" && usernametextfield.text != ""{
            
            AuthProvider.Instance.signUp(withEmail: emailtextfield.text!, username: usernametextfield.text!, password: passwordtextfield.text!, loginHandler: {(message) in
                
                if message != nil {
                    self.alertTheUser(title: "Problem with creating a new user", message: message!);
                
                    return
                }
                    
//               let uid = Database.database().reference().child("users").childByAutoId()
                
                guard let uid = Auth.auth().currentUser?.uid else{
                    return
                }
                let imagename = NSUUID().uuidString
                let storageRef = Storage.storage().reference(forURL: "gs://myindiefilms-3fc8b.appspot.com").child("profile_image").child("\(imagename).jpeg")
              
                
                if let inputdata =  UIImageJPEGRepresentation(self.profileimage.image!, 0.1) {
                  
                    storageRef.putData(inputdata, metadata: nil, completion: {( metadata, error) in
                        
                        
                    if error != nil {
                       
                        self.alertTheUser(title: "Upload Error", message: "There was an issue uploading the selected photo.")
                    
                            return
                        }
                        
                        if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                            let values = ["username": self.usernametextfield.text!, "email": self.emailtextfield.text!, "profileImageURL": profileImageURL, "Bio" : "Thank you for viewing my profile!"]
                            self.registeruserindatabase(uid: uid, values: values as [String : AnyObject])
                        }
                
                        
                    })
                  
                }
            })
    }
    }


    private func registeruserindatabase(uid: String, values: [String: AnyObject]){
    let ref = Database.database().reference()
    let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values) { (error, ref) in
        if error != nil{
            print(error!)
        return
        }
        
        self.inboxTableViewController?.fetchuserandsetupnavbar()
         self.performSegue(withIdentifier: self.MAIN_SEGUE, sender: nil);
        }
        }
        

    
    private func alertTheUser(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
        
    }
    
    
    
    @IBAction func dismissclick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

    extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
           if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = image
            profileimage.image = image
            
            }
            dismiss(animated: true, completion: nil)
            
        
    }
}

