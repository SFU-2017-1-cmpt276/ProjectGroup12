//
//  LeaderBoardViewController.swift
//  AdventureSFU
//	Created for SFU CMPT 276, Instructor Herbert H. Tsang, P.Eng., Ph.D.
//	AdventureSFU was a project created by Group 12 of CMPT 276
//

//  Created by Group 12 on 3/30/17.
//  Copyright © 2017 . All rights reserved.
//
//	AdventureSFU: Make Your Path
//	Created for SFU CMPT 276, Instructor Herbert H. Tsang, P.Eng., Ph.D.
//	AdventureSFU was a project created by Group 12 of CMPT 276
//
//	Displays leaderboard of team members.
//	Programmers: Karan Aujla, Carlos Abaffy, Eleanor Lewis, Chris Norris-Jones
//
//	Known Bugs:
//	Todo:
//
import UIKit
import Firebase

class LeaderBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //Variables
    var ref: FIRDatabaseReference?
    var team = "No Team"
    var userCount = 0
    var userKeys = [String]()
    var kmValues = [Double]()
    var timeValues = [Double]()
    var usersPopulated = false
    var sortByDistance = true

    //create a struct to contain the users
    struct userStats {
        var kmRun: Double
        var timeRun: Double
        var username: String
        var userID: String
        var personalMessage: String
    }

    struct  userLeaderboard {
        var userArray = [userStats]()

        mutating func sortByTime(){
            if userArray.count <= 1{
                return
            }
            for index in 0...userArray.count - 2 {
                for innerIndex in index + 1...userArray.count - 1{
                    if userArray[innerIndex].timeRun  > userArray[index].timeRun {
                        let tempUserStat = userArray[innerIndex]
                        userArray[innerIndex] = userArray[index]
                        userArray[index] = tempUserStat
                    }
                }
            }

            
        }
        mutating func sortbyDistance(){
            if userArray.count <= 1{
                return
            }
            for index in 0...userArray.count - 2 {
                for innerIndex in index + 1...userArray.count - 1{
                    if userArray[innerIndex].kmRun   > userArray[index].kmRun {
                        let tempUserStat = userArray[innerIndex]
                        userArray[innerIndex] = userArray[index]
                        userArray[index] = tempUserStat
                    }
                }
            }
        }
    }
    
    var teamLeaderboard = userLeaderboard(userArray: [])
    @IBOutlet weak var users: UITableView!
    @IBOutlet weak var TeamTitle: UITextField!
    
    //Load & Appear Actions
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        teamLeaderboard.sortbyDistance()
        self.users.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref = FIRDatabase.database().reference()
        ref?.child("Users").child(userID!).child("Team").observeSingleEvent(of: .value, with: { (snapshot) in
            //get what team the user is part of so we can get the correct data from firbase
            let value = snapshot.value as? String

            self.team = value!
            //display the team name on the page
            self.TeamTitle.text = "Team " + self.team

            self.ref?.child("Teams").child(self.team).observeSingleEvent(of: .value, with: { snapshot in
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                    if rest.hasChildren(){
                        self.userKeys.append(rest.key)
                        //if a user was added update usercount
                        self.userCount += 1
                    }
                }
                for user in self.userKeys {
                        //create the userStats struct to store data
                    var newUser = userStats(kmRun: -1, timeRun: -1, username: "empty", userID: user, personalMessage: "")
                
                        self.ref?.child("Users").child(user).observeSingleEvent(of: .value, with: { snapshot in
                            let info = snapshot.value as? NSDictionary

                            let tempUsername = info?["username"]
                            let tempKM = info?["KMRun"]
                            let tempTime = info?["totalSeconds"]
                            let tempMessage = info?["personalMessage"]

                            if tempUsername != nil{
                                newUser.username = tempUsername as! String
                            }
                            if tempKM != nil{
                                newUser.kmRun = tempKM as! Double
                            }
                            if tempTime != nil{
                                newUser.timeRun = tempTime as! Double
                            }

                            
                            if let validMessage: String =  tempMessage as? String {
                
                                newUser.personalMessage = validMessage
                                
                            }else{
                                //a placeholder message if it can't be cast into a string
                                newUser.personalMessage = "can not retrieve message at this time"
                            }
                            
                            //once the user is filled out, add it to the teamleaderboard
                            self.teamLeaderboard.userArray.append(newUser)
                    })
                }
                
                self.usersPopulated = true
                })

            self.users.reloadData()
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Functions
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellToBeReturned: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "users")!
        ref = FIRDatabase.database().reference()
      
        if usersPopulated{
            
            if sortByDistance {
                teamLeaderboard.sortbyDistance()
                
                cellToBeReturned.textLabel?.text = teamLeaderboard.userArray[indexPath.row].username
                cellToBeReturned.detailTextLabel?.text = "\(String(format: "%.2f", teamLeaderboard.userArray[indexPath.row].kmRun )) Km"
            }

            else {
                
                teamLeaderboard.sortByTime()
                cellToBeReturned.textLabel?.text = teamLeaderboard.userArray[indexPath.row].username

                var seconds: Int = Int(teamLeaderboard.userArray[indexPath.row].timeRun)
                
                var minutes: Int = seconds / 60
                
                let hours: Int = minutes / 60
                seconds -= minutes * 60
                minutes -= hours * 60

                cellToBeReturned.detailTextLabel?.text =  String(format: "H:M:S %d:%.2d:%.2d", hours, minutes, seconds)

            }
        }
        return cellToBeReturned
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return userCount
    }
    
    //when the user selects a cell, display that users personal message
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedUser = teamLeaderboard.userArray[indexPath.row]
        let messageAlert = UIAlertController(title: "\(selectedUser.username) says:", message: selectedUser.personalMessage, preferredStyle: .alert)
        let confirmMessage = UIAlertAction(title: "ok", style: .default, handler: nil)
        messageAlert.addAction(confirmMessage)
        present(messageAlert, animated: true, completion: nil)
    }
    
    //Actions
    
    @IBAction func BackButton(){
        dismiss(animated: true, completion: nil)
    }
    @IBAction func ToAllTeams(_ sender: UIButton) {
        performSegue(withIdentifier: "toAllTeams", sender: self )
    }
    
    @IBAction func SwitchOrder(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            sortByDistance = false
            teamLeaderboard.sortByTime()
            self.users.reloadData()
        }
        else{
            sortByDistance = true
            teamLeaderboard.sortbyDistance()
            self.users.reloadData()
        }
    }
    

}
