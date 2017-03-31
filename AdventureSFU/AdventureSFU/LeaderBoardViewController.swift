//
//  LeaderBoardViewController.swift
//  AdventureSFU
//
//  Created by Karan Aujla on 3/30/17.
//  Copyright © 2017 Karan Aujla. All rights reserved.
//

import UIKit
import Firebase

class LeaderBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref: FIRDatabaseReference?
    var team = "No Team"
    var  userCount = 1
    
    @IBOutlet weak var users: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref = FIRDatabase.database().reference()
        
        ref?.child("Users").child(userID!).child("Team").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? String
            print("team value is \(String(describing: value))")
            self.team = value!
            print("set team to \(self.team)")
            self.ref?.child("Teams").child(self.team).child("UserCount").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? Int
                print("value is \(String(describing: value))")
                self.userCount = value!
                print("set usercount to \(self.userCount)")
                self.users.reloadData()
            })
            self.users.reloadData()
        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellToBeReturned: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "users")!
        cellToBeReturned.textLabel?.text = "test"
        cellToBeReturned.detailTextLabel?.text = "testest"
        return cellToBeReturned
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        ref = FIRDatabase.database().reference()
        
        self.ref?.child("Teams").child(self.team).child("UserCount").observeSingleEvent(of: .value, with: { (snapshot) in
            let tempCount = snapshot.value as? Int
            
            if let userCount = tempCount {
                self.userCount = userCount
               
            }else{
                self.userCount = 1
            }
        
            self.users.reloadData()
        })
        return userCount
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
