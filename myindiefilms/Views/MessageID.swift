//
//  MessageID.swift
//  myindiefilms
//
//  Created by Vin on 12/29/17.
//  Copyright © 2017 Vin. All rights reserved.
//

import UIKit
import Firebase

class MessageID: UITableViewCell {

    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
//        fetchUser()
    }
    
    
//    func fetchUser(){
//        let rootRef = Database.database().reference()
//        let query = rootRef.child("users").queryOrdered(byChild: "username")
//        query.observe(.value) { (snapshot) in
//            for child in snapshot.children.allObjects as! [DataSnapshot] {
//                if let value = child.value as? NSDictionary {
//                    let user = User()
//                    let name = value["username"] as? String ?? "Name not found"
//                    let email = value["email"] as? String ?? "Email not found"
//                    user.name = name
//                    user.email = email
//                    self.users.append(user)
//                    DispatchQueue.main.async {self.tableView.reloadData() }
//                }
//            }
//        }
//    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
