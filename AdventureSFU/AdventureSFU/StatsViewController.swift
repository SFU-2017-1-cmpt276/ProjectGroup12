//
//  StatsViewController.swift
//
//	AdventureSFU: Make Your Path
//	Created for SFU CMPT 276, Instructor Herbert H. Tsang, P.Eng., Ph.D.
//	AdventureSFU was a project created by Group 12 of CMPT 276
//
//  Created by Group 12 on 3/2/17.
//  Copyright © 2017 . All rights reserved.
//
//	StatsViewController - The screen that will display a user's stats, and let them go to view their team stats
//	Programmers: Karan Aujla, Carlos Abaffy, Eleanor Lewis, Chris Norris-Jones
//
//	Known Bugs: 
//	Todo:	-Further flesh out user's stats
//			-Set up Team stats page, and setup link from StatsViewController to TeamStatsViewController
//

import UIKit
import Firebase

class StatsViewController: UIViewController, UITableViewDataSource {
	
//Outlets
	@IBOutlet weak var userInfo: UITableView!

//Varibles
	var ref: FIRDatabaseReference?
	var email = ""
	var username = ""
    var kilometres: Double = 0.0

//Functions
	
	//Create the Stats Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4 // Change for number of rows in table
    }
	
    //Fill Stats Table
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
	

//Load Actions
      override func viewDidLoad() {
        super.viewDidLoad()
		
		//Sync up with database, and pull in user stats from database into the Stats table
		let userID = FIRAuth.auth()?.currentUser?.uid
		ref = FIRDatabase.database().reference()
		
		ref?.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
			
			let value = snapshot.value as? NSDictionary
			
			let tempEmail = value?["email"]
			let tempUsername = value?["username"]
			let tempKilo = value?["KMRun"]
			
			if let actualEmail = tempEmail {
				self.email = actualEmail as! String
			}
			if let actualUsername = tempUsername {
				self.username = actualUsername as! String
			}
			if let actualKilo = tempKilo {
				self.kilometres = actualKilo as! Double
			}
			
			self.userInfo.reloadData()
			
		})
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//Actions
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
