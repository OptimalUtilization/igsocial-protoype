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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        
        checkifuserisloggedin()
        
        ref = Database.database().reference()
        fetchUser()
        
        let image = UIImage(named: "message.png")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
    
        
    }
    
  
    
    func fetchUser(){
        let rootRef = Database.database().reference()
        let query = rootRef.child("users").queryOrdered(byChild: "username")
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    let user = User()
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
    
    func showChatController() {
        let layout = UICollectionViewFlowLayout()
        let ChatLogController = ChatController(collectionViewLayout: layout)
        
        
        navigationController?.pushViewController(ChatLogController, animated: true)
    }
    
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email

        
        if let profileIMG = user.profileImageURL {
            
            cell.profileimageview.loadImagesUsingCachewithURL(urlString: profileIMG)
            
//            let url = URL(string: profileIMG)
//            URLSession.shared.dataTask(with: url!,
//                                       completionHandler:
//                {(data, response, error) in
//
//                    //download hit error
//                    if error != nil {
//                        print(error!)
//                        return
//                    }
//
//                    DispatchQueue.main.async() {
//                        cell.profileimageview.image = UIImage(data: data!)
//
//                    }
//            }).resume()
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
//    var newmessage: InboxTableViewController?
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        dismiss(animated: true) {
//            self.newmessage?.showchatcontroller()
//        }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            
            
        self.showChatController()
            
        }
    }

}
    

    





    

class UserCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
         detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
        
    }
    
    let profileimageview: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileimageview)
        
        profileimageview.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileimageview.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileimageview.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileimageview.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

