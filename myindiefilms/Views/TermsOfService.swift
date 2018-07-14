//
//  TermsOfService.swift
//  myindiefilms
//
//  Created by Vin on 6/5/18.
//  Copyright © 2018 Vin. All rights reserved.
//

import UIKit

class TermsOfService: UIViewController {

//    var titleLabel = UILabel()
//    var content = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addTitle()
        addContent()
        
        navigationItem.title = "App"
        

        self.view.backgroundColor = .white
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addTitle() {
        let title = UITextView(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: 40))
        title.textAlignment = NSTextAlignment.center
        title.textColor = UIColor.blue
        title.text = "Terms of Service"
        title.font = UIFont.systemFont(ofSize: 20)
        title.isSelectable = false
        self.view.addSubview(title)
    }
//
//
    func addContent() {
        let textview = UITextView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: view.frame.height))
        textview.textAlignment = NSTextAlignment.center
        textview.textColor = UIColor.black
        textview.text = "Terms of Service,Terms of Service, Terms of Service, Terms of Service, Terms of Service, Terms of Service"
        textview.font = UIFont.systemFont(ofSize: 12)
        textview.isSelectable = false
        self.view.addSubview(textview)
    }
    
}
