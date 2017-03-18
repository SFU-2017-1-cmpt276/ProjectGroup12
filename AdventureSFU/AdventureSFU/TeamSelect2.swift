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
    let userID = FIRAuth.auth()?.currentUser?.uid


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backtoMain(){
     
     
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
     
     
     }
}
