//
//  ExploreViewOneController.swift
//  AdventureSFU
//
//  Created by Chris Norris-Jones on 3/16/17.
//  Copyright © 2017 Karan Aujla. All rights reserved.
//

import UIKit

class ExploreViewOneController: UIViewController {

//Variables
    @IBOutlet weak var exploreItemLabel: UILabel!
    @IBOutlet weak var exploreHint: UITextView!

    
    var exploreTitle:String = ""
    var exploreText:String = ""
    var mapLat:Double = 0.0
    var mapLong:Double = 0.0
    var password:String = ""
    
//Functions
    
//Load Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exploreItemLabel.text = exploreTitle
        exploreHint.text = exploreText

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//Actions
    
    @IBAction func BackButton(){
        dismiss(animated: true, completion: nil)
    }
    
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
