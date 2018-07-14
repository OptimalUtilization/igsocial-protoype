//
//  EditProfile.swift
//  myindiefilms
//
//  Created by Vin on 4/22/18.
//  Copyright © 2018 Vin. All rights reserved.
//

import UIKit
import Firebase

class EditProfile: UIViewController {

    @IBOutlet weak var editImage: UIImageView!
    
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var bio: UITextView!
    
    var selectedimage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Edit your info"
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    
        fetchuserandsetupnavbar()
        editImage.layer.cornerRadius = editImage.frame.size.width/2
        editImage.clipsToBounds = true
        self.bio.layer.borderColor = UIColor.lightGray.cgColor
        self.bio.layer.borderWidth = 1
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EditProfile.handleimage))
        editImage.addGestureRecognizer(tapGesture)
        editImage.isUserInteractionEnabled = true
   
    }
    
   
    
    
    @objc func handleimage(){
        let pickercontroller = UIImagePickerController()
        pickercontroller.delegate = self
        present(pickercontroller, animated: true, completion: nil)
    }
    
    func fetchuserandsetupnavbar() {
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                print(snapshot)
                let user = User()
                let name = value["username"] as? String ?? "Name not found"
                let bioinput = value["Bio"] as? String ?? ""
                user.name = name
                self.username.text = name
                self.bio.text = bioinput
                let profileImageURL = value["profileImageURL"] as? String
                
                
                self.editImage.loadImagesUsingCachewithURL(urlString: profileImageURL!)
            }
        }, withCancel: nil)
    }

   
  var profileView: Profile? = nil
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
//        self.tabBarController?.selectedIndex = 0
    }
    
    func removeValuesFromDatabase() {
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        let ref = Database.database().reference()
        ref.child("users").child(uid).child("Bio").removeValue(completionBlock: { (error, ref) in
            if error != nil {
                print("Failed to delete message:", error!)
                return
            }
            
        })
        self.updateValues()
    }
    
    func updateValues() {
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let values = ["Bio": self.bio.text!]
        //228 characters MAX
        
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values) { (error, ref) in
            if error != nil{
                print(error!)
                return
            }
        }
    }
    
    func segueComplete() {
        self.tabBarController?.selectedIndex = 0
    }
    

private func alertTheUserSegue(title:String, message:String) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
    let ok = UIAlertAction(title: "OK", style: .default, handler: attemptSegue);
    alert.addAction(ok);
    present(alert, animated: true, completion: nil);
    
   
    
}

    private func alertTheUser(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
        
    }
    
//@objc func segueCompleted(){
//    self.tabBarController?.selectedIndex = 1
//}

    private func attemptSegue(alert: UIAlertAction!) {
    self.timer?.invalidate()
    self.timer = Timer.scheduledTimer(timeInterval: 0.8, target:self, selector: #selector(self.showController), userInfo: nil, repeats: false)
}

var timer: Timer?
    
 
    
    func changePhoto() {
        
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let imagename = NSUUID().uuidString

        let storageRef = Storage.storage().reference(forURL: "gs://myindiefilms-3fc8b.appspot.com").child("profile_image").child("\(imagename).jpeg")
        if let inputdata =  UIImageJPEGRepresentation(self.editImage.image!, 0.1) {
            storageRef.putData(inputdata, metadata: nil, completion: {( metadata, error) in
//                self.removeStoragePhoto(imagename: imagename)
                if error != nil {

                    self.alertTheUser(title: "Upload Error", message: "There was an issue uploading the selected photo.")

                    return
                }

//                self.removeStoragePhoto(imagename: imagename)
                if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                    let values = ["profileImageURL": profileImageURL]
                    let ref = Database.database().reference()
                    let usersReference = ref.child("users").child(uid)
                    usersReference.updateChildValues(values) { (error, ref) in
                        if error != nil{
                            print(error!)
                            return
                        }
                    }
                }

            })
        }
    }


//        func uploadImg() {
//            let userUid = Auth.auth().currentUser?.uid
//
//            guard let img = UIImagePickerController.image, image == true else {
//                print("Image needs to be selected")
//                return
//            }
//
//            if let imgData = UIImageJPEGRepresentation(img, 0.2) {
//                let metadata = StorageMetadata()
//                metadata.contentType = "image/jpeg"
//
//                // create reference to image location
//                let profilePicRef = Storage.storage().reference().child("\(userUid!)/profilePic.jpg")
//                // upload image
//                profilePicRef.putData(imgData, metadata: metadata) { (metadata, error) in
//                    if error != nil {
//                        print("Didn't upload image in Firebase Storage")
//                        self.isUploaded = false
//                    } else {
//                        print("Uploaded in Firebase Storage")
//                        self.isUploaded = true
//                        let downloadURL = metadata?.downloadURL()?.absoluteString
//                        if let url = downloadURL {
//                            self.setUser(img: url)
//                            self.downloadPhoto(user: self.name)
//                        }
//                    }
//                }
//            }
//        }
    

    
//    func removeStoragePhoto() {
//        guard let uid = Auth.auth().currentUser?.uid else{
//            return
//        }
//        let imagename = NSUUID().uuidString
//        let storageRef = Storage.storage().reference(forURL: profileImageURL)
//        storageRef.delete { (error) in
//            if error != nil {
//
//                self.alertTheUser(title: "Upload Error", message: "There was an issue removing the original photo.")
//
//                return
//            } else {
//        }
//    }
//
//
//    }
    
    func observePhoto(){
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let rootRef = Database.database().reference().child("users").child(uid)
        rootRef.queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                print(snapshot)
                if let value = child.value as? NSDictionary {
                   let user = User()
                    user.profileImageURL = value["profileImageURL"] as? String ?? "Not found"
                    let profileImageURL = user.profileImageURL
                    let storageRef = Storage.storage().reference(forURL: profileImageURL!)
                    storageRef.delete { (error) in
                        if error != nil {
                            
                            self.alertTheUser(title: "Upload Error", message: "There was an issue removing the original photo.")
                            
                            return
                        } else {
                        }
                    }
                    
                    
                }
            }

        }, withCancel: nil)

    }
    
    
 
    
    @objc func showController() {
     
//        navigationController?.popToRootViewController(animated: true)
//        self.profileView?.attemptReloadOfTable()
        
        dismiss(animated: true, completion: nil)
    }
            
    
    
    @IBAction func confirmTapped(_ sender: Any) {
        observePhoto()
        removeValuesFromDatabase()
        changePhoto()
        alertTheUserSegue(title: "Edit Profile", message: "Success!")
//       removeStoragePhoto()
}
}



extension EditProfile: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
         
            selectedimage = image
            editImage.image = image
            
            
        }
        dismiss(animated: true, completion: nil)
        
        
    }
}
