//
//  TeamSelect2.swift
//  AdventureSFU
//
//  Created by Carlos Abaffy paz on 3/17/17.
//  Copyright © 2017 Karan Aujla. All rights reserved.
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
     

        dismiss(animated: true, completion: nil)
     
     }
     
     @IBAction func bobcatsSelect(){
     
        //Selects team bobcat
     
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        self.ref?.child("Users").child(userID!).child("Team").setValue("Bobcats")
        
        //lets the database and app know the user has logged in at least once and therefore been presented the team select page
        self.ref?.child("Users").child(userID!).child("firstLogin").setValue(false)
        
        

     
        dismiss(animated: true, completion: nil)
     
     }
     
     @IBAction func bearsSelect(){
      //Selects team Bear
        
        
    let userID = FIRAuth.auth()?.currentUser?.uid
     
     
        self.ref?.child("Users").child(userID!).child("Team").setValue("Bears")
        
        //lets the database and app know the user has logged in at least once and therefore been presented the team select page
        self.ref?.child("Users").child(userID!).child("firstLogin").setValue(false)
        
        
     
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







