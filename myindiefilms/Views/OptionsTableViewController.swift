//
//  OptionsTableViewController.swift
//  myindiefilms
//
//  Created by Vin on 5/3/18.
//  Copyright © 2018 Vin. All rights reserved.
//

import UIKit

class OptionsTableViewController: UITableViewController {

    let settingsID = "settingsID"
    var items = ["Content Policy", "Privacy Policy", "User Agreement", "Help FAQ", "About Us", "Report"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Settings"
        tableView.register(SettingsCell.self, forCellReuseIdentifier: settingsID)
    }
    



    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
   
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: settingsID, for: indexPath) as! SettingsCell
     
            
   
            cell.settingsLabel.text? = items[indexPath.row]
        

            return cell

    }
    
    func tableview(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    var feed: FeedTableViewController? = nil
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let item = items[indexPath.row]
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Upload") as! Upload
//        self.present(vc, animated: true, completion: nil)
        
        if indexPath.row == 0 {
       
        let terms = TermsOfService()
        navigationController?.pushViewController(terms, animated: true)
        } else  if indexPath.row == 1{
            print("hey")
        } else  if indexPath.row == 2{
        print("hey")
        } else  if indexPath.row == 3{
            print("hey")
        } else  if indexPath.row == 4{
            print("hey")
        } else  if indexPath.row == 5{
            print("hey")
        }
        
//        let feed = FeedTableViewController()
//        newmessagecontroller.inboxcontroller = self
//        let navController = UINavigationController(rootViewController: feed)
//        present(navController, animated: true, completion: nil)
    }
    

 
}

class SettingsCell: UITableViewCell {
   
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let settingsLabel: UILabel = {
        let label = UILabel()
        label.text = "Terms of Service"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init (style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        
    }
    
    func setup(){
        
        addSubview(cellView)
        addSubview(settingsLabel)
        
        cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4).isActive = true
        cellView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
//        cellView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        settingsLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor).isActive = true
//        settingsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        settingsLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
