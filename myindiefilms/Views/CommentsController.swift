//
//  CommentsControllerTableViewController.swift
//  myindiefilms
//
//  Created by Vin on 4/8/18.
//  Copyright © 2018 Vin. All rights reserved.
//

import UIKit
import Firebase

class CommentsController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {

    
    var posts = [Post]()
    var user = [User]()
    
    
    var post: Post? {
        didSet{
            
            
           observeComments()
            
            
         

       
        }
    }
    

            func observeComments(){
                
                let ref = Database.database().reference().child("posts").child((post?.postID)!).child("comments")
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    for child in snapshot.children.allObjects as! [DataSnapshot] {
                        if let value = child.value as? NSDictionary {
                            print(snapshot)
                    let posted = Post()
                    let commentFromID = value["commentFromID"] as? String ?? "Unknown User"
                    let commentTimeStamp = value["commentTimeStamp"] as? NSNumber ?? 000000
                    let commentText = value["commentText"] as? String ?? "Be the first to comment!"
                    posted.commentTimeStamp = commentTimeStamp
                    posted.commentText = commentText
//                    posted.commentFromID = commentFromID

//                            self.fetchUserWithCommentID(user: commentFromID)
                            let ref = Database.database().reference().child("users").child(commentFromID)
                            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                                if let dictionary = snapshot.value as? [String: AnyObject]{
                                                        print(snapshot)
                                    posted.commentFromID = dictionary["username"] as? String ?? "Unknown User"
                                  

                                }
                            }, withCancel: nil)

                    self.posts.append(posted)
                    DispatchQueue.main.async {self.collectionView?.reloadData() }
                        }
                    }
                }, withCancel: nil)

            }
    
    
    
    
//    func observeComments(){
//        let ref = Database.database().reference().child("posts").child((post?.postID)!).child("comments")
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            for child in snapshot.children.allObjects as! [DataSnapshot] {
//                if let value = child.value as? NSDictionary {
//
//                    let posted = Post()
////                    let user = User()
//                    let commentFromID = value["commentFromID"] as? String ?? "not found"
//                    let commentTimeStamp = value["commentTimeStamp"] as? NSNumber ?? 000000
//                    let commentText = value["commentText"] as? String ?? "Be the first to comment!"
//                    posted.commentTimeStamp = commentTimeStamp
//                    posted.commentText = commentText
////                    posted.commentFromID = commentFromID
////                    user.name = commentFromID
//
//                 print(commentFromID)
//
//
//
//
//
//
//                    self.fetchUserWithCommentID(commentFromID: commentFromID)
//
//
//                    self.posts.append(posted)
//                    DispatchQueue.main.async {self.collectionView?.reloadData() }
//                }
//            }
//        }, withCancel: nil)
//
//}
//
//
//
//
//            func fetchUserWithCommentID(commentFromID: String){
//                    let ref = Database.database().reference().child("users")
//                ref.observeSingleEvent(of: .value, with: { (snapshot) in
//                        for child in snapshot.children.allObjects as! [DataSnapshot] {
//                            if let value = child.value as? NSDictionary {
//
//
//                                                print(snapshot)
//                            let name = value["username"] as? String
//
//                            commentFromID = name
////                            print(self.post?.commentFromID)
//
////                             DispatchQueue.main.async {self.collectionView?.reloadData() }
//                            }
//                        }
//                    }, withCancel: nil)
//                }
    
//    func observeComments() {
//        guard let userID = post?.commentFromID else {
//            return
//        }
//
//        let ref = Database.database().reference().child("users").child(userID)
//        ref.observe( .value, with: { (snapshot) in
//            if let dictionary = snapshot.value as? [String: AnyObject]{
//
//                self.post?.commentFromID = dictionary["username"] as? String
//             print(userID)
//            }
//        }, withCancel: nil)
//
//        let reff = Database.database().reference().child("posts").child((self.post?.postID)!).child("comments")
//        reff.observe(.value, with: { (snapshot) in
//
////            print(snapshot)
//            for child in snapshot.children.allObjects as! [DataSnapshot] {
//                if let value = child.value as? NSDictionary {
//                    let posted = Post()
//
//                    let commentTimeStamp = value["commentTimeStamp"] as? NSNumber ?? 000000
//                    let commentText = value["commentText"] as? String ?? "Be the first to comment!"
//                    posted.commentTimeStamp = commentTimeStamp
//                    posted.commentText = commentText
//
////                    print(snapshot)
//
//
//
//                    }
//                }
//            }, withCancel: nil)
//
//
//
//
//
//        ref.observe(.childRemoved, with: { (snapshot) in
////            self.messagesDictionary.removeValue(forKey: snapshot.key)
////            self.attemptReloadOfTable()
//        }, withCancel: nil)
//    }

    
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

//        observeComments()
//
        navigationItem.title = "Comments"
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleCancel))
        
      
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(UserCommentsCell.self, forCellWithReuseIdentifier: commentsID)
        
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(UserCommentsCell.self, forCellWithReuseIdentifier: commentsID)
        
        collectionView?.keyboardDismissMode = .interactive
        
        setupinput()
        
        setupKeyboardObservers()
        
        
        
    }
    
    

    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    
    ////////////////
    
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Write a review!"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    let commentsID = "commentsID"
    
    
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification){
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        
        
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification){
        containerViewBottomAnchor?.constant = -80
        
    }
    
    ///////////////////////////////////////////
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return messages.count
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: commentsID, for: indexPath) as! UserCommentsCell
        
        let post = posts[indexPath.item]
        
        cell.username.text = post.commentFromID ?? "Unknown User"
        cell.textView.text = post.commentText
        
        
        if let seconds = post.commentTimeStamp?.doubleValue {
            let timestampDate = NSDate(timeIntervalSince1970: seconds)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, h:mm a"
                
              cell.timeLabel.text  = dateFormatter.string(from: timestampDate as Date)
        }
        
        setupCell(cell: cell, post: post)
        
        
        cell.bubblewidthAnchor?.constant = estimatedTextFrame(text: post.commentText!).width + 32
        
        return cell
    }
    
    private func setupCell(cell: UserCommentsCell, post: Post) {
       
            //outgoing blue
            cell.bubbleView.backgroundColor = .white
            cell.textView.textColor = UIColor.black
            
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
       
    }
    
