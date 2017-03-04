//
//  signUpViewController.swift
//  asd
//
//  Created by Karan Aujla on 3/2/17.
//  Copyright © 2017 Karan Aujla. All rights reserved.
//

import UIKit
 
class signUpViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func BackButton(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUp(){
        let newUser = userProfile(enteredPassword: passwordField.text!,
                                  enteredUsername: userNameField.text!,
                                  enteredEmail: emailField.text!)
        let userAlert = UIAlertController(title: "Congratuatuons",
                                          message: "you created a new profile named \(newUser.username)",
                                          preferredStyle: .alert)
        
        let confirmation = UIAlertAction(title: "ok", style: .default, handler: nil)
        userAlert.addAction(confirmation)
        present(userAlert, animated: true, completion: nil)
        
        //we should send the Info to the database here
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
