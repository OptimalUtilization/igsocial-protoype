//
//  NewMessageTableViewController.swift
//  myindiefilms
//
//  Created by Vin on 12/29/17.
//  Copyright © 2017 Vin. All rights reserved.
//

import UIKit
import Firebase

class NewMessageTableViewController: UITableViewController {
    

    
    let cellidd = "cellidd"
    var ref: DatabaseReference!
    var rootRef: UInt!
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellidd)

        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Messages", style: .plain, target: self, action: #selector(showchatcontroller))
       navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        ref = Database.database().reference()
        fetchUser()
        
        self.setupnavbar()
    
    }
    
    
    func setupnavbar() {
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
      
        
        let containerView = UIView()
//        containerView.backgroundColor = UIColor.red
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleView.addSubview(containerView)
        
       
        
        let namelabel = UILabel()
        containerView.addSubview(namelabel)
//        namelabel.text = "Messages"
        namelabel.translatesAutoresizingMaskIntoConstraints = false
        namelabel.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        namelabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        namelabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        namelabel.widthAnchor.constraint(equalToConstant: 90).isActive = true
        namelabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
     
        
        self.navigationItem.titleView = titleView

        namelabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showchatcontroller)))
        

        
    }
    

    @objc func showchatcontroller(user: User) {
            
//            let newmessagecontroller = NewMessageTableViewController()
//            newmessagecontroller.newmessage = self
            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let ChatLogController = storyboard.instantiateViewController(withIdentifier: "ChatController")
//            self.present(ChatLogController, animated: true, completion: nil)
        
        
            let layout = UICollectionViewFlowLayout()
            let ChatLogController = ChatController(collectionViewLayout: layout)

        
            navigationController?.pushViewController(ChatLogController, animated: true)

    
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
    


    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellidd, for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        
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
//                    }
//            }).resume()
        }
        return cell
        
    
        
    }
    
   
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    var inboxcontroller: InboxTableViewController? = nil
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            
            self.inboxcontroller?.showChatController()
            

        

        }
        
        
        
    }
    
}


