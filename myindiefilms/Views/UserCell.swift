//
//  UserCell.swift
//  myindiefilms
//
//  Created by Vin on 2/10/18.
//  Copyright © 2018 Vin. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    
    var message: Message? {
        didSet {
          setupNameProfileIMG()
            
            detailTextLabel?.text = message?.text
            
            if let seconds = message?.timestamp?.doubleValue {
            let timestampDate = NSDate(timeIntervalSince1970: seconds)
            
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
            
                timeLabel.text = dateFormatter.string(from: timestampDate as Date)
            }
        
            
        }
    }
    
    private func setupNameProfileIMG () {
            
        
        
        if let id = message?.chatPartnerID() {
            let ref = Database.database().reference().child("users").child(id)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]
                {
                    self.textLabel?.text = dictionary["username"] as? String
                    
                    if let profileImageURL = dictionary["profileImageURL"] as? String {
                        self.profileimageview.loadImagesUsingCachewithURL(urlString: profileImageURL)
                    }
                    
                }
                
                
            }, withCancel: nil)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
        detailTextLabel?.backgroundColor = UIColor.clear
        detailTextLabel?.textColor = UIColor.white
        
    }
    
    let profileimageview: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
//        label.text = "HH:MM:SS"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileimageview)
        addSubview(timeLabel)
        // x, y, width, height
        profileimageview.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileimageview.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileimageview.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileimageview.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
