//
//  MainViewController.swift
//  AdventureSFU
//
//  Created by Karan Aujla on 3/3/17.
//  Copyright © 2017 Karan Aujla. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {
	
	//variables/Outlets
	
	var ref: FIRDatabaseReference?
	var databaseHandle: FIRDatabaseHandle?
	
	@IBOutlet weak var welcomeUserLabel: UILabel!
    let defaultWIPMessage = "this module is still in development, please comeback later"
	
	//Load Functions
	
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	//Actions
	
    @IBAction func logoutAction(){
        //do any tasks we need to do before someone logs out
		try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "logOut", sender: self)
        
    }
    
    //to be replaced with a segue to the run module
    /*@IBAction func RunModuleButton(){
            let alert = UIAlertController(title: "Error", message: defaultWIPMessage, preferredStyle: .alert)
            let alertConfirmation = UIAlertAction(title: "ok", style: .default, handler: nil)
            alert.addAction(alertConfirmation)
            present(alert, animated: true, completion: nil)
            print("the view loaded and login is is \(isLoggedIn)")

    }
    */
    @IBAction func ExploreModuleButton(){
        let alert = UIAlertController(title: "Error", message: defaultWIPMessage, preferredStyle: .alert)
        let alertConfirmation = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(alertConfirmation)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func StatsModuleButton(){
        let alert = UIAlertController(title: "Error", message: defaultWIPMessage, preferredStyle: .alert)
        let alertConfirmation = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        alert.addAction(alertConfirmation)
        present(alert, animated: true, completion: nil)
    }
	
	@IBAction func toStatsPage() {
		performSegue(withIdentifier: "mainToStats", sender: self)
	}
	
	@IBAction func toRunControllerPage() {
		performSegue(withIdentifier: "mainToRunController", sender: self)
	}
    /*
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
