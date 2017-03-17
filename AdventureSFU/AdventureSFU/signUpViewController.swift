//
//  signUpViewController.swift
//
//	AdventureSFU: Make Your Path
//	Created for SFU CMPT 276, Instructor Herbert H. Tsang, P.Eng., Ph.D.
//	AdventureSFU was a project created by Group 12 of CMPT 276
//
//  Created by Group 12 on 3/2/17.
//  Copyright © 2017 . All rights reserved.
//
//	signUpViewController - The signup screen that alows users to create their account
//	Programmers: Karan Aujla, Carlos Abaffy, Eleanor Lewis, Chris Norris-Jones
//
//	Known Bugs: None Currently
//	Todo:	-Integrate Further User Details into account creation
//			-Set up Team Create Page
//

import UIKit
import Firebase
 
class signUpViewController: UIViewController, UITextFieldDelegate {
	
//Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    //two fields for height, one for inches and one for feet
    @IBOutlet weak var feetHeightField: UITextField!
    @IBOutlet weak var inchesHeightField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var personalMessageField: UITextField!
    
//Variables
	var newUser: userProfile?
	var ref: FIRDatabaseReference?
    //set default values for the optional fields
    
    
	
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
	
    @IBAction func BackButton(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccount(){
        
        //set defualt values for the optional fields, in case the user didn't enter anything
        var validHeightFeet: Double = 0.0
        var validHeightInches: Double = 0.0
        var validWeight: Double = 0.0
        var validPersonalMessage = "Hi, I just joined"
        
        //create a generic alert for invalid optional values
        let invalidAlert = UIAlertController(title: "Invalid", message: "your __ was an invalid value,", preferredStyle: .alert)
        let invalidConfirmation = UIAlertAction(title: "ok", style: .default, handler: nil)
        invalidAlert.addAction(invalidConfirmation)
        //setting height
        //try to get the values from the feet height textfield
        if let enteredHeightFeet: Double = Double(feetHeightField.text!) {
            //make sure that the height the user entered was not negative
            if enteredHeightFeet >= 0 {
                //if the value works, overwrite the default value
                validHeightFeet = enteredHeightFeet
            } else {
                //if the feet value was negative, adjust the generic alert and display it
                invalidAlert.title = "invalid height"
                invalidAlert.message = "the feet you entered is invalid. Please try again"
                present(invalidAlert, animated: true, completion: nil)
                
                //then exit so the user can retry entering the values
                
                return
            }
        }
        //try to get the value from the inches height textfield
        if let enteredHeightInches: Double = Double(inchesHeightField.text!) {
            //if the value works, overwrite the default value
            validHeightInches = enteredHeightInches
        }
        //combine both the feet and inches values, and store it as feet
        var userHeight: Double = (validHeightFeet )  + (validHeightInches)/12
        
        //just here to stop xcode from complaining
        userHeight = userHeight + 0
        //REMOVE LATER
        
        
        //setting weight
        if let enteredWeight:Double = Double(weightField.text!) {
            validWeight = enteredWeight
        }
        if let enteredPersonalMessage: String = personalMessageField.text {
            validPersonalMessage = enteredPersonalMessage
        }
        
        //settting personal message
        
		//If not all fields entered in, give an alert error
		if self.userNameField.text == "" || self.emailField.text == "" || self.passwordField.text == "" {
			let alertController = UIAlertController(title: "Fields Missing!", message: "Please enter an email, username, and password!", preferredStyle: .alert)
			let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
			alertController.addAction(defaultAction)
			self.present(alertController, animated: true, completion: nil)
			
		} else {
			
			//Create a user account. If an error is thrown from firebase it will be displayed, otherwise the account should be created and on firebase
			FIRAuth.auth()?.createUser(withEmail: self.emailField.text!,
			                                    password: self.passwordField.text!,
			                                    completion: { (user, error) in
													if error == nil {
														//Account Created Successfully, enter in stats into database and return to ViewController
														
														self.ref?.child("Users").child(user!.uid).child("email").setValue(self.emailField.text)
														self.ref?.child("Users").child(user!.uid).child("username").setValue(self.userNameField.text)
														self.ref?.child("Users").child(user!.uid).child("KMRun").setValue(0.0)
														self.dismiss(animated: true, completion: nil)
														
														
													} else {
														//Account Creation Error, throw up warning and error reason
														let alertController = UIAlertController(title: "Account Creation Issue!", message: error?.localizedDescription, preferredStyle: .alert)
														let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
														alertController.addAction(defaultAction)
														self.present(alertController, animated: true, completion: nil)
													}
			})
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
}
