//
//  ChatMessageCell.swift
//  myindiefilms
//
//  Created by Vin on 2/11/18.
//  Copyright © 2018 Vin. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    
    let textView: UITextView = {
        let tv = UITextView()
        

        tv.backgroundColor = UIColor.clear
//        tv.text = "Sample"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = .white
        tv.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    
    
    var bubblewidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(textView)
        
        //constraints x y width height
        
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 10).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        
        bubbleViewRightAnchor =  bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10)

        bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubblewidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubblewidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

