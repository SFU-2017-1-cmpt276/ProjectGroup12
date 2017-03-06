//
//  signUpViewController.swift
//  asd
//
//  Created by Karan Aujla on 3/2/17.
//  Copyright © 2017 Karan Aujla. All rights reserved.
//

import UIKit
import Firebase
 
class signUpViewController: UIViewController {
	
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
	
	var newUser: userProfile?
	
	var ref: FIRDatabaseReference?
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		ref = FIRDatabase.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func BackButton(){
        dismiss(animated: true, completion: nil)
    }
    
   

    @IBAction func createAccount(){
		
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
														//Account Created Succesffuly, return to login page
														
														self.ref?.child("Users").child(user!.uid).child("email").setValue(self.emailField.text)
														self.ref?.child("Users").child(user!.uid).child("username").setValue(self.userNameField.text)
														self.ref?.child("Users").child(user!.uid).child("KM run").setValue(0)
														self.dismiss(animated: true, completion: nil)
														
														
													} else {
														//Account Creation Error
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
