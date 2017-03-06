//
//  StatsViewController.swift
//  AdventureSFU
//
//  Created by Karan Aujla on 3/4/17.
//  Copyright © 2017 Karan Aujla. All rights reserved.
//

import UIKit
import Firebase

class StatsViewController: UIViewController, UITableViewDataSource {
	
	@IBOutlet weak var userInfo: UITableView!
    var testProfile = userProfile(enteredPassword: "testpass", enteredUsername: "testUSer", enteredEmail: "test@email.com")

	var ref: FIRDatabaseReference?
	var email = ""
	var username = ""
	var kilometres = 30

    //for the table view
	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4 // change this value when actually implementing it. for testing only
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celltoBeReturned: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "userInfo")!
        
        if indexPath.row == 0 {
            celltoBeReturned.textLabel?.text = "Username"
            celltoBeReturned.detailTextLabel?.text = username
            //celltoBeReturned.
        } else if indexPath.row == 1{
			celltoBeReturned.textLabel?.text = "Email"
            celltoBeReturned.detailTextLabel?.text = email
        
		}else if indexPath.row == 2{
			celltoBeReturned.textLabel?.text = "Kilometres Run"
			celltoBeReturned.detailTextLabel?.text = String(kilometres)
		}else {
            celltoBeReturned.textLabel?.text = "default for testing"
        }
        
        return celltoBeReturned
    }
	

	
      override func viewDidLoad() {
        super.viewDidLoad()
		
		let userID = FIRAuth.auth()?.currentUser?.uid
		ref = FIRDatabase.database().reference()
		
		ref?.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
			
			let value = snapshot.value as? NSDictionary
			
			let tempEmail = value?["email"]
			let tempUsername = value?["username"]
			let tempKilo = value?["KM run"]
			
			if let actualEmail = tempEmail {
				self.email = actualEmail as! String
			}
			if let actualUsername = tempUsername {
				self.username = actualUsername as! String
			}
			if let actualKilo = tempKilo {
				self.kilometres = actualKilo as! Int
			}
			
			self.userInfo.reloadData()
			
		})
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //return to the previous screen
    @IBAction func BackButton(){
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
