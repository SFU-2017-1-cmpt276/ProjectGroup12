//
//  ViewController.swift
//
//	AdventureSFU: Make Your Path
//	Created for SFU CMPT 276, Instructor Herbert H. Tsang, P.Eng., Ph.D.
//	AdventureSFU was a project created by Group 12 of CMPT 276
//
//  Created by Group 12 on 3/2/17.
//  Copyright © 2017 . All rights reserved.
//
//	ViewController - The login screen, that allows users to login and go to the MainView or signUpView storyboards
//	Programmers: Karan Aujla, Carlos Abaffy, Eleanor Lewis, Chris Norris-Jones
//
//	Known Bugs: -Keyboard in simulator changes look from email to password
//	Todo:	
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {
	
//Outlets
	@IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    // @IBOutlet weak var nextScreen: UIViewController!
    
//Variables
	var enteredEmail: String?
	var enteredPassword: String?
	var ref:FIRDatabaseReference?

//Functions
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return false
	}
	
//Load Actions
    override func viewDidLoad() {
        super.viewDidLoad()
		
		ref = FIRDatabase.database().reference()
		
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
//Actions
	
	@IBAction func loginAction(_ sender: AnyObject) {
		//If fields aren't entered, throw a warning
		if self.emailField.text == "" || self.passwordField.text == "" {
			let alertController = UIAlertController(title: "Fields Missing!", message: "To login please enter your username and password!", preferredStyle: .alert)
			let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
			alertController.addAction(defaultAction)
			self.present(alertController, animated: true, completion: nil)
		} else {
			//Log into authentication system, sign in user
			FIRAuth.auth()?.signIn(withEmail: self.emailField.text!,
			                       password: self.passwordField.text!,
			                       completion: { (user, error) in
									if error == nil {
										self.performSegue(withIdentifier: "goToMain", sender: self)
									} else {
										//If error in login or incorrect info, throw error and error reason
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
