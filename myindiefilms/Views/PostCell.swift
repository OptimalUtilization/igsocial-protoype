//
//  PostCell.swift
//  myindiefilms
//
//  Created by Vin on 12/3/17.
//  Copyright © 2017 Vin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

protocol commentButtonProtocol {
    func commentButtonPressed(post: Post)
    
}

protocol viewProfileProtocol {
    func userPressed(post: Post)
}

class PostCell: UITableViewCell {
    
    var uid = Auth.auth().currentUser!
    var user = [User]()
    var parentViewController: FeedTableViewController? = nil
    
    var posts: Post? {
        didSet {
            
           
           updatePost()
            
            

            let likesnum : Float = Float ((posts?.likes)!)
          
            let dis : Float = Float ((self.posts?.dislikes)!)
            
          
            
            
            let nmr : Float = likesnum + dis

           
            
            
            if nmr == 0 {
                likeLabel.text = "No Rating"
                } else {
                let ratingeq : Float = likesnum / nmr
                let final : Float = ratingeq * 100
                let finalRating = String.localizedStringWithFormat("%.0F", final)
                
//
//                switch (finalRating){
//                case 0: finalRating > 90
//                    break;
//
//                case 1:
//                    break;
//                    
//                case 2:
//                    break;
//
//                }

                likeLabel.text = "\(finalRating)%"
                
                }
            
            linkTextView.setTitle(posts?.URLinput, for: .normal)
            linkTextView.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
            captionTextView.text = posts?.caption
            commentLabel.text = "\(posts?.commentCount ?? 0)"
//            likeLabel.text = "\(posts?.likes ?? 0)"
            
            if let seconds = posts?.timestamp?.doubleValue {
                let timestampDate = NSDate(timeIntervalSince1970: seconds)

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d, h:mm a"
//                 dateFormatter.dateFormat = "hh:mm a"

                timeLabel.text = dateFormatter.string(from: timestampDate as Date)
            }
            
                likeButton.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
                likedButton.addTarget(self, action: #selector(dislikeButtonPressed), for: .touchUpInside)
                commentButton.addTarget(self, action: #selector(commentButtonClicked), for: .touchUpInside)
                nameLabel.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(userProfileClicked))
                nameLabel.addGestureRecognizer(tap)
                
//                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer: )))
//                profileimageview.isUserInteractionEnabled = true
//                profileimageview.addGestureRecognizer(tapGestureRecognizer)
            
            observeLikes()
            observeDislikes()
            
//            profileimageview.addTarget(self, action: #selector(nil), for: .touchUpInside)
            
        
    }
        
        
        
    }
    
    var delegate: commentButtonProtocol!
    
    var delegated: viewProfileProtocol!
    
    
    
    @objc func commentButtonClicked(sender: UIButton!) {
        
        self.delegate.commentButtonPressed(post: posts!)
        
    }
    
    @objc func userProfileClicked(sender: UITapGestureRecognizer){
    
        self.delegated.userPressed(post: posts!)
    }
    
//    @objc func userButtonPressed(sender: UITapGestureRecognizer!){
//        self.delegated.userButtonPressed(post: posts!)
//    }
//

//    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
//        let tappedImage = tapGestureRecognizer.view as! UIImageView
//
//
//
//        let ref = Database.database().reference()
//        ref.child("users").child((self.posts?.fromID)!).observeSingleEvent(of: .value, with: { (snapshot) in
//            print(snapshot)
////           let viewuserprofile = snapshot.key
//
//            let users = User()
//
//
//            self.showSelectedUser(user: users)
//
//
//
//
//        }, withCancel: nil)
//
//
//    }
//
//    func presentView(){
//        let view = SelectedUser()
//        self.parentViewController?.navigationController?.pushViewController(view, animated: true)
//    }
//
//
//    func showSelectedUser(user: User) {
//
//        let view = SelectedUser()
//        view.user = [user]
//
//
//
//        self.parentViewController?.navigationController?.present(view, animated: true)
//
//        print("hey")
//
//
//    }

   
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
        
    }
    
    
    func observeLikes(){

        let ref = Database.database().reference()
        ref.child("posts").child((self.posts?.postID)!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let properties = snapshot.value as? [String : AnyObject] {
                if let peopleWhoLike = properties["peopleWhoLike"] as? [String : AnyObject] {
                    for (_, person) in peopleWhoLike {
                        if person as? String == Auth.auth().currentUser!.uid {
                        self.likeButton.isSelected = true
                    }else{
//                        self.likedButton.isSelected = false
                    }
            }
        }
    }
    })
    }
    
    func observeDislikes(){
        let ref = Database.database().reference()
        ref.child("posts").child((self.posts?.postID)!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let properties = snapshot.value as? [String : AnyObject] {
                if let peopleWhoDislike = properties["peopleWhoDislike"] as? [String : AnyObject] {
                    for (_, person) in peopleWhoDislike {
                        if person as? String == Auth.auth().currentUser!.uid {
                            self.likedButton.isSelected = true
                        }else{
                            //                        self.likedButton.isSelected = false
                        }
                    }
                }
            }
        })
    }
    
  
    
    func updatePost(){
        if let fromID = posts?.fromID {
            let ref = Database.database().reference().child("users").child(fromID)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                  
                    self.nameLabel.text = dictionary["username"] as? String
                    if let profileImageURL = dictionary["profileImageURL"] as? String {
                        self.profileimageview.loadImagesUsingCachewithURL(urlString: profileImageURL)
                    }
                }
            }, withCancel: nil)
        }
        
    }
    
