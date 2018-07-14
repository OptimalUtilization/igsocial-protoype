//
//  ProHeaderClassTableViewCell.swift
//  myindiefilms
//
//  Created by Vin on 3/18/18.
//  Copyright © 2018 Vin. All rights reserved.
//

import UIKit
import Firebase

class ProHeaderClassTableViewCell: UITableViewCell {

 

    
    var user: User? {
        didSet {
            
          setupProfileHeader()
            
             detailTextLabel?.text = user?.name
           
        }
        
        
    }
    
    
    
    
    func setupProfileHeader() {
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
              print(snapshot)
                
                let name = dictionary["username"] as? String ?? "Name not found"
                user.name = name
                self.nameLabel.text = user.name
                
                if let profileImageURL = dictionary["profileImageURL"] as? String {
                    self.profileimageview.loadImagesUsingCachewithURL(urlString: profileImageURL)
                
                  
                }
                
            }
            
            
        }, withCancel: nil)
    }


 
    
    let profileimageview: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    

override func layoutSubviews() {
    super.layoutSubviews()
    
    textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
    
    detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    
}
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    

        addSubview(profileimageview)
        addSubview(nameLabel)

        profileimageview.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        profileimageview.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        profileimageview.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileimageview.heightAnchor.constraint(equalToConstant: 48).isActive = true

        nameLabel.topAnchor.constraint(equalTo: profileimageview.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: profileimageview.rightAnchor, constant: +10).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: profileimageview.bottomAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }



    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
}


}
