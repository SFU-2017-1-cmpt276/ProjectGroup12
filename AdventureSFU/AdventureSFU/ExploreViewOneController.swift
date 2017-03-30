//
//  ExploreViewOneController.swift
//  AdventureSFU
//
//  Created by Chris Norris-Jones on 3/16/17.
//  Copyright © 2017 Karan Aujla. All rights reserved.
//

import UIKit
import Firebase

class ExploreViewOneController: UIViewController {

//Variables
    @IBOutlet weak var exploreItemLabel: UILabel!
    @IBOutlet weak var exploreHint: UITextView!

    
    var exploreTitle:String = ""
    var exploreText:String = ""
    var mapLat:Double = 0.0
    var mapLong:Double = 0.0
    var password:String = ""
    var row:Int = 0
    var ref: FIRDatabaseReference?
    let userID = FIRAuth.auth()?.currentUser?.uid
    
//Functions
    
//Load Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exploreItemLabel.text = exploreTitle
        exploreHint.text = exploreText
        ref = FIRDatabase.database().reference()

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//Actions
    
    @IBAction func BackButton(){
        dismiss(animated: true, completion: nil)
    }
    
    //Info alert displayed when info button hit
    @IBAction func InfoButton(){
        let infoAlert = UIAlertController(title: "Explore Page Details", message: "On this page you can see the general vicinity of the hidden item! If the map alone isn't enough, then maybe the helpful hint can also guide your way!", preferredStyle: .alert)
        let agreeAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        infoAlert.addAction(agreeAction)
        self.present(infoAlert, animated: true, completion: nil)
    }
    
    /*When Found button selected, an alert will display requesting confirmation that the item was actually found
    User can enter a password into the alert field, and upon hitting submit if the string is the correct password they
    will receive a congratulations message. If the string is incorrect then they will receive an incorrect message */
    @IBAction func FoundButton() {
        let passwordAlert = UIAlertController(title: "But Did You Really?", message: "If you did find the explore item, it should have a password within it. Please enter that password", preferredStyle: .alert)
        
        let congratsAlert = UIAlertController(title: "Congratulations!", message: "You really did find it!", preferredStyle: .alert)
        
        let tryAgainAlert = UIAlertController(title: "Incorrect Password", message: "Are you just guessing?", preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        congratsAlert.addAction(okayAction)
        tryAgainAlert.addAction(okayAction)
        
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) in
            let testField = passwordAlert.textFields![0]
            
            if testField.text == self.password {
                self.present(congratsAlert, animated: true, completion: nil)
                self.ref?.child("Users").child(self.userID!).child("ExploreItems").child(String(self.row)).setValue(1)
                passwordAlert.dismiss(animated: true, completion: nil)
            } else {
                self.present(tryAgainAlert, animated: true, completion: nil)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (cancel) in
            passwordAlert.dismiss(animated: true, completion: nil)
        })
        passwordAlert.addTextField(configurationHandler: {(passwordTextField) in
            passwordTextField.placeholder = "Enter Password Here"
        })
        passwordAlert.addAction(submitAction)
        passwordAlert.addAction(cancelAction)
            
        self.present(passwordAlert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embeddedExploreMap" {
       print("searchable explore test: exploreTitle = \(exploreTitle)")
            let childViewController = segue.destination as? ExploreMapUI
            childViewController?.mapLat = self.mapLat
            childViewController?.mapLong = self.mapLong
            childViewController?.exploreTitle = self.exploreTitle

            
            //Define self as delegate for embedded ActiveMapUI.
            //Define embedded ActiveMapUI as delegate for self.
            
        }
        
    }

}
