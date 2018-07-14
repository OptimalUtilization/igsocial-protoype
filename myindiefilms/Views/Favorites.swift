//
//  Favorites.swift
//  myindiefilms
//
//  Created by Vin on 6/23/18.
//  Copyright © 2018 Vin. All rights reserved.
//

import UIKit
import Firebase

class Favorites: UITableViewController, commentButtonProtocol {

    let postIDDD = "postIDDD"
    var ref: DatabaseReference!
    var posts = [Post]()
    var user = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userFavorites()
        tableView.register(PostCell.self, forCellReuseIdentifier: postIDDD)
        setupFormat()
    }

    func userFavorites() {
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let ref = Database.database().reference()
        ref.child("user-favorites").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
//            if let value = child.value as? NSDictionary {
                if (child.value as? NSDictionary) != nil {
                    print(snapshot)
                    let posttID = child.key
                                print(posttID)
                    self.fetchPostWithPostID(postID: posttID)
                }else{
//                    tableView = "You do not have any favorites!"
                }
            }
        }, withCancel: nil)
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
    
    
    
    private func fetchPostWithPostID(postID: String){
        let ref = Database.database().reference().child("posts").child(postID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                            print("hello")
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
