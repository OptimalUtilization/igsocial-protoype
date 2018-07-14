//
//  Upload.swift
//  myindiefilms
//
//  Created by Vin on 12/10/17.
//  Copyright © 2017 Vin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import MobileCoreServices
import AVFoundation

class Upload: UIViewController {

    var gradientLayer: CAGradientLayer!
    
    @IBOutlet weak var MediaContent: UIImageView!
    
    @IBOutlet weak var URLInput: UITextField!
    
    @IBOutlet weak var Caption: UITextField!
    
    @IBOutlet weak var Post: UIButton!
    
    var selectedimage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        createGradientLayer()
            MediaContent.layer.cornerRadius = MediaContent.frame.size.width/2
            MediaContent.clipsToBounds = true
        
        URLInput.addTarget(self, action: #selector(Upload.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
            
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.selectmedia))
//            MediaContent.addGestureRecognizer(tapGesture)
//            MediaContent.isUserInteractionEnabled = true
        
        navigationItem.title = "Post"
        self.Post.isEnabled = false
       
}
    
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.lightGray.cgColor, UIColor.white.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }


    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if self.URLInput.text != "" {
        self.Post.isEnabled = true
        self.Post.backgroundColor = UIColor.green.withAlphaComponent(0.3)
        self.Post.layer.cornerRadius = self.Post.frame.size.width/2
        
    } else {
    
        self.Post.isEnabled = false
        self.Post.backgroundColor = UIColor.clear
        self.Post.layer.cornerRadius = self.Post.frame.size.width/2
    
    }
    }
    

    
//    @objc func selectmedia() {
//        let pickerController = UIImagePickerController()
//        pickerController.delegate = self
//        pickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
//        present(pickerController, animated: true, completion: nil)
//
//    }
    

    
    @IBAction func Posttapped(_ sender: Any) {
        
        
        if self.URLInput.text != "" {
                self.Post.isEnabled = true
//            self.Post.backgroundColor = UIColor.green.withAlphaComponent(0.3)
//            self.Post.layer.cornerRadius = self.Post.frame.size.width/2
            sendDataToDatabase()
        } else {
            self.Post.isEnabled = false
            self.alertTheUser(title: "Post Error", message: "Please fill all required text fields.")
        }
    
        func segueComplete() {
            self.tabBarController?.selectedIndex = 0
        }
        
    }
    
    private func alertTheUser(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
        
    }
    
    private func alertTheUserSegue(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: attemptSegue);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
        
        
        
    }
    
    @objc func segueCompleted(){
         self.tabBarController?.selectedIndex = 0
    }
    
        private func attemptSegue(alert: UIAlertAction!) {
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 0.8, target:self, selector: #selector(self.segueCompleted), userInfo: nil, repeats: false)
        }
    
        var timer: Timer?
    
    
    
    
    func sendDataToDatabase(){
        
       
        let ref = Database.database().reference().child("posts")
        let childRef = ref.childByAutoId()
        let key = childRef.key
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let fromID = Auth.auth().currentUser!.uid
        let values = ["caption": Caption.text!, "URLinput": URLInput.text!, "fromID": fromID, "postID": key, "timestamp": timestamp, "likes": Int(0), "dislikes": Int(0), "commentCount": Int(0)] as [String : Any]
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                //                print(error)
                return
            }
            let userPostsRef = Database.database().reference().child("user-posts").child(fromID)
            let userPostID = childRef.key
            userPostsRef.updateChildValues([userPostID: 1])
        
    }
    
        //progress success
    self.Caption.text = ""
    self.URLInput.text = ""
        
        
        alertTheUserSegue(title: "Post", message: "Your video has been posted!")
        
        
        //set a delay here
}
    
}

//    extension Upload: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//            if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
//                selectedimage = image
//                MediaContent.image = image
//
//            }
//            dismiss(animated: true, completion: nil)
//
//
//        }
//}

