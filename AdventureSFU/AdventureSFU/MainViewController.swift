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
            
        })
        ref?.child("Users").child(userID!).child("height").observeSingleEvent(of: .value, with: { (snapshot) in
            //pull the user's height
            let value = snapshot.value as? Double
            let height = value!
            
            GlobalVariables.sharedManager.height = height
            
        })
        
 
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Actions
    
    @IBAction func logoutAction(){
        //Call to firebase to logout, then move back to ViewController
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "logOut", sender: self)
        
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
        print("about to perform segue to teams")
        performSegue(withIdentifier: "toTeams", sender: self)
    }
   

    
    
}