//    func movieRating() {
//        let dislikes =  posts?.dislikes!
//        let likes = posts?.likes!
//        let total = dislikes + likes
//
//        let rating = posts?.likes
//    }

    func removeLikeValues(){
        let ref = Database.database().reference()
        ref.child("posts").child((self.posts?.postID)!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let properties = snapshot.value as? [String : AnyObject] {
                if let peopleWhoDislike = properties["peopleWhoDislike"] as? [String : AnyObject] {
                    for (id, person) in peopleWhoDislike {
                        if person as? String == Auth.auth().currentUser!.uid {
                            ref.child("posts").child((self.posts?.postID)!).child("peopleWhoDislike").child(id).removeValue(completionBlock: { (error, reff) in
                                if error == nil {
                                    ref.child("posts").child((self.posts?.postID)!).observeSingleEvent(of: .value, with: { (snap) in
                                        if let prop = snap.value as? [String : AnyObject]{
                                            if let dislikes = prop["peopleWhoDislike"] as? [String : AnyObject]{
                                                let count = dislikes.count
//                                                self.likeLabel.text = "\(count)"
                                                ref.child("posts").child((self.posts?.postID)!).updateChildValues(["dislikes" : count])
                                            } else {
                                                self.likeLabel.text = "No Rating"
                                                ref.child("posts").child((self.posts?.postID)!).updateChildValues(["dislikes" : 0])
                                            }
                                        }
                                    }, withCancel: nil)
                                }
                            })
                        }
                    }
                }
            }
        }, withCancel: nil)
    }
    
    @objc func likeButtonPressed(sender: UIButton!) {
        
        if self.likeButton.isSelected == true {
            removeLikedValues()
            updateFavorites()
            self.likeButton.isSelected = false
            return
        }
//        let uid = Auth.auth().currentUser!
        
        let ref = Database.database().reference()
        let keyToPost = ref.child("posts").childByAutoId().key
        ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
//            if let post = snapshot.value as? [String: AnyObject]{
            if (snapshot.value as? [String: AnyObject]) != nil{

                let updateLikes: [String: Any] = ["peopleWhoLike/\(keyToPost)" : Auth.auth().currentUser!.uid]
//                print(updateLikes) works
              
                print(updateLikes)
                ref.child("posts").child((self.posts?.postID)!).updateChildValues(updateLikes, withCompletionBlock: { (error, reff) in
                    if error == nil{
                    
                        ref.child("posts").child((self.posts?.postID)!).observeSingleEvent(of: .value, with: { (snapshot) in
                            if let properties = snapshot.value as? [String : AnyObject] {
                                if let likes = properties["peopleWhoLike"] as? [String : AnyObject]{
                                   
                                    let count = likes.count
//                                    self.likeLabel.text = "\(count)"
                                    print(count)
                                    let update = ["likes" : count]
                                    ref.child("posts").child((self.posts?.postID)!).updateChildValues(update)
                                    self.favoritesList()
                                    self.removeLikeValues()
                                    self.likeButton.isSelected = true
                                    self.likedButton.isSelected = false
                                    //Code to remove dislike from firebase
                                    
                                    print(updateLikes)

                                }
                            }
                        }, withCancel: nil)
                    }
                })


            }

        }, withCancel: nil)
        
        
        
        ref.removeAllObservers()
    }
    
    func favoritesList() {
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let postID = ((self.posts?.postID)!)
        let ref = Database.database().reference().child("user-favorites").child(uid).child(postID)
        let childRef = ref.childByAutoId()
        let favoritesID = childRef.key
        ref.updateChildValues([favoritesID: 1])
    }
    
    func updateFavorites() {
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
            let postID = ((self.posts?.postID)!)
            Database.database().reference().child("user-favorites").child(uid).child(postID).removeValue(completionBlock: { (error, ref) in
                if error != nil {
                    print("Failed to delete message:", error!)
                    return
                }
                
//                self.messagesDictionary.removeValue(forKey: postID)
    })
    }
        
    
    func removeLikedValues(){
        let ref = Database.database().reference()
        ref.child("posts").child((self.posts?.postID)!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let properties = snapshot.value as? [String : AnyObject] {
                if let peopleWhoLike = properties["peopleWhoLike"] as? [String : AnyObject] {
                    for (id, person) in peopleWhoLike {
                        if person as? String == Auth.auth().currentUser!.uid {
                            ref.child("posts").child((self.posts?.postID)!).child("peopleWhoLike").child(id).removeValue(completionBlock: { (error, reff) in
                                if error == nil {
                                    ref.child("posts").child((self.posts?.postID)!).observeSingleEvent(of: .value, with: { (snap) in
                                        if let prop = snap.value as? [String : AnyObject]{
                                            if let likes = prop["peopleWhoLike"] as? [String : AnyObject]{
                                            let count = likes.count
//                                            self.likeLabel.text = "\(count)"
                                                ref.child("posts").child((self.posts?.postID)!).updateChildValues(["likes" : count])
                                            } else {
                                                self.likeLabel.text = "No Rating"
                                                ref.child("posts").child((self.posts?.postID)!).updateChildValues(["likes" : 0])
                                            }
                                        }
                                    }, withCancel: nil)
                                }
                            })
                        }
                    }
                }
            }
        }, withCancel: nil)
    }
 

     @objc func dislikeButtonPressed(sender: UIButton!) {
        if self.likedButton.isSelected == true {
            removeLikeValues()
            updateFavorites()
            self.likedButton.isSelected = false
            return
        }
        let ref = Database.database().reference()
        let keyToPost = ref.child("posts").childByAutoId().key
        ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            if let post = snapshot.value as? [String: AnyObject]{
                
                print(post)
                
                let updateDislikes: [String: Any] = ["peopleWhoDislike/\(keyToPost)" : Auth.auth().currentUser!.uid]
                //                print(updateLikes) works
                
//                print(updateDislikes)
                ref.child("posts").child((self.posts?.postID)!).updateChildValues(updateDislikes, withCompletionBlock: { (error, reff) in
                    if error == nil{
                        
                        ref.child("posts").child((self.posts?.postID)!).observeSingleEvent(of: .value, with: { (snapshot) in
                            if let properties = snapshot.value as? [String : AnyObject] {
                                if let dislikes = properties["peopleWhoDislike"] as? [String : AnyObject]{
                                    
                                    let count = dislikes.count
//                                    self.likeLabel.text = "\(count)"
                          
                                    let update = ["dislikes" : count]
                                    ref.child("posts").child((self.posts?.postID)!).updateChildValues(update)
                                    self.updateFavorites()
                                    self.removeLikedValues()
                                    self.likedButton.isSelected = true
                                    self.likeButton.isSelected = false
                                    print(updateDislikes)
                                    
                                }
                            }
                        }, withCancel: nil)
                    }
                })
                
                
            }
            
        }, withCancel: nil)
        
        ref.removeAllObservers()
    }
    
    
    
    
    
   
    
