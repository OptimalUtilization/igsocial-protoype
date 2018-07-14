//
//  ChatController.swift
//  myindiefilms
//
//  Created by Vin on 1/7/18.
//  Copyright © 2018 Vin. All rights reserved.
//

import UIKit
import Firebase

class ChatController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout{
   
    
    var user: User? {
        didSet{
            navigationItem.title = user?.name
            
            observeMessages()
        }
    }
    
    var messages = [Message]()
    
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid, let toID = user?.toID else{
            return
        }
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toID)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in

            let messageID = snapshot.key
            print(snapshot)
            let messagesRef = Database.database().reference().child("messages").child(messageID)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in

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
             
                   
                    self.messages.append(messages)
                    DispatchQueue.main.async {self.collectionView?.reloadData() }
                
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Message.."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
        }()
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.keyboardDismissMode = .interactive
        
        setupinput()
        
        setupKeyboardObservers()
    }
    
    
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
    
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        
        setupCell(cell: cell, message: message)
        
        
        cell.bubblewidthAnchor?.constant = estimatedTextFrame(text: message.text!).width + 32
        
        return cell
    }
    
    private func setupCell(cell: ChatMessageCell, message: Message) {
        if message.fromID == Auth.auth().currentUser?.uid {
            //outgoing blue
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = UIColor.white
            
           cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            
        }else{
            //incoming grey
            cell.bubbleView.backgroundColor = ChatMessageCell.lightGray
            cell.textView.textColor = UIColor.black
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        if let text = messages[indexPath.item].text{
            height = estimatedTextFrame(text: text).height + 20
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    
    private func estimatedTextFrame(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
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
    
    private func alertTheUser(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
        
    }
    
    @objc func handleSend() {
        
        if inputTextField.text != "" {
//
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toID = user!.toID!
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let fromID = Auth.auth().currentUser!.uid
        let values = ["text": inputTextField.text!, "toID": toID, "fromID": fromID, "timestamp": timestamp] as [String : Any]
//        childRef.updateChildValues(values)
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
//                print(error)
                return
            }
            
            self.inputTextField.text = nil
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromID).child(toID)
            
            let messageID = childRef.key
//            print(messageID)
            userMessagesRef.updateChildValues([messageID: 1])
            
            let recipientUserMessageRef = Database.database().reference().child("user-messages").child(toID).child(fromID)
            recipientUserMessageRef.updateChildValues([messageID: 1])
            
            
        }
        
        
        
        
        
        } else {
           
            return
        }
    }
    
    func textfieldshouldreturntext(textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    

}
