//
//  ViewController.swift
//  myindiefilms
//
//  Created by Vin on 12/1/17.
//  Copyright © 2017 Vin. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ViewController: UIViewController {
    
    private let MAIN_SEGUE = "MainTab";
    
    @IBOutlet weak var emailtextfield: UITextField!
    @IBOutlet weak var passwordtextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
 
    @IBAction func signuptapped(_ sender: Any) {
        
        if emailtextfield.text != "" && passwordtextfield.text != "" {
            
            AuthProvider.Instance.signUp(withEmail: emailtextfield.text!, password: passwordtextfield.text!, loginHandler: {(message) in
                
                if message != nil {
                    self.alertTheUser(title: "Problem with creating a new user", message: message!);
                } else {
                    self.performSegue(withIdentifier: self.MAIN_SEGUE, sender: nil);
                }
                
            });
            
        } else {
            alertTheUser(title: "Email and password are required.", message: "Please enter an email and password in the text fields.");
        }
    }
    private func alertTheUser(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
        
    }
    
    
    
    
 
    @IBAction func logintapped(_ sender: Any) {
        if emailtextfield.text != "" && passwordtextfield.text != "" {
            
            AuthProvider.Instance.login(withEmail: emailtextfield.text!, password: passwordtextfield.text!, LoginHandler: { (message) in
                if message != nil {
                    self.alertTheUser(title: "Problem With Authentication", message: message!);
                }else{
                   self.performSegue(withIdentifier: self.MAIN_SEGUE, sender: nil);
                }
            });
            
        }else {
            alertTheUser(title: "Email and password are required.", message: "Please enter an email and password in the text fields.");
        }
    }
}
