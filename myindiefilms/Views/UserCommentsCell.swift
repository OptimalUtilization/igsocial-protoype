//
//  MessageID.swift
//  myindiefilms
//
//  Created by Vin on 12/29/17.
//  Copyright © 2017 Vin. All rights reserved.
//

import UIKit

class UserCommentsCell: UICollectionViewCell {
    

    

    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.italicSystemFont(ofSize: 12)
        tv.textColor = .black
        tv.translatesAutoresizingMaskIntoConstraints = false
//        tv.backgroundColor = .yellow
         tv.textAlignment = .right
        return tv
    }()
    
    static let blueColor = UIColor(red:0.00, green:0.64, blue:1.00, alpha:1.0)
    static let lightGray = UIColor(displayP3Red: 0.1, green: 0.0, blue: 0.0, alpha: 0.1)
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let username: UILabel = {
        let label = UILabel()
//        label.text = "hello"
       
        label.font = UIFont.boldSystemFont(ofSize: 12)
//        label.font = .boldSystemFont(ofSize: 1)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
//        label.text = "TIME"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var bubblewidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(username)
        addSubview(timeLabel)




        bubbleViewRightAnchor =  bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10)

        bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubblewidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubblewidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 10).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
//        username.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10)
        username.rightAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        username.topAnchor.constraint(equalTo: textView.topAnchor, constant: 8).isActive = true
        username.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4).isActive = true
        
        timeLabel.topAnchor.constraint(equalTo: username.bottomAnchor).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: username.leftAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
