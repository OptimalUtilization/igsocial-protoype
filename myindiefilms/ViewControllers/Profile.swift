//
//  Profile.swift
//  myindiefilms
//
//  Created by Vin on 12/1/17.
//  Copyright © 2017 Vin. All rights reserved.
//

import UIKit
import FirebaseAuth

class Profile: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
   
    
    @IBAction func logouttapped(_ sender: Any) {
    
        if AuthProvider.Instance.logOut() {
            dismiss(animated: true, completion: nil);
            
        } else {
            
            //problem with logout
            alertTheUser(title: "Could Not Logout", message: "Could not logout at the moment, please try again later.")
        }
    }
    private func alertTheUser(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
        
    }
    
    
    
    
    
    
    
    
    
    
    
}

