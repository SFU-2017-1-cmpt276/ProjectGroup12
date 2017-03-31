//
//  TeamSelect2.swift
//
//	AdventureSFU: Make Your Path
//	Created for SFU CMPT 276, Instructor Herbert H. Tsang, P.Eng., Ph.D.
//	AdventureSFU was a project created by Group 12 of CMPT 276
//
//  Created by Group 12 on 3/19/17.
//  Copyright © 2017 . All rights reserved.
//
//	TeamSelect2 - Displays on user's first time logging in, prompting them to join team
//	Programmers: Karan Aujla, Carlos Abaffy, Eleanor Lewis, Chris Norris-Jones
//
//	Known Bugs:
//	Todo:
//
//

import UIKit
import Firebase

class TeamSelect2: UIViewController {
    
    //Variables
    var ref: FIRDatabaseReference?
    var newUser: userProfile?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //If it is the user's first log in it displays an alert on how to select team
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref = FIRDatabase.database().reference()
        self.ref?.child("Users").child(userID!).child("firstLogin").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? Bool
            let condition = value!
            
            if(condition == true){
                self.makeAlert()
            
            }
            
        })
        
        
    }
    func updateUserCount(team: String){
        self.ref?.child("Teams").child(team).child("UserCount").observeSingleEvent(of: .value, with: { (snapshot) in
            let tempUserC = snapshot.value as? Int
            if var userC = tempUserC {
                
                userC += 1
                self.ref?.child("Teams").child(team).child("UserCount").setValue(userC)
            }
            
        })
    }
    
    //sends user back to previous page
    @IBAction func backtoMain(){
     
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        //lets the database and app know the user has logged in at least once and therefore been presented the team select page
        self.ref?.child("Users").child(userID!).child("firstLogin").setValue(false)

     
        dismiss(animated: true, completion: nil)
     
    }
     
     @IBAction func eaglesSelect(){
        
        //Selects team ealges
     
        let userID = FIRAuth.auth()?.currentUser?.uid
     
        self.ref?.child("Users").child(userID!).child("Team").setValue("Eagles")
        
        //lets the database and app know the user has logged in at least once and therefore been presented the team select page
        self.ref?.child("Users").child(userID!).child("firstLogin").setValue(false)
        
        self.ref?.child("Users").child(userID!).observe(FIRDataEventType.value, with: { (snapshot) in
            if let data = snapshot.value as? [String : AnyObject] {
                self.ref?.child("Teams").child("Eagles").child(userID!).setValue(data)
                
            }
        })
        updateUserCount(team: "Eagles")

        dismiss(animated: true, completion: nil)
     
     }
     
     @IBAction func bobcatsSelect(){
     
        //Selects team bobcat
     
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        self.ref?.child("Users").child(userID!).child("Team").setValue("Bobcats")
        
        //lets the database and app know the user has logged in at least once and therefore been presented the team select page
        self.ref?.child("Users").child(userID!).child("firstLogin").setValue(false)
        
        self.ref?.child("Users").child(userID!).observe(FIRDataEventType.value, with: { (snapshot) in
            if let data = snapshot.value as? [String : AnyObject] {
                self.ref?.child("Teams").child("Bobcats").child(userID!).setValue(data)
            }
        })
        
        updateUserCount(team: "Bobcats")

     
        dismiss(animated: true, completion: nil)
     
     }
     
     @IBAction func bearsSelect(){
      //Selects team Bear
        
        
    let userID = FIRAuth.auth()?.currentUser?.uid
     
     
        self.ref?.child("Users").child(userID!).child("Team").setValue("Bears")
        
        //lets the database and app know the user has logged in at least once and therefore been presented the team select page
        self.ref?.child("Users").child(userID!).child("firstLogin").setValue(false)
        
        self.ref?.child("Users").child(userID!).observe(FIRDataEventType.value, with: { (snapshot) in
            if let data = snapshot.value as? [String : AnyObject] {
                self.ref?.child("Teams").child("Bears").child(userID!).setValue(data)
            }
        })
        
        updateUserCount(team: "Bears")
     
        dismiss(animated: true, completion: nil)
     
     }
    
    func makeAlert()
    {
        
        let alert = UIAlertController(title: "Select your Team",
                                      message: "Choose from one of the three teams, if you wish to pick a team later you may do so from the Stats section",
                                      preferredStyle: .alert)
        
        let alertConfirmation = UIAlertAction(title: "ok", style: .default, handler: nil)
        
        alert.addAction(alertConfirmation)
        present(alert, animated: true, completion: nil)
        
        
    }
}







