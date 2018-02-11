//
//  InboxTableViewController.swift
//  myindiefilms
//
//  Created by Vin on 12/29/17.
//  Copyright © 2017 Vin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class InboxTableViewController: UITableViewController {
    
   
    let cellID = "cellID"
    var ref: DatabaseReference!
    var refHandle: UInt!
    var users = [User]()
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        
        checkifuserisloggedin()
        
        ref = Database.database().reference()
        
        fetchUser()
        
        let image = UIImage(named: "message.png")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
    
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        
//        observeMessages()
        
        observeUserMessages()
    }

    
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let messageID = snapshot.key
            let messagesReference = Database.database().reference().child("messages").child(messageID)
            messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                if let value = snapshot.value as? NSDictionary {
                    let messages = Message()
                    let fromID = value["fromID"] as? String ?? "not found"
                    let text = value["text"] as? String ?? "not found"
                    let toID = value["toID"] as? String ?? "not found"
                    let timestamp = value["timestamp"] as? NSNumber ?? 000000
                    //                    let fromID = value["fromID"] as? String ?? "from id not found"
                    messages.toID = toID
                    messages.text = text
                    messages.timestamp = timestamp
                    messages.fromID = fromID
                    //                    self.messages.append(messages)
                    if let toID = messages.toID {
                        self.messagesDictionary[toID] = messages
                        self.messages = Array(self.messagesDictionary.values)
                        self.messages.sort(by:{(messages1, messages2) -> Bool in
                            return (messages1.timestamp?.intValue)!>(messages2.timestamp?.intValue)!
                        })
                    }
                    DispatchQueue.main.async {self.tableView.reloadData() }
                }
             
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    // may need to remove query and instantly define .child(messages) in root ref TBD
    
//    func observeMessages () {
//        let rootRef = Database.database().reference()
//        let query = rootRef.child("messages").queryOrdered(byChild: "toID")
//        query.observe(.childAdded, with: { (snapshot) in
////            for child in snapshot.children.allObjects as! [DataSnapshot] {
//                if let value = snapshot.value as? NSDictionary {
//                    let messages = Message()
//                    let fromID = value["fromID"] as? String ?? "not found"
//                    let text = value["text"] as? String ?? "not found"
//                    let toID = value["toID"] as? String ?? "not found"
//                    let timestamp = value["timestamp"] as? NSNumber ?? 000000
////                    let fromID = value["fromID"] as? String ?? "from id not found"
//                    messages.toID = toID
//                    messages.text = text
//                    messages.timestamp = timestamp
//                    messages.fromID = fromID
////                    self.messages.append(messages)
//            if let toID = messages.toID {
//                self.messagesDictionary[toID] = messages
//                self.messages = Array(self.messagesDictionary.values)
//                self.messages.sort(by:{(messages1, messages2) -> Bool in
//                    return (messages1.timestamp?.intValue)!>(messages2.timestamp?.intValue)!
//                })
//            }
//                    DispatchQueue.main.async {self.tableView.reloadData() }
//                }
//                print(snapshot)
////            }
//        }, withCancel: nil)
//    }

    




    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell
        
        let message = messages[indexPath.row]
        cell.message = message
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
   
    func fetchUser(){
        let rootRef = Database.database().reference()
        let query = rootRef.child("users").queryOrdered(byChild: "username")
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    let user = User()
                    user.toID = child.key
                    let name = value["username"] as? String ?? "Name not found"
                    let email = value["email"] as? String ?? "Email not found"
                    let profileIMG = value["profileImageURL"] as? String ?? "Not found"
                    user.profileImageURL = profileIMG
                    user.name = name
                    user.email = email
                    self.users.append(user)
                    DispatchQueue.main.async {self.tableView.reloadData() }
                }
            }
        }
    }

    
    func checkifuserisloggedin(){
        if Auth.auth().currentUser?.uid == nil{
            handlelogout()
        }else{
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    self.navigationItem.title = dictionary["username"] as? String
                }
            }, withCancel: nil)
        }
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
    
    func alertTheUser(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }
    
    
    
   @objc func handleNewMessage() {
        
        
        let newmessagecontroller = NewMessageTableViewController()
        newmessagecontroller.inboxcontroller = self
        let navController = UINavigationController(rootViewController: newmessagecontroller)
        present(navController, animated: true, completion: nil)
        
    }
    
    func showChatControlleruser(user: User) {
        let layout = UICollectionViewFlowLayout()
        let ChatLogController = ChatController(collectionViewLayout: layout)
        ChatLogController.user = user
        
        navigationController?.pushViewController(ChatLogController, animated: true)
    }
    
  
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return users.count
//    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell
//
//        let user = users[indexPath.row]
//        cell.textLabel?.text = user.name
//        cell.detailTextLabel?.text = user.email
//
//
//        if let profileIMG = user.profileImageURL {
//
//            cell.profileimageview.loadImagesUsingCachewithURL(urlString: profileIMG)
//
////            let url = URL(string: profileIMG)
////            URLSession.shared.dataTask(with: url!,
////                                       completionHandler:
////                {(data, response, error) in
////
////                    //download hit error
////                    if error != nil {
////                        print(error!)
////                        return
////                    }
////
////                    DispatchQueue.main.async() {
////                        cell.profileimageview.image = UIImage(data: data!)
////
////                    }
////            }).resume()
//        }
//        return cell
    
        
        
        
        
//
//    }
//
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 72
//    }
//

    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        dismiss(animated: true) {
//
//
////    not used    self.showChatControlleruser()
//
//        }
//    }

}
    

