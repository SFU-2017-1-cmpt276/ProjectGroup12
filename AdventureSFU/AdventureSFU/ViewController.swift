//
//  ViewController.swift
//
//
//  Created by Karan Aujla on 3/2/17.
//  Copyright © 2017 Group12. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
   	
	//variables
    var enteredEmail: String?
    var enteredPassword: String?
	
	var ref:FIRDatabaseReference?
	
	//outlets
	@IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    // @IBOutlet weak var nextScreen: UIViewController!
    

    //Run on Viewcontroller load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundColour

		
		ref = FIRDatabase.database().reference()
		
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
    //Actions
   
	
	@IBAction func loginAction(_ sender: AnyObject) {
		if self.emailField.text == "" || self.passwordField.text == "" {
			let alertController = UIAlertController(title: "Fields Missing!", message: "To login please enter your username and password!", preferredStyle: .alert)
			let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
			alertController.addAction(defaultAction)
			self.present(alertController, animated: true, completion: nil)
		} else {
			FIRAuth.auth()?.signIn(withEmail: self.emailField.text!,
			                       password: self.passwordField.text!,
			                       completion: { (user, error) in
									if error == nil {
										self.performSegue(withIdentifier: "goToMain", sender: self)
									} else {
										//Login error
										let alertController = UIAlertController(title: "Login Failed!", message: error?.localizedDescription, preferredStyle: .alert)
										let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
										alertController.addAction(defaultAction)
										self.present(alertController, animated: true, completion: nil)
									}
									})
		}
	}
	
	@IBAction func createAccount() {
		performSegue(withIdentifier: "signInToAccountCreation", sender: self)
	}
	
}
