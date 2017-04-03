//
//  MainViewController.swift
//
//	AdventureSFU: Make Your Path
//	Created for SFU CMPT 276, Instructor Herbert H. Tsang, P.Eng., Ph.D.
//	AdventureSFU was a project created by Group 12 of CMPT 276
//
//  Created by Group 12 on 3/2/17.
//  Copyright © 2017 . All rights reserved.
//
//	MainViewController - The Main screen, that allows users to go to the various application modules
//	Programmers: Karan Aujla, Carlos Abaffy, Eleanor Lewis, Chris Norris-Jones
//
//	Known Bugs:
//	Todo:
//		
//
import UIKit
import Firebase

class MainViewController: UIViewController {
    
    //Variables
    
    var ref: FIRDatabaseReference?
    //var databaseHandle: FIRDatabaseHandle?
    
    @IBOutlet weak var welcomeUserLabel: UILabel!
    let defaultWIPMessage = "This module is still in development!"
    
    
    //Functions
    //Load Actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // get the uid for the logged in user
        let userID = FIRAuth.auth()?.currentUser?.uid
        GlobalVariables.sharedManager.userID = userID
        //and get a reference to the database
        ref = FIRDatabase.database().reference()
        GlobalVariables.sharedManager.ref = ref
        ref?.child("Users").child(userID!).child("firstLogin").observeSingleEvent(of: .value, with: { (snapshot) in
            //if it is the first time the user logged in, present the team select page
            let value = snapshot.value as? Bool
            let condition = value!
            if(condition == true) {
                self.performSegue(withIdentifier: "TeamSelect", sender: self)
            }
            
        })
        
        ref?.child("Users").child(userID!).child("username").observeSingleEvent(of: .value, with: { (snapshot) in
            //pull the user's name and display a welcome message
            let value = snapshot.value as? String
            let username = value!
            
            self.welcomeUserLabel.text = "Welcome, \(username)!"
            
        })

        ref?.child("Users").child(userID!).child("weight").observeSingleEvent(of: .value, with: { (snapshot) in
            //pull the user's weight
            let value = snapshot.value as? Double
            let weight = value!
            
            GlobalVariables.sharedManager.weight = weight
            
        }) //loading this variable now to reduce delay when calories burned is calculated
     
        ref?.child("Users").child(userID!).child("totalSeconds").observeSingleEvent(of: .value, with: { (snapshot) in
            //pull the user's name and display a welcome message
            let timevalue = snapshot.value as? Double
            let time = timevalue!
            self.ref?.child("Users").child(userID!).child("KMRun").observeSingleEvent(of: .value, with: { (snapshot) in
                //pull the user's name and display a welcome message
                let distancevalue = snapshot.value as? Double
                let distance = distancevalue!
            
                if (distance > 0.0 && time > 0.0) {
                    let avgSpeed = distance / (Double(time / 3600.0))
                    if (avgSpeed > 0.0) {
                        GlobalVariables.sharedManager.avgSpeed = avgSpeed
                    }
                }

                //Updates the time stat of the planned route with the user's average speed if initialized or the Mapbox time estimate.
            })
        })//loading to prevent conflicts due to asynchronicity in firebase methods in planned route time estimation
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Actions
    
    @IBAction func logoutAction(){
        //Call to firebase to logout, then move back to ViewController
        try! FIRAuth.auth()?.signOut()
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func toStatsPage() {
        performSegue(withIdentifier: "mainToStats", sender: self)
    }
    
    @IBAction func toRunControllerPage() {
        performSegue(withIdentifier: "mainToRunController", sender: self)
    }
    
    @IBAction func toExploreControllerPage() {
        performSegue(withIdentifier: "mainToExplore", sender: self)
    }
    
    @IBAction func toTeamsPage() {
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        ref?.child("Users").child(userID!).child("Team").observeSingleEvent(of: .value, with: { (snapshot) in
            //pull the user's name and display a welcome message
            let value = snapshot.value as? String
            let team = value!
            
            if team == "No Team" {
                let alert = UIAlertController(title: "You are not in a Team",
                                              message: "Team Stats are only available for those who are in a team. If you wish access Team Stats, select a team from the Stats page.",
                                              preferredStyle: .alert)
                
                let alertConfirmation = UIAlertAction(title: "ok", style: .default, handler: nil)
                
                alert.addAction(alertConfirmation)
                self.present(alert, animated: true, completion: nil)
            }
            
            else {
                self.performSegue(withIdentifier: "toTeams", sender: self)
            }
            
        })
    }
    
    
}
