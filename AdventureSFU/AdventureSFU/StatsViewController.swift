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
//	Todo:	
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

    var totalTimeInSeconds: Double = 0.0
    var totalTimeInHours: Double = 0.0
    var averageSpeed: Double = 0.0
    var totalCaloriesBurned: Double = 0.0
    var timeRun: Double = 0.0

    var canEditUserInfo: Bool = false //used to track if the user can edit their info
    var rowCount = 11
    
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
        }
        else if indexPath.row == 1{
			celltoBeReturned.textLabel?.text = "Email"
            celltoBeReturned.detailTextLabel?.text = email
		}
        else if indexPath.row == 2{
            celltoBeReturned.textLabel?.text = "Personal message"
            celltoBeReturned.detailTextLabel?.text = personalMessage
		}
        else if indexPath.row == 3{
            celltoBeReturned.textLabel?.text = "Team"
            celltoBeReturned.detailTextLabel?.text = team
        }
        else if indexPath.row == 4{
            celltoBeReturned.textLabel?.text = "Km Run"
            celltoBeReturned.detailTextLabel?.text = String(format: "%.2f", kilometres)
        }
        else if indexPath.row == 5{
            celltoBeReturned.textLabel?.text = "Total time run (H:M:S)"
            let seconds: Int = Int(totalTimeInSeconds) % 60;
            let minutes: Int = Int(totalTimeInSeconds / 60) % 60;
            let hours: Int = Int(totalTimeInSeconds / 3600);
            celltoBeReturned.detailTextLabel?.text = String(format: "H:M:S: %d:%.2d:%.2d", hours, minutes, seconds)
        }
        else if indexPath.row == 6{celltoBeReturned.textLabel?.text = "Average Speed"
            var averageSpeed: Double = 0.0
            if (kilometres > 0) {
                averageSpeed = kilometres / totalTimeInHours
            } else {
                averageSpeed = 0.0
            }
            celltoBeReturned.detailTextLabel?.text = String(format: "%.2f km/h", averageSpeed)
        }
        else if indexPath.row == 7{
            celltoBeReturned.textLabel?.text = "Height"
            let heightInInches: Int = Int(round(height * 12)) % 12
            let heightInFeet: Int = Int(height)
            celltoBeReturned.detailTextLabel?.text = "\(heightInFeet) ft. \(heightInInches) In. "
        }
        else if indexPath.row == 8{
            celltoBeReturned.textLabel?.text = "Weight"
            celltoBeReturned.detailTextLabel?.text = " \(String(format: "%.1f", weight)) lbs"
        }
        else if indexPath.row == 9{
            celltoBeReturned.textLabel?.text = "Total calories burned"
            if (self.height>0 && self.weight>0) {
                celltoBeReturned.detailTextLabel?.text = String(format: "%.2f", totalCaloriesBurned)
            }else {
                celltoBeReturned.detailTextLabel?.text = "0 counted"
            }
        }
        else{
            celltoBeReturned.textLabel?.text = ""
            celltoBeReturned.detailTextLabel?.text = ""
        }
        return celltoBeReturned //Loads cells with their info
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //only allow the user info to be edited if the edit button has been tapped
        if canEditUserInfo == true {
            //create a generic error alert to be modified and presented when the user enters an invalid value
            let invalidAlert = UIAlertController(title: "Error", message: "Not valid", preferredStyle: .alert)
            let confirmAlert = UIAlertAction(title: "ok", style: .default, handler: nil)
            invalidAlert.addAction(confirmAlert)
            
            //if the username is selected
            if indexPath.row == 0 {
                //create an alert to change the username
                let changeUsernameAlert = UIAlertController(title: "New Username", message: "Please enter your new username", preferredStyle: .alert)
                
                //the new username is inputed here
                changeUsernameAlert.addTextField(configurationHandler: nil)

                let confirmUsernameChange = UIAlertAction(title: "Confirm", style: .default, handler: {[unowned self] (confirmUsernameChange) in
                    self.username = (changeUsernameAlert.textFields!.last?.text)!
                    //also change the username on firebase
                    self.ref?.child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).child("username").setValue(self.username)
                    self.userInfo.reloadData()
                })
                changeUsernameAlert.addAction(confirmUsernameChange)
                
                let cancelUsernameChange = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                changeUsernameAlert.addAction(cancelUsernameChange)
                
                present(changeUsernameAlert, animated: true)
            
            //if height is selected
            } else if indexPath.row == 7 {
               //force the user to enter in inches
                let changeHeight = UIAlertController(title: "New Height", message: "Please enter your new height in inches", preferredStyle: .alert)
                
                //add a cancel button
                let cancelHeightChange = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                changeHeight.addAction(cancelHeightChange)
                
                changeHeight.addTextField(configurationHandler: nil)
                
                let confirmHeightChange = UIAlertAction(title: "Confirm", style: .default, handler: {[unowned self] (confirmChange) in
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
                            invalidAlert.message = "Please enter a value greater than 0"
                            self.present(invalidAlert, animated: true, completion: nil)
                        }
                    }
                })
                changeHeight.addAction(confirmHeightChange)
                
                //present the alert so the user can change their height
                present(changeHeight, animated: true, completion: nil)
            
                
            //if weight is chosen
            } else if indexPath.row == 8 {
                let changeWeight = UIAlertController(title: "Change Weight", message: "Please enter your new weight in pounds", preferredStyle: .alert)
                //add a textfield so the user can enter a value
                changeWeight.addTextField(configurationHandler: nil)
                
                //add a cancel button
                let cancelWeightChange = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                changeWeight.addAction(cancelWeightChange)
                
                //add a confirm button
                let confirmWeightChange = UIAlertAction(title: "Confirm", style: .default, handler: {(confirmWeightChange) in
                    // make sure the weight is a valid number
                    if let newWeight =  Double((changeWeight.textFields?.last?.text)!){
                        //only allow positive weights
                        if newWeight > 0{
                            self.weight = newWeight
                            self.ref?.child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).child("weight").setValue(self.weight)
                            self.userInfo.reloadData()
                        } else {
                            invalidAlert.title = "Invalid weight"
                            invalidAlert.title = "Please enter a weight greater than 0"
                            self.present(invalidAlert, animated: true, completion: nil)
                        }
                    }
                })
                changeWeight.addAction(confirmWeightChange)
                
                //present the alert
                present(changeWeight, animated: true, completion: nil)
            
            //if the personal message
            } else if indexPath.row == 2 {
                let changePersonalMessage = UIAlertController(title: "Change Message", message: "Please enter your new personal Message", preferredStyle: .alert)
               
                changePersonalMessage.addTextField(configurationHandler: nil)
                
                let cancelMessageChange = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                changePersonalMessage.addAction(cancelMessageChange)
                
                let confirmMessageChange = UIAlertAction(title: "Confirm", style: .default, handler: {[unowned self] (confirmMessageChange) in
                    self.personalMessage = (changePersonalMessage.textFields?.last?.text!)!
                    
                    //change it on the data base
                    self.ref?.child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).child("personalMessage").setValue(self.personalMessage)
                    self.userInfo.reloadData()
                })
                changePersonalMessage.addAction(confirmMessageChange)
                present(changePersonalMessage, animated: true, completion: nil)
                
            //if teams were selected
            } else if indexPath.row == 6{
                //if there is no team, then let the user select one. 
                if team == "No Team" {
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
		
		ref?.child("Users").child(userID!).observeSingleEvent(of: .value, with: {[unowned self] (snapshot) in
			
			let value = snapshot.value as? NSDictionary
			
			let tempEmail = value?["email"]
			let tempUsername = value?["username"]
			let tempKilo = value?["KMRun"]
            let tempHeight = value?["height"]
            let tempWeight = value?["weight"]
            let tempPersonalMessage = value?["personalMessage"]
            let tempTeam = value?["Team"]
            let tempTime = value?["totalSeconds"]
            let tempCalories = value?["TotalCalories"]
            
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
            if let actualTime = tempTime {
                self.totalTimeInSeconds = actualTime as! Double
                self.totalTimeInHours = self.totalTimeInSeconds / 3600
            }
            if let actualCalories = tempCalories {
                self.totalCaloriesBurned = actualCalories as! Double
            }
			self.userInfo.reloadData()
			
		}) //Load page and get info from Firebase
    }
    
    //make sure the user data is updated
    override func viewDidAppear(_ animated: Bool) {
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
        let msg = "This page displays all tracked stats. You can edit info such as height, weight, username, and personal message by tapping the edit button and then the info you would like to edit. Tap done to finish editing. You can also choose a team if you did not do so earlier. Simply tap edit and then tap the team row. This will take you the team sign up page. \n" + "\n" + "To track calories burned, weight must be entered. The formula used is cals = 0.0175 x weight in kilos x M.E.T. x minutes of activity. An M.E.T. of 6 is assumed. Actual calories burned may vary widely. Formula and M.E.T. source: https://www.hss.edu/conditions_burning-calories-with-exercise-calculating-estimated-energy-expenditure.asp"
        let infoAlert = UIAlertController(title: "Information", message: msg, preferredStyle: .alert)
        let infoConfirm = UIAlertAction(title: "ok", style: .default, handler: nil)
        infoAlert.addAction(infoConfirm)
        present(infoAlert, animated: true, completion: nil)
    }
    
    //beginning the editing process
    @IBAction func beginEditing(_ sender: UIButton) {
        canEditUserInfo = !(canEditUserInfo)//flips between editing and non editing state
        //change the text to let the user now that they tapped the button
        if canEditUserInfo == true {
            sender.setTitle("DONE", for: .normal)
        } else {
            sender.setTitle("EDIT", for: .normal)
        }
    }
}
