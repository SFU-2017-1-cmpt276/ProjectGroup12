//
//  StatsViewController.swift
//  AdventureSFU
//
//  Created by Karan Aujla on 3/4/17.
//  Copyright © 2017 Karan Aujla. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var userInfo: UITableView!
    var testProfile = userProfile(enteredPassword: "testpass", enteredUsername: "testUSer", enteredEmail: "test@email.com")
    
   // var profileArray: [String] = [testProfile.username, testProfile.email]
    
    //for the table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // change this value when actually implementing it. for testing only
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celltoBeReturned: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "userInfo")!
        
        if indexPath.row == 0 {
            celltoBeReturned.textLabel?.text = "username"
            celltoBeReturned.detailTextLabel?.text = testProfile.username
            //celltoBeReturned.
        } else if indexPath.row == 1{
            celltoBeReturned.textLabel?.text = "email"
            celltoBeReturned.detailTextLabel?.text = testProfile.email
        
        }else{
            celltoBeReturned.textLabel?.text = "defualt for testing"
        }
        
        return celltoBeReturned
    }
    
      override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //return to the previous screen
    @IBAction func BackButton(){
        dismiss(animated: true, completion: nil)
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
