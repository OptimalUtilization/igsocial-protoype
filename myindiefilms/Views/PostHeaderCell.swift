//
//  PostHeaderCell.swift
//  myindiefilms
//
//  Created by Vin on 12/3/17.
//  Copyright © 2017 Vin. All rights reserved.
//

import UIKit
import Firebase

class PostHeaderCell: UITableViewCell {

    
    var episode: PostHeaderCell! {
        didSet {
            self.updateUI()
            
        }
    }

    @IBOutlet weak var PhotoID: UIImageView!
    
    @IBOutlet weak var backgroundcardview: UIView!

    @IBAction func Subscribe(_ sender: Any) {
    }
    @IBAction func Username(_ sender: Any) {
    }
    @IBOutlet weak var Caption: UILabel!
    @IBAction func URLTapped(_ sender: Any) {
    }
    
    
    
    func updateUI()
    {
        
        
        
    }
    
    
    
    
}
//
//

//
//    func updateUI()
//    {
//
//        backgroundcardview.backgroundColor = UIColor.white
//        contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
//
//        backgroundcardview.layer.cornerRadius = 3.0
//        backgroundcardview.layer.masksToBounds = false
//        backgroundcardview.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
//
//        backgroundcardview.layer.shadowOffset = CGSize(width: 0, height: 0)
//        backgroundcardview.layer.shadowOpacity = 0.8
//}
//
//}

