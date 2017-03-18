//
//  TeamSelectViewController.swift
//  AdventureSFU
//
//  Created by Carlos Abaffy paz on 3/16/17.
//  Copyright © 2017 Karan Aujla. All rights reserved.
//

import UIKit
import Firebase

class TeamSelectViewController : UIViewController {
    
    //Variables
//    var ref: FIRDatabaseReference?
//    let userID = FIRAuth.auth()?.currentUser?.uid
//    
//    
    //Functions
    
    //Load

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*ref = FIRDatabase.database().reference()
        
        let defaultWIPMessage = "If you select 'Back', you will be able to select a team on the Stats section later"
        
        
        let alert = UIAlertController(title: "Select your Team", message: defaultWIPMessage, preferredStyle: .alert)
        let alertConfirmation = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(alertConfirmation)
        self.present(alert, animated: true, completion: nil)*/
        
        
        
        
        /*ref?.child("Users").child(userID!).child("1stLogin").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? Bool
            let condition = value!
            let defaultWIPMessage = "If you select 'Back', you will be able to select a team on the Stats section later"
            
           
                let alert = UIAlertController(title: "Select your Team", message: defaultWIPMessage, preferredStyle: .alert)
                let alertConfirmation = UIAlertAction(title: "ok", style: .default, handler: nil)
                alert.addAction(alertConfirmation)
                self.present(alert, animated: true, completion: nil)
            
            
        })
*/
        

        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Actions
    
    
    /*@IBAction func backtoMain(){
        
        
        self.ref?.child("Users").child(userID!).child("1stLogin").setValue(false)
        
        performSegue(withIdentifier: "BacktoMain", sender: self)
        
        
    }
    
    @IBAction func eaglesSelect(){
        
        
        self.ref?.child("Users").child(userID!).child("Team").setValue("Eagles")
        self.ref?.child("Users").child(userID!).child("1stLogin").setValue(false)
        
        performSegue(withIdentifier: "BacktoMain", sender: self)
        
        
    }
    
    @IBAction func bobcatsSelect(){
        
        
        self.ref?.child("Users").child(userID!).child("Team").setValue("Bobcats")
        self.ref?.child("Users").child(userID!).child("1stLogin").setValue(false)
        
        performSegue(withIdentifier: "BacktoMain", sender: self)
        
        
    }

    @IBAction func bearsSelect(){
        
        
        self.ref?.child("Users").child(userID!).child("Team").setValue("Bears")
        self.ref?.child("Users").child(userID!).child("1stLogin").setValue(false)
        
        performSegue(withIdentifier: "BacktoMain", sender: self)
        
        
    }*/


    
  
}