//    @objc func imageTapped(gestureRecognizer: UITapGestureRecognizer)
//    {
//        let selecteduser = SelectedUser()
//        let tappedImageView = gestureRecognizer.view!
//        let imageView = tappedImageView as! UIImageView
////        navigationController?.pushViewController(selecteduser, animated: true)
//        print("hey")
//    }

    
    let profileimageview: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
//        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gestureRecognizer:)))
//        imageView.addGestureRecognizer(tapRecognizer)
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        //        label.text = "HH:MM:SS"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .right
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        return label
    }()

    
    @objc func buttonAction(sender: UIButton!) {
        let aSuffix = "www.youtube.com"
        UIApplication.shared.open(URL(string: "http://\(aSuffix)")! as URL, options: [:], completionHandler: nil)
        print("sent!")
    }
    


    let linkTextView: UIButton = {
        let link = UIButton(type: .system)
//        link.setTitle("Link this is my url for my website check this link out", for: .normal)
        link.contentHorizontalAlignment = .left
//        link.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        link.translatesAutoresizingMaskIntoConstraints = false
        return link
        
    }()
    
    
    let captionTextView: UITextView = {
        let caption = UITextView()
        caption.isSelectable = false
        caption.translatesAutoresizingMaskIntoConstraints = false
        caption.backgroundColor = UIColor.clear
        caption.textColor = UIColor.white
        return caption
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "freeUpArrow1.png"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "freeUpArrow1.png"), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    let likedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "freeDownArrow.png"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "freeDownArrow.png"), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let likeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.white
//        label.text = "98%"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.white
//        label.text = "10,000"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let commentButton: UIButton = {
        let commentBut = UIButton(type: .system)
        commentBut.setImage(#imageLiteral(resourceName: "freeComment.png"), for: .normal)
        commentBut.translatesAutoresizingMaskIntoConstraints = false
        return commentBut
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileimageview)
        addSubview(timeLabel)
        addSubview(nameLabel)
        addSubview(linkTextView)
        addSubview(captionTextView)
        


        profileimageview.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        profileimageview.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        profileimageview.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileimageview.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: profileimageview.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: profileimageview.rightAnchor, constant: +10).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: profileimageview.bottomAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        linkTextView.topAnchor.constraint(equalTo: profileimageview.bottomAnchor).isActive = true
        linkTextView.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        linkTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        linkTextView.rightAnchor.constraint(equalTo: timeLabel.rightAnchor).isActive = true
        
        captionTextView.topAnchor.constraint(equalTo: linkTextView.bottomAnchor).isActive = true
        captionTextView.leftAnchor.constraint(equalTo: linkTextView.leftAnchor, constant : -4).isActive = true
        captionTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40).isActive = true
        captionTextView.rightAnchor.constraint(equalTo: timeLabel.rightAnchor).isActive = true
        

        
        setupBottomButtons()
    }
    
    private func setupBottomButtons(){
        
        
        
        let likeButtonContainerView = UIView()
        

        
        let likedButtonContainerView = UIView()
       
        
        let likeLabelContainerView = UIView()
       
        
        let commentButtonContainerView = UIView()
      
        
        let commentLabelContainerView = UIView()
        
        
        let buttonStackView = UIStackView(arrangedSubviews: [likeButtonContainerView, likedButtonContainerView, likeLabelContainerView, commentButtonContainerView, commentLabelContainerView])
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        
        addSubview(buttonStackView)
        buttonStackView.leftAnchor.constraint(equalTo: linkTextView.leftAnchor).isActive = true
        buttonStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
        buttonStackView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        buttonStackView.rightAnchor.constraint(equalTo: timeLabel.rightAnchor).isActive = true
        
        addSubview(likeButton)
        addSubview(likedButton)
        addSubview(likeLabel)
        addSubview(commentButton)
        addSubview(commentLabel)
        
        likeButton.topAnchor.constraint(equalTo: likeButtonContainerView.topAnchor).isActive = true
        likeButton.leftAnchor.constraint(equalTo: likeButtonContainerView.leftAnchor).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        likedButton.topAnchor.constraint(equalTo: likedButtonContainerView.topAnchor).isActive = true
        likedButton.leftAnchor.constraint(equalTo: likedButtonContainerView.leftAnchor).isActive = true
        likedButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        likedButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        likeLabel.topAnchor.constraint(equalTo: likeLabelContainerView.topAnchor).isActive = true
        likeLabel.leftAnchor.constraint(equalTo: likeLabelContainerView.leftAnchor).isActive = true
        likeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        likeLabel.widthAnchor.constraint(equalTo: likeLabelContainerView.widthAnchor).isActive = true
        
        commentButton.topAnchor.constraint(equalTo: commentButtonContainerView.topAnchor).isActive = true
        commentButton.leftAnchor.constraint(equalTo: commentButtonContainerView.leftAnchor).isActive = true
        commentButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        commentButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        commentLabel.topAnchor.constraint(equalTo: commentLabelContainerView.topAnchor).isActive = true
        commentLabel.leftAnchor.constraint(equalTo: commentLabelContainerView.leftAnchor).isActive = true
        commentLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        commentLabel.widthAnchor.constraint(equalTo: commentLabelContainerView.widthAnchor).isActive = true
            
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

  


