//
//  FeedTableViewController.swift
//  
//
//  Created by Vin on 12/12/17.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class FeedTableViewController: UITableViewController {
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.title = "IndieHub"
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        checkifuserisloggedin()
        
    }
    
   func checkifuserisloggedin(){
    if Auth.auth().currentUser?.uid == nil{
    handlelogout()

    }
    }
    
    
    func handlelogout() {
        if (Auth.auth().currentUser != nil) {
            do {
                try Auth.auth().signOut();
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let signinvc = storyboard.instantiateViewController(withIdentifier: "ViewController")
                self.present(signinvc, animated: true, completion: nil);
            } catch {
                alertTheUser(title: "error", message: "logout error")
            }
        }
    }
    
    func alertTheUser(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }
    
   
   
    @IBAction func logouttapped(_ sender: Any) {
        handlelogout()
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    //When you create fetch post "return 0" will be "return post.count"
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
      return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "PostHeader", for: indexPath) as! PostHeaderCell



        return cell
    }
    
    
}
