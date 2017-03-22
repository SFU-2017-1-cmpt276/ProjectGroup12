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
//          -Separate editable and non-editable info into separate tables
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
    var team: String = "No Team"
    
    var canEditUserInfo: Bool = false //used to track if the user can edit their info
    var rowCount = 8
    
  //Functions
	
	//Create the Stats Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount// Change for number of rows in table
    }
	
    //Fill Stats Table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celltoBeReturned: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "userInfo")!
        
        if indexPath.row == 0 {
            celltoBeReturned.textLabel?.text = "Username"
            celltoBeReturned.detailTextLabel?.text = username
          
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
            
        }else if indexPath.row == 6{
            celltoBeReturned.textLabel?.text = "team"
            celltoBeReturned.detailTextLabel?.text = team
        } else{
            celltoBeReturned.textLabel?.text = ""
            celltoBeReturned.detailTextLabel?.text = ""

        }
        
        return celltoBeReturned
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //only allow the user info to be edited if the edit button has been tapped
        if canEditUserInfo == true {
            //create a generic error alert to be modified and presented when the user enters an invalid value
            let invalidAlert = UIAlertController(title: "error", message: "not valid", preferredStyle: .alert)
            let confirmAlert = UIAlertAction(title: "ok", style: .default, handler: nil)
            invalidAlert.addAction(confirmAlert)
            
            //if the username is selected
            if indexPath.row == 0 {
                //create an alert to change the username
                let changeUsernameAlert = UIAlertController(title: "new Username", message: "please enter your new username", preferredStyle: .alert)
                
                //the new username is inputed here
                changeUsernameAlert.addTextField(configurationHandler: nil)
                
                
                let confirmUsernameChange = UIAlertAction(title: "confirm", style: .default, handler: {(confirmUsernameChange) in
                    self.username = (changeUsernameAlert.textFields!.last?.text)!
                    //also change the username on firebase
                    self.ref?.child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).child("username").setValue(self.username)
                    self.userInfo.reloadData()
                    })
                changeUsernameAlert.addAction(confirmUsernameChange)
                
                let cancelUsernameChange = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
                changeUsernameAlert.addAction(cancelUsernameChange)
                
                present(changeUsernameAlert, animated: true)
            
            //if height is selected
            } else if indexPath.row == 3 {
               //force the user to enter in inches
                let changeHeight = UIAlertController(title: "new Height", message: "please enter your new height in inches", preferredStyle: .alert)
                
                //add a cancel button
                let cancelHeightChange = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
                changeHeight.addAction(cancelHeightChange)
                
                changeHeight.addTextField(configurationHandler: nil)
                
                let confirmHeightChange = UIAlertAction(title: "confirm", style: .default, handler: {(confirmChange) in
                    //only allow numbers
                    if let newHeight = Double((changeHeight.textFields?.last?.text!)!) {
                        //only allow postive heights
                        if newHeight > 0{
                            self.height = newHeight/12
                            //also change it on firebase
                            self.ref?.child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).child("height").setValue(self.height)
                            self.userInfo.reloadData()
                        } else {
                            invalidAlert.title = "Invalid Height"
                            invalidAlert.message = "please enter a value greater than 0"
                            self.present(invalidAlert, animated: true, completion: nil)
                        }
                    }
                    
                   
                })
                changeHeight.addAction(confirmHeightChange)
                
                //present the alert so the user can change their height
                present(changeHeight, animated: true, completion: nil)
            
                
            //if weight is chosen
            } else if indexPath.row == 4 {
                let changeWeight = UIAlertController(title: "change Weight", message: "please enter your new weight in pounds", preferredStyle: .alert)
                //add a textfield so the user can enter a value
                changeWeight.addTextField(configurationHandler: nil)
                
                //add a cancel button
                let cancelWeightChange = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
                changeWeight.addAction(cancelWeightChange)
                
                //add a confirm button
                let confirmWeightChange = UIAlertAction(title: "confirm", style: .default, handler: {(confirmWeightChange) in
                    // make sure the weight is a valid number
                    if let newWeight =  Double((changeWeight.textFields?.last?.text)!){
                        //only allow positive weights
                        if newWeight > 0{
                            self.weight = newWeight
                            self.ref?.child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).child("weight").setValue(self.weight)
                            self.userInfo.reloadData()
                        } else {
                            invalidAlert.title = "invalid weight"
                            invalidAlert.title = "please enter a weight greater than 0"
                            self.present(invalidAlert, animated: true, completion: nil)
                        }
                    }
                    
                   

                })
                changeWeight.addAction(confirmWeightChange)
                
                //present the alert
                present(changeWeight, animated: true, completion: nil)
            
            //if the personal message
            } else if indexPath.row == 5 {
                let changePersonalMessage = UIAlertController(title: "Change Message", message: "please enter your new personal Message", preferredStyle: .alert)
               
                changePersonalMessage.addTextField(configurationHandler: nil)
                
                let cancelMessageChange = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
                changePersonalMessage.addAction(cancelMessageChange)
                
                let confirmMessageChange = UIAlertAction(title: "confirm", style: .default, handler: {(confirmMessageChange) in
                    self.personalMessage = (changePersonalMessage.textFields?.last?.text!)!
                    
                    //change it on the data base
                    self.ref?.child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).child("personalMessage").setValue(self.personalMessage)
                    self.userInfo.reloadData()
                })
                changePersonalMessage.addAction(confirmMessageChange)
                
                present(changePersonalMessage, animated: true, completion: nil)
                
            //if teams were selected
            } else if indexPath.row == 6{
                print("teams selected, team is currently \(team)")
                //if there is no team, then let the user select one. 
                if team == "No Team" {
                    print("no team found going to team selectß")
                    // perform a segue to the teams page
                    performSegue(withIdentifier: "teamSelect", sender: self)
                }
            
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
            let tempTeam = value?["Team"]
            
            
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
            if let actualTeam = tempTeam {
                self.team = actualTeam as! String
            }
            
			self.userInfo.reloadData()
			
		})
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //make sure the user data is updated
        self.userInfo.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
          }
    
//Actions
    //return to the previous screen
    @IBAction func BackButton(){
        dismiss(animated: true, completion: nil)
    }
    
    //presents a button with a explanation on how to use stats page
    @IBAction func infoButton() {
        let infoAlert = UIAlertController(title: "Information", message: "this page displays all tracked stats. You can edit your info such as height, weight, username, and personal message by tapping the edit button and then the info you would like to edit. tap done to finish editing. You can also choose a team if you did not early. Simple tap edit and then tap the team row. this will take you the team sign up page", preferredStyle: .alert)
        let infoConfirm = UIAlertAction(title: "ok", style: .default, handler: nil)
        infoAlert.addAction(infoConfirm)
        present(infoAlert, animated: true, completion: nil)
        
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

}
