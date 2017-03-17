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

class StatsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
//Outlets
	@IBOutlet weak var userInfo: UITableView!
   
//Varibles
	var ref: FIRDatabaseReference?
    //user info
    var email: String = ""
    var username: String = ""
    var kilometres: Double = 0.0
    var height: Double = 0.0
    var weight: Double = 0.0
    var personalMessage: String = ""
    
    var canEditUserInfo: Bool = false //used to track if the user can edit their info


//Functions
	
	//Create the Stats Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7// Change for number of rows in table
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
            
		}else if indexPath.row == 3{
            celltoBeReturned.textLabel?.text = "height"
            
            let heightInInches: Int = Int(round(height * 12)) % 12
            let heightInFeet: Int = Int(height)
            
            celltoBeReturned.detailTextLabel?.text = "\(heightInFeet) ft. \(heightInInches) In. "
           
        }else if indexPath.row == 4{
            celltoBeReturned.textLabel?.text = "weight"
            
            celltoBeReturned.detailTextLabel?.text = " \(String(format: "%.1f", weight)) lbs"
            
        }else if indexPath.row == 5{
            celltoBeReturned.textLabel?.text = "personal message"
            celltoBeReturned.detailTextLabel?.text = personalMessage
            
        }else{
            celltoBeReturned.textLabel?.text = ""
            celltoBeReturned.detailTextLabel?.text = ""
        }
        
        return celltoBeReturned
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       //print("selected row \(indexPath.row)")
        //only allow the user info to be edited if the edit button has been tapped
        if canEditUserInfo {
            
            //if the username is selected
            if indexPath.row == 0 {
                //create an alert to change the username
                let changeUsernameAlert = UIAlertController(title: "new Username", message: "please enter your new username", preferredStyle: .alert)
                
                //the new username is inputed here
                changeUsernameAlert.addTextField(configurationHandler: nil)
                
                //
                let confirmChange = UIAlertAction(title: "confirm", style: .default, handler: {confirmChange in
                    self.username = (changeUsernameAlert.textFields!.last?.text)!
                    //also change the username on firebase
                    self.ref?.child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).child("username").setValue(self.username)
                    print("username is now: \(self.username)")
                    self.userInfo.reloadData()
                    })
                changeUsernameAlert.addAction(confirmChange)
                
                let cancelChange = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
                changeUsernameAlert.addAction(cancelChange)
                
                present(changeUsernameAlert, animated: true)
            
            //if height is selected
            } else if indexPath.row == 3 {
                //due to there being 2 values for height (feet and inches), we need to ask what value they want to change
                var feetChosen = false //a boolean indicating which value the user chose. False implies that they chose inches
                
                
                let chooseHeightValue = UIAlertController(title: "changing height",
                                                          message: "please choose which value you would like to change: Feet or Inches",
                                                          preferredStyle: .alert)
                
                let choseInches = UIAlertAction(title: "Inches", style: .destructive, handler: {choseInches in feetChosen = false})
                chooseHeightValue.addAction(choseInches)
                
                let choseCancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
                chooseHeightValue.addAction(choseCancel)
                
                let choseFeet = UIAlertAction(title: "feet", style: .destructive, handler: {choseFeet in feetChosen = true})
                chooseHeightValue.addAction(choseFeet)
                present(chooseHeightValue, animated: true)
                
                let infoAlert = UIAlertController(title: "askdj", message: "feetchosen is now \(feetChosen)", preferredStyle: .alert)
                let infoAction = UIAlertAction(title: "ok:", style: .default, handler: nil)
                infoAlert.addAction(infoAction)
                present(infoAlert, animated: true, completion: nil)
            }
            
        }
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
            let tempHeight = value?["height"]
            let tempWeight = value?["weight"]
            let tempPersonalMessage = value?["personalMessage"]
            
            
			if let actualEmail = tempEmail {
				self.email = actualEmail as! String
			}
            
			if let actualUsername = tempUsername {
				self.username = actualUsername as! String
            }
            
			if let actualKilo = tempKilo {
				self.kilometres = actualKilo as! Double
			}
            
            if let actualHeight = tempHeight {
                self.height = actualHeight as! Double
            }
            
            if let actualWeight = tempWeight {
                self.weight = actualWeight as! Double
            }
            
            if let actualPersonalMessage = tempPersonalMessage {
                self.personalMessage = actualPersonalMessage as! String
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
    
    //beginning the editing process
    @IBAction func beginEditing(_ sender: UIButton) {
    
        canEditUserInfo = !(canEditUserInfo)//flips between editing and non editing state
        // print("canEditUserInfo is currently \(canEditUserInfo)")
        //change the text to let the user now that they tapped the button, maybe add more visual cues later
        if canEditUserInfo == true {
            sender.setTitle("DONE", for: .normal)
           // print("set titlelabel to  done")
        } else {
            sender.setTitle("EDIT", for: .normal)
            //print("set titlelabel to edit")
        }
        
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
