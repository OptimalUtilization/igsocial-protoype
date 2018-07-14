//
//  Post.swift
//  myindiefilms
//
//  Created by Vin on 2/25/18.
//  Copyright © 2018 Vin. All rights reserved.
//

import UIKit

class Post: NSObject {

    var fromID: String?
    var URLinput: String?
    var caption: String?
    var timestamp: NSNumber?
    var likes: Int?
    var dislikes: Int?
    var postID: String?
    var commentText: String?
    var commentTimeStamp: NSNumber?
    var commentFromID: String?
    var commentCount: Int?

    
    var comments: [String] = [String]()
    var peopleWhoLike: [String] = [String]()
    var peopleWhoDislike: [String] = [String]()
}
