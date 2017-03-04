//
//  MainViewController.swift
//  AdventureSFU
//
//  Created by Karan Aujla on 3/3/17.
//  Copyright © 2017 Karan Aujla. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    var isLoggedIn = false
    let defaultWIPMessage = "this module is still in development, please comeback later"
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("the view loaded and login is is \(isLoggedIn)")
//        if isLoggedIn == false {
//            print("now loading the login in screen")
//            performSegue(withIdentifier: "login", sender: nil)
//        }
//
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Logout(){
        //do any tasks we need to do before someone logs out
        dismiss(animated: true, completion: nil)
        
    }
    
    //to be replaced with a segue to the run module
    @IBAction func RunModuleButton(){
            let alert = UIAlertController(title: "Error", message: defaultWIPMessage, preferredStyle: .alert)
            let alertConfirmation = UIAlertAction(title: "ok", style: .default, handler: nil)
            alert.addAction(alertConfirmation)
            present(alert, animated: true, completion: nil)
            print("the view loaded and login is is \(isLoggedIn)")

    }
    
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
    /*
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
