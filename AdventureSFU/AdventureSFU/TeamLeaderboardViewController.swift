//
//  TeamPageViewController.swift
//  AdventureSFU
//
//  Created by Carlos Abaffy paz on 3/28/17.
//  Copyright © 2017 Karan Aujla. All rights reserved.
//

import UIKit
import Firebase

class TeamLeaderboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var leaderboard: UITableView!
    
    
    //variables
    var userCount: Int = 2
    var ref: FIRDatabaseReference?
    var team: String = "No Team"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view Did Load")
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref = FIRDatabase.database().reference()
        
        ref?.child("Users").child(userID!).child("Team").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? String
            print("team value is \(value)")
            self.team = value!
            print("set team to \(self.team)")
            self.ref?.child("Teams").child(self.team).child("UserCount").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? Int
                print("value is \(value)")
                self.userCount = value!
                print("set usercount to \(self.userCount)")
                self.leaderboard.reloadData()
            })
            self.leaderboard.reloadData()
        })
        print("team is \(team)")
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("view Did appear")
        //make sure the user data is updated
        self.leaderboard.reloadData()
       
    }
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("userCount is \(userCount)")
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref = FIRDatabase.database().reference()

        self.ref?.child("Teams").child(self.team).child("UserCount").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? Int
            print("value is \(value)")
            self.userCount = value!
            print("set usercount to \(self.userCount)")
            self.leaderboard.reloadData()
        })
        print("returning \(userCount) rows")
        return userCount
        
    }
    
    //populate the leaderboard
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellToBeReturned: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "leaderboard")!
        if indexPath.row == 0 {
            cellToBeReturned.textLabel?.text = "team"
            cellToBeReturned.detailTextLabel?.text = team
        }else{
            cellToBeReturned.textLabel?.text = "test"
            cellToBeReturned.detailTextLabel?.text = "test"

        }
       
        return cellToBeReturned
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func BackToMain(_ sender: Any) {
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
