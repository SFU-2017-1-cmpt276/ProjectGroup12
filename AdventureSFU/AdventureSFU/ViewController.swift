//
//  ViewController.swift
//  asd
//
//  Created by Karan Aujla on 3/2/17.
//  Copyright © 2017 Karan Aujla. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var enteredUsername: String?
    var enteredPassword: String?
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    // @IBOutlet weak var nextScreen: UIViewController!
    
    @IBAction func validateInput() {
        enteredUsername =  userNameField.text
        enteredPassword = passwordField.text
        //validate the username and password later
        if enteredUsername!.isEmpty != true {
            //            let successfulLogin =  UIStoryboardSegue(identifier: nil, source: self, destination: nextScreen)
            //            successfulLogin.perform()
            performSegue(withIdentifier: "login", sender: nil)
            //dismiss(animated: true, completion: nil)
            
        } else {
            let incorect = UIAlertController(title: "incorrect", message: "incorrect", preferredStyle: .alert)
            let confirmation = UIAlertAction(title: "ok", style: .default, handler: nil)
            incorect.addAction(confirmation)
            present(incorect, animated: true, completion: nil)
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
