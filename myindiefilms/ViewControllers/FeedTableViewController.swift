//
//  FeedTableViewController.swift
//  
//
//  Created by Vin on 12/12/17.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class FeedTableViewController: UITableViewController, commentButtonProtocol, viewProfileProtocol  {

    
    
    let PosterCell = "PosterCell"
//    var ref: DatabaseReference!
//    var rootRef: UInt!
    var posts = [Post]()
    var user = [User]()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
//        checkifuserisloggedin()
        
        tableView.register(PostCell.self, forCellReuseIdentifier: PosterCell)
        
        navigationItem.title = "IndieHub"
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        fetchPost()
        fetchUser()
        
        setupFormat()
//        setupSearch()
 
//        fetchuserandsetupnav()
        
     

        
    }
    
    func setupSearch(){
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
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
    
    
//   func fetchuserandsetupnav(){
//    if Auth.auth().currentUser?.uid == nil else {
//
//    handlelogout()
//
//    return
//    }
//    }
    
    
//    func showChatControlleruser() {
//        let layout = UICollectionViewFlowLayout()
//        let CommentController = CommentsController(collectionViewLayout: layout)
////        ChatLogController.user = user
//        
//     self.present(CommentController, animated: true, completion: nil)
//    }
    
    

    
    
//    func commentButtonPressed() {
//        let comment = CommentsController()
//        self.present(comment, animated: true, completion: nil)
//    }
//
    
    func fetchPost(){
    
        let rootRef = Database.database().reference().child("posts")
        rootRef.queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    let posts = Post()
                    let postID = value["postID"] as? String ?? "Not found"
                    let fromID = value["fromID"] as? String ?? "Name not found"
                    let caption = value["caption"] as? String ?? ""
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
            }
          
        }, withCancel: nil)
      
    }
    
    
        func commentButtonPressed(post: Post) {
            let layout = UICollectionViewFlowLayout()
            let CommentController = CommentsController(collectionViewLayout: layout)
            CommentController.post = post
            
            navigationController?.pushViewController(CommentController, animated: true)
        }
    
    
        func userPressed(post: Post) {
            let selected = SelectedUser()
            selected.post = post
            navigationController?.pushViewController(selected, animated: true)
        }
  
    
//    func updatePost(fromID: String){
////        if let fromID = posts.fromID {
//            let ref = Database.database().reference().child("users").child(fromID)
//            ref.observeSingleEvent(of: .value, with: { (snapshot) in
//                if let dictionary = snapshot.value as? [String: AnyObject]{
//                    //                    print(snapshot)
//                    posts.PostCell.nameLabel.text = dictionary["username"] as? String
//                    if let profileImageURL = dictionary["profileImageURL"] as? String {
//                       PosterCell.profileimageview.loadImagesUsingCachewithURL(urlString: profileImageURL)
//                    }
//                }
//            }, withCancel: nil)
////        }
//
//    }
//
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
    
    
//    func checkifuserisloggedin(){
//        if Auth.auth().currentUser?.uid == nil{
//            handlelogout()
//        }else{
//            fetchPost()
//        }
//    }
    

    
    
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
    
   
   
    @IBAction func logouttapped(_ sender: Any) {
        handlelogout()
    }
    
    

 
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
      return posts.count
    }


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "PosterCell", for: indexPath) as! PostCell
        cell.clipsToBounds = true
        cell.backgroundColor = UIColor(white: 1, alpha: 0.3)
        cell.contentView.layer.cornerRadius = 5.0
        cell.contentView.layer.masksToBounds = true
        let post = posts[indexPath.row]
        cell.posts = post
        
        
 
//        func viewUser(){
//                        let ref = Database.database().reference()
//                        ref.child("users").child((cell.posts?.fromID)!).observeSingleEvent(of: .value, with: { (snapshot) in
//                            print("hey")
//                            //           let viewuserprofile = snapshot.key
//
//                            let users = User()
//                            let fromID = snapshot.key
//
//
//                            showSelectedUser(user: users)
//
//
//
//
//                        }, withCancel: nil)
//        }
//
//
//
////        func viewUser(){
////            //        print("hellooooo!")
////
////            let ref = Database.database().reference()
////            ref.child("users").child((cell.posts?.fromID)!).observeSingleEvent(of: .value, with: { (snapshot) in
////                print("hey")
////                //           let viewuserprofile = snapshot.key
////
////                let users = User()
////
////
////                showSelectedUser(user: users)
////
////
////
////
////            }, withCancel: nil)
////
////        }
////
//        func showSelectedUser(user: User) {
//
//            let view = SelectedUser()
//            view.user = [user]
//
//
//
//            self.present(view, animated: true)
//
//            print("hey")
//
//
//        }
//

        
        
     
        
        
        cell.delegate = self
        cell.delegated = self
       
        



        return cell
    }
  

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
}
