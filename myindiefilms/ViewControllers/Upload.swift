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

    
    @IBOutlet weak var MediaContent: UIImageView!
    
    @IBOutlet weak var URLInput: UITextField!
    
    @IBOutlet weak var Caption: UITextField!
    
    @IBOutlet weak var Post: UIButton!
    
    var selectedimage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

            MediaContent.layer.cornerRadius = MediaContent.frame.size.width/2
            MediaContent.clipsToBounds = true
            
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.selectmedia))
            MediaContent.addGestureRecognizer(tapGesture)
            MediaContent.isUserInteractionEnabled = true
        
        navigationItem.title = "Upload"
        
}
    
    
    
    
    
    @objc func selectmedia() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        present(pickerController, animated: true, completion: nil)
        
    }
    

    
    @IBAction func Posttapped(_ sender: Any) {
    
        let ref = Database.database().reference().child("Post")
        let childRef = ref.childByAutoId()
        let values = ["Link": URLInput.text!, "Caption": Caption.text!]
        childRef.updateChildValues(values)
    
    }
}

    extension Upload: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
                selectedimage = image
                MediaContent.image = image
                
            }
            dismiss(animated: true, completion: nil)
            
            
        }
}
