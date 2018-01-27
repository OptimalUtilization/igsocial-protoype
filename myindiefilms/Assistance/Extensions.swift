//
//  Extensions.swift
//  myindiefilms
//
//  Created by Vin on 1/6/18.
//  Copyright © 2018 Vin. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    //QUESTIONABLE
    
    
    
    func loadImagesUsingCachewithURL(urlString: String) {
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
        self.image = cachedImage
            return
        }
        
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!,
                                   completionHandler:
            {(data, response, error) in
                
                //download hit error
                if error != nil {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async() {
                    
                    if let downloadedimage = UIImage(data: data!){
                        imageCache.setObject(downloadedimage, forKey: urlString as AnyObject)
                        
                        
                        self.image = downloadedimage
                    }
                   
                    
                }
                
        }).resume()
    
    }
}
