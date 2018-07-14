//
//  ViewController.swift
//  myindiefilms
//
//  Created by Vin on 12/1/17.
//  Copyright © 2017 Vin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {
    
    private let MAIN_SEGUE = "MainTab";
    
    @IBOutlet weak var signupsegue: UIButton!
    @IBOutlet weak var emailtextfield: UITextField!
    @IBOutlet weak var passwordtextfield: UITextField!
    @IBOutlet weak var loginbutton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       checkifuserisloggedin()
        
        emailtextfield.layer.borderWidth = 1
        emailtextfield.layer.borderColor = UIColor.white.cgColor
        emailtextfield.layer.cornerRadius = 20
        emailtextfield.clipsToBounds = true
       
        passwordtextfield.layer.borderWidth = 1
        passwordtextfield.layer.borderColor = UIColor.white.cgColor
        passwordtextfield.layer.cornerRadius = 20
        passwordtextfield.clipsToBounds = true
        
        loginbutton.layer.cornerRadius = 20
        loginbutton.clipsToBounds = true
        
        signupsegue.layer.borderWidth = 1
        signupsegue.layer.borderColor = UIColor.white.cgColor
        signupsegue.layer.cornerRadius = 20
        signupsegue.clipsToBounds = true
     
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
        self.performSegue(withIdentifier: self.MAIN_SEGUE, sender: nil)
    }
    }
    
    //major error can login with any user without credentials when click login
    
    func checkifuserisloggedin(){
        guard let uid = Auth.auth().currentUser?.uid else {
            handlelogout()
            return
        }
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    self.navigationItem.title = dictionary["username"] as? String
                }
            }, withCancel: nil)
        }
    
    
    func handlelogout() {
        if (Auth.auth().currentUser != nil) {
            do {
                try Auth.auth().signOut();
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let signinvc = storyboard.instantiateViewController(withIdentifier: "ViewController")
                self.present(signinvc, animated: true, completion: nil);
            } catch {
                alertTheUser(title: "error", message: "logout error")
            }
        }
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
    
    private func alertTheUser(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
        
    }
    
   
    
    
    
}
    
    