//    private func setupCell(cell: UserCommentsCell, post: Post) {
//        if post.fromID == Auth.auth().currentUser?.uid {
//            //outgoing blue
//            cell.bubbleView.backgroundColor = UserCommentsCell.blueColor
//            cell.textView.textColor = UIColor.white
//
//            cell.bubbleViewRightAnchor?.isActive = true
//            cell.bubbleViewLeftAnchor?.isActive = false
//
//        }else{
//            //incoming grey
//            cell.bubbleView.backgroundColor = UserCommentsCell.lightGray
//            cell.textView.textColor = UIColor.black
//            cell.bubbleViewRightAnchor?.isActive = false
//            cell.bubbleViewLeftAnchor?.isActive = true
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        
        if let text = posts[indexPath.item].commentText {
            height = estimatedTextFrame(text: text).height + 20
        }

        return CGSize(width: view.frame.width, height: height)
    }

    
    private func estimatedTextFrame(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    ////////////////////////////////////////
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    var containerViewHeightAnchor: NSLayoutConstraint?
    
    
    
    
    func setupinput() {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        //        containerView.backgroundColor = .red
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        
        
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
        
        containerViewBottomAnchor?.isActive = true
        
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        
        containerViewHeightAnchor = containerView.heightAnchor.constraint(equalToConstant: 60)
        containerViewHeightAnchor?.isActive = true
        
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton)
        
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        //        sendButton.backgroundColor = .blue
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        //        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        //        containerView.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.addSubview(inputTextField)
        //        inputTextField.backgroundColor = UIColor.red
        inputTextField.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor).isActive = true
        //        inputTextField.widthAnchor.constraint(equalToConstant: 100)
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor.gray
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
    }
    
    func completionSegue() {
        let feed = FeedTableViewController()
        navigationController?.pushViewController(feed, animated: true)
    }
    
    @objc func handleSend() {
        
        if inputTextField.text == "" {
            return
        } else {
       
        
        let reff = Database.database().reference()
        reff.child("posts").child((self.post?.postID)!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let properties = snapshot.value as? [String : AnyObject] {
                if let commentCount = properties["comments"] as? [String : AnyObject]{
                    
                    let count = commentCount.count
                    let update = ["commentCount" : count]
                    reff.child("posts").child((self.post?.postID)!).updateChildValues(update)

                }
            }
        }, withCancel: nil)
    

        
        
        let ref = reff.child("posts").child((self.post?.postID)!)
        let childRef = ref.child("comments").childByAutoId()
        let commentTimeStamp = Int(NSDate().timeIntervalSince1970)
        let commentFromID = Auth.auth().currentUser!.uid
        let values = ["commentText": inputTextField.text!, "commentFromID": commentFromID, "commentTimeStamp": commentTimeStamp,] as [String : Any]
        
        childRef.updateChildValues(values) { (error, ref) in
                if error != nil {
                    //                print(error)
                    return
                }
   
            
            
            
            
            
            
            
//            self.inputTextField.text = nil

//
//            self.completionSegue()
            }
        }
        
        
        
        // need to include a cancel for nil user: set alert : Choose a user
        
        //        } else {
        //            return
        //        }
        
        
        
    }
    
//
//    func textfieldshouldreturntext(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
//    replacementString string: String) -> Bool {
//
//        let maxLength = 4
//        let currentString: NSString = textField.text! as NSString
//        let newString: NSString =
//            currentString.replacingCharacters(in: range, with: string) as NSString
//        return newString.length <= maxLength
//        handleSend()
////        return true
//    }
    
    func textfieldshouldreturntext(textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    

 

}
//
//extension Date {
//    var timestampString: String? {
//        let formatter = DateComponentsFormatter()
//        formatter.unitsStyle = .full
//        formatter.maximumUnitCount = 1
//        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
//
//        guard let timeString = formatter.string(from: self, to: Date()) else {
//            return nil
//        }
//
//        let formatString = NSLocalizedString("%@ ago", comment: "")
//        return String(format: formatString, timeString)
//    }
//}
