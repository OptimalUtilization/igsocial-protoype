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
        
        
        checkifuserisloggedin()
        
        fetchUser()
        
        
        let image = UIImage(named: "freecompose.png")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
    
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        

        tableView.allowsMultipleSelectionDuringEditing = true
        
        setupFormat()
    }
    
    func setupFormat(){
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "astro.jpg"))
        imageView.contentMode = .scaleAspectFill
        self.tableView.backgroundView = imageView
        self.tableView.layer.borderWidth = 1
        self.tableView.layer.cornerRadius = 4
        self.tableView.clipsToBounds = true
        blurView.frame = imageView.bounds
        imageView.addSubview(blurView)
    }
    
    
    


    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
      let message = self.messages[indexPath.row]
            
        if let chatPartneriD = message.chatPartnerID(){
            Database.database().reference().child("user-messages").child(uid).child(chatPartneriD).removeValue(completionBlock: { (error, ref) in
                if error != nil {
                    print("Failed to delete message:", error!)
                    return
                }
                
                self.messagesDictionary.removeValue(forKey: chatPartneriD)
                self.attemptReloadOfTable()
            })
        }
    }
    
    
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let userID = snapshot.key
            Database.database().reference().child("user-messages").child(uid).child(userID).observe(.childAdded, with: { (snapshot) in
//                print(snapshot)
                let messageID = snapshot.key
               self.fetchMessageWithMessageID(messageID: messageID)
                
            }, withCancel: nil)
            
            
        }, withCancel: nil)
        
        ref.observe(.childRemoved, with: { (snapshot) in
            self.messagesDictionary.removeValue(forKey: snapshot.key)
            self.attemptReloadOfTable()
        }, withCancel: nil)
    }
    
    
    
    
    
    private func fetchMessageWithMessageID(messageID: String){
        let messagesReference = Database.database().reference().child("messages").child(messageID)
        messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
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
                //                    if let toID = messages.toID {
                guard let chatPartnerID = messages.fromID == Auth.auth().currentUser?.uid ? messages.toID : messages.fromID else{ return }
                self.messagesDictionary[chatPartnerID] = messages
                //                        self.messagesDictionary[toID] = messages
                
                //                    }
                self.attemptReloadOfTable()
                
            }
            
        }, withCancel: nil)

    }
    
    private func attemptReloadOfTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    var timer: Timer?
    
    @objc func handleReloadTable() {
        self.messages = Array(self.messagesDictionary.values)
        self.messages.sort(by:{(messages1, messages2) -> Bool in
            return (messages1.timestamp?.intValue)!>(messages2.timestamp?.intValue)!
        })
          DispatchQueue.main.async {self.tableView.reloadData() }
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
        cell.backgroundColor = UIColor(white: 1, alpha: 0.3)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        guard let chatPartnerID = message.chatPartnerID() else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(chatPartnerID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            print(snapshot)
            
            guard let value = snapshot.value as? [String: AnyObject]
                else{
                    return
            }
            
            let user = User()
            user.toID = chatPartnerID
            let name = value["username"] as? String ?? "Name not found"
            let email = value["email"] as? String ?? "Email not found"
            let profileIMG = value["profileImageURL"] as? String ?? "Not found"
            user.profileImageURL = profileIMG
            user.name = name
            user.email = email
            self.showChatControlleruser(user: user)

            
        }, withCancel: nil)

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
           fetchuserandsetupnavbar()
        }
    }
    
    
    
    
    
    
    func fetchuserandsetupnavbar() {
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
//                self.navigationItem.title = value["username"] as? String
                
                let user = User()
               let name = value["username"] as? String ?? "Name not found"
                user.name = name
                self.setupnavbarwithuser(user: user)
            }
        }, withCancel: nil)
    }
    
    
    
    
    
    func setupnavbarwithuser(user: User){
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        self.navigationItem.title = user.name
        observeUserMessages()
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
    
  

}
    

