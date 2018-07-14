//
//  Message.swift
//  myindiefilms
//
//  Created by Vin on 2/5/18.
//  Copyright © 2018 Vin. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {

    var fromID: String?
    var text: String?
    var timestamp: NSNumber?
    var toID: String?
    
    func chatPartnerID() -> String? {
        
        return fromID == Auth.auth().currentUser?.uid ? toID : fromID
        
//
//        if fromID == Auth.auth().currentUser?.uid {
//           return toID
//        }else{
//            return fromID
//
//
//
//        }
    }
}
