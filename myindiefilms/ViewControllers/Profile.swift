//
//  Profile.swift
//  myindiefilms
//
//  Created by Vin on 12/1/17.
//  Copyright © 2017 Vin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class Profile: UITableViewController, commentButtonProtocol {

    

    


    let proID = "proID"
    let postIDDD = "postIDDD"
    var ref: DatabaseReference!
    var posts = [Post]()
    var user = [User]()
    var postsDictionary = [String: Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
     
        
        tableView.register(ProHeaderClassTableViewCell.self, forCellReuseIdentifier: proID)
        tableView.register(PostCell.self, forCellReuseIdentifier: postIDDD)

        
        fetchuserandsetupnavbar()
        fetchUser()
        headerViewInfo()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector((editProfile)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Favorites", style: .plain, target: self, action: #selector((showFavorites)))
        
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
    
    

        func commentButtonPressed(post: Post) {
            let layout = UICollectionViewFlowLayout()
            let CommentController = CommentsController(collectionViewLayout: layout)
            CommentController.post = post
            
            navigationController?.pushViewController(CommentController, animated: true)
        }
    
    
//    var timer: Timer?
//
//   func attemptReloadOfTable() {
//        self.timer?.invalidate()
//        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
//    }
//
//    @objc func handleReloadTable() {
//
//        DispatchQueue.main.async {self.tableView.reloadData() }
//
//    }
    
    @objc func showFavorites(){
        let favoritesList = Favorites()
//        let navController = UINavigationController(rootViewController: favoritesList)
        navigationController?.pushViewController(favoritesList, animated: true)
    }
    
    @objc func editProfile() {
//        let profileEdit = EditProfile()
//        profileEdit.profileView = self
//        let navController = UINavigationController(rootViewController: profileEdit)
//        present(navController, animated: true, completion: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signinvc = storyboard.instantiateViewController(withIdentifier: "EditProfile")
        navigationController?.pushViewController(signinvc, animated: true)
    }
    
    let profileimageview: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "astro.jpg")
        return imageView
    }()
        
        let bioTextView: UITextView = {
            let bio = UITextView()
            bio.font = UIFont.italicSystemFont(ofSize: 12)
            bio.isSelectable = false
            bio.translatesAutoresizingMaskIntoConstraints = false
            bio.text = ""
            //            bio.backgroundColor = .yellow
            bio.backgroundColor = UIColor.clear
            bio.textColor = UIColor.white
            bio.textAlignment = .center
            return bio
        }()
        
        let username: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16)
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.text = "HELLO"
            label.textColor = UIColor.black
            label.translatesAutoresizingMaskIntoConstraints = false
            //            label.backgroundColor = UIColor.red
            return label
        }()

    
    func headerViewInfo() {
        
//        let headerview = UIView()
//        headerview.backgroundColor = UIColor.lightGray
//        headerview.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 150)
//        tableView.tableHeaderView = headerview
        
//        let profileimageview: UIImageView = {
//            let imageView = UIImageView()
//            imageView.frame = CGRect(x: self.view.frame.height/2, y: self.view.frame.width/2, width: 70, height: 70)
//            imageView.layer.cornerRadius = imageView.frame.size.width / 2
//            imageView.clipsToBounds = true
//            imageView.layer.borderWidth = 1.0
//            imageView.layer.borderColor = UIColor.white.cgColor
//            imageView.translatesAutoresizingMaskIntoConstraints = false
//            imageView.contentMode = .scaleAspectFill
//            imageView.image = UIImage(named: "astro.jpg")
//            return imageView
//        }()
        
        let headerview = UIView()
        headerview.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        headerview.frame = CGRect(x: self.view.frame.height/2, y: self.view.frame.width/2, width: view.frame.width, height: 175)
        tableView.tableHeaderView = headerview
        
        
        headerview.addSubview(profileimageview)
        headerview.addSubview(username)
        headerview.addSubview(bioTextView)

        
        profileimageview.heightAnchor.constraint(equalToConstant: 70).isActive = true
        profileimageview.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileimageview.topAnchor.constraint(equalTo: headerview.topAnchor, constant: 5).isActive = true
        profileimageview.centerXAnchor.constraint(equalTo: headerview.centerXAnchor).isActive = true
        

        username.centerXAnchor.constraint(equalTo: headerview.centerXAnchor).isActive = true
        username.topAnchor.constraint(equalTo: profileimageview.bottomAnchor, constant: 5).isActive = true
//
        bioTextView.centerXAnchor.constraint(equalTo: headerview.centerXAnchor).isActive = true
        bioTextView.bottomAnchor.constraint(equalTo: headerview.bottomAnchor).isActive = true
        bioTextView.topAnchor.constraint(equalTo: username.bottomAnchor).isActive = true
        bioTextView.leftAnchor.constraint(equalTo: headerview.leftAnchor).isActive = true
        bioTextView.rightAnchor.constraint(equalTo: headerview.rightAnchor).isActive = true


        
      
    }
    
    
    
    func fetchuserandsetupnavbar() {
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                let user = User()
                let name = value["username"] as? String ?? "Name not found"
                user.name = name
                self.username.text = name
                self.bioTextView.text = value["Bio"] as? String ?? ""
                if let profileImageURL = value["profileImageURL"] as? String {
                    self.profileimageview.loadImagesUsingCachewithURL(urlString: profileImageURL)}
                self.setupnavbarwithuser(user: user)
            }
        }, withCancel: nil)
    }
    
    
    
    
    
    func setupnavbarwithuser(user: User){
//        posts.removeAll()
//        postsDictionary.removeAll()
        self.navigationItem.title = user.name
        
        tableView.reloadData()
        updatePost()
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
                    self.user.append(user)
                    DispatchQueue.main.async {self.tableView.reloadData() }
                }
            }
        }
    }
    
    func updatePost(){
        guard let uid = Auth.auth().currentUser?.uid else {

            return
        }

        let postRef = Database.database().reference().child("user-posts").child(uid)
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
//                        print(snapshot)
            
            let userID = snapshot.key

            Database.database().reference().child("user-posts").child(userID).observe(.childAdded, with: { (snapshot) in
//                print(snapshot)
                
//                for child in snapshot.children.allObjects as! [DataSnapshot] {

                    let posttID = snapshot.key
//                    print(posttID)
                    self.fetchPostWithPostID(postID: posttID)

//                }
            }, withCancel: nil)

        }, withCancel: nil)
        //        ref.observe(.childRemoved, with: { (snapshot) in
        //            self.postsDictionary.removeValue(forKey: snapshot.key)
        //            self.attemptReloadOfTable()
        //        }, withCancel: nil)
    }

    //    private func fetchPostWithPostID(postID: String){
    //        guard let uid = Auth.auth().currentUser?.uid else {
    //
    //            return
    //        }
    //        let ref = Database.database().reference().child("user-posts").child(uid).child(postID)
    //        ref.observe(.childAdded, with: { (snapshot) in
    //            print(snapshot)
    //            let posts = Post()
    //
    //            self.posts.append(posts)
    //            DispatchQueue.main.async {self.tableView.reloadData() }
    //
    //
    //        }, withCancel: nil)
    //
    //    }

    private func fetchPostWithPostID(postID: String){
        let ref = Database.database().reference().child("posts").child(postID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
             if let value = snapshot.value as? NSDictionary {
//            print(snapshot)
            let posts = Post()
  
            let postID = value["postID"] as? String ?? "Not found"
            let fromID = value["fromID"] as? String ?? "Name not found"
            let caption = value["caption"] as? String ?? "Not found"
            let URLinput = value["URLinput"] as? String ?? "Link not found"
            let timestamp = value["timestamp"] as? NSNumber ?? 000000
            let likes = value["likes"] as? Int ?? 0
            let dislikes = value["dislikes"] as? Int ?? 0
            let commentFromID = value["commentFromID"] as? String ?? "not found"
            let commentTimeStamp = value["commentTimeStamp"] as? NSNumber ?? 000000
            let commentText = value["commentText"] as? String ?? "Be the first to comment!"
            let commentCount = value["commentCount"] as? Int ?? 0
            posts.commentCount = commentCount
            posts.commentFromID = commentFromID
            posts.commentTimeStamp = commentTimeStamp
            posts.commentText = commentText
            posts.postID = postID
            posts.URLinput = URLinput
            posts.fromID = fromID
            posts.caption = caption
            posts.timestamp = timestamp
            posts.likes = likes
            posts.dislikes = dislikes
            self.posts.append(posts)
            DispatchQueue.main.async {self.tableView.reloadData() }

            }
        }, withCancel: nil)

    }
    

    
    


//    private func attemptReloadOfTable() {
//        self.timer?.invalidate()
//        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
//    }
//
//    var timer: Timer?
//
//    @objc func handleReloadTable() {
//        self.posts = Array(self.postsDictionary.values)
//        self.posts.sort(by:{(posts1, posts2) -> Bool in
//            return (posts1.timestamp?.intValue)!>(posts2.timestamp?.intValue)!
//        })
//        DispatchQueue.main.async {self.tableView.reloadData() }
//    }
   
    
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
    
    func configureTableView() {
        // remove separators for empty cells
        tableView.tableFooterView = UIView()
        // remove separators from cells
        tableView.separatorStyle = .none
        
      
    }
    
  


    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postIDDD", for: indexPath) as! PostCell
        let posted = posts[indexPath.row]
        cell.posts = posted
        cell.backgroundColor = UIColor(white: 1, alpha: 0.3)
        cell.delegate = self

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
   
    
}

