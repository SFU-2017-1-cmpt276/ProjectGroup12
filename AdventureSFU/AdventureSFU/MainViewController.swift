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
//	Todo:	-Set up Explore Module
//			-Improve UI, better display map
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
    
		let userID = FIRAuth.auth()?.currentUser?.uid
		ref = FIRDatabase.database().reference()
		
		ref?.child("Users").child(userID!).child("username").observeSingleEvent(of: .value, with: { (snapshot) in
			
			let value = snapshot.value as? String
			let username = value!
			
			self.welcomeUserLabel.text = "Welcome, \(username)!"

		})
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref = FIRDatabase.database().reference()
        
        ref?.child("Users").child(userID!).child("firstLogin").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? Bool
            let condition = value!
            print("\(condition)")
            if(condition == true) {
                self.performSegue(withIdentifier: "TeamSelect", sender: self)
            }
            
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


}
