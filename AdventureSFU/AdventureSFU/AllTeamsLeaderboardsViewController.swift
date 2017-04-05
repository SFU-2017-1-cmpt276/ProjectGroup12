//
//  AllTeamsLeaderboardsViewController.swift
//  AdventureSFU
//
//  Created by Group 12 on 4/2/17.
//  Copyright © 2017 . All rights reserved.
//
//	AdventureSFU: Make Your Path
//	Created for SFU CMPT 276, Instructor Herbert H. Tsang, P.Eng., Ph.D.
//	AdventureSFU was a project created by Group 12 of CMPT 276
//
//	Displays leaderboard of teams.
//	Programmers: Karan Aujla, Carlos Abaffy, Eleanor Lewis, Chris Norris-Jones
//
//	Known Bugs:
//	Todo:
//
import UIKit
import Firebase

class AllTeamsLeaderboardsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Variables
    
    var ref: FIRDatabaseReference?
    var teamsPopulated = false
    var sortByDistance = true
    var distance = 0.0
    var time = 0.0
    var Bearpopulator = [Double]()
    var Bobcatpopulator = [Double]()
    var Eaglepopulator = [Double]()

    @IBOutlet weak var TeamTable: UITableView!
    @IBOutlet weak var bestTeam: UITextField!
    
    //struct to contain teams
    struct teamStats {
        var kmRun: Double
        var timeRun: Double
        var teamName: String
    }
    
    //struct to hold the values for the UItable
    struct  teamLeaderboard {
        var teamArray = [teamStats]()
        
        mutating func sortByTime(){
           
            for index in 0...teamArray.count - 2 {
                for innerIndex in index + 1...teamArray.count - 1{
                    if teamArray[innerIndex].timeRun  > teamArray[index].timeRun {
                        let tempUserStat = teamArray[innerIndex]
                        teamArray[innerIndex] = teamArray[index]
                        teamArray[index] = tempUserStat
                    }
                }
            }
            
        }
        
        mutating func sortbyDistance(){
          
            for index in 0...teamArray.count - 2 {
                for innerIndex in index + 1...teamArray.count - 1{
                    if teamArray[innerIndex].kmRun   > teamArray[index].kmRun {
                        let tempUserStat = teamArray[innerIndex]
                        teamArray[innerIndex] = teamArray[index]
                        teamArray[index] = tempUserStat
                    }
                }
            }
        }
    }
    
    
    var Leaderboard = teamLeaderboard(teamArray: [])

    
    //setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        //placeholder for the values
        var team = teamStats(kmRun: -1, timeRun: -1, teamName: "empty")

        //inserts team Bear into Leaderboard
        ref?.child("Teams").child("Bears").child("TotalKm").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? Double
            let trueValue = value!
            self.Bearpopulator.append(trueValue)
            
            
            self.ref?.child("Teams").child("Bears").child("Totaltime").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? Double
                let trueTime = value!
                self.Bearpopulator.append(trueTime)
                
                team.teamName = "Bears"
                team.kmRun = self.Bearpopulator[0]
                team.timeRun = self.Bearpopulator[1]
                self.Leaderboard.teamArray.append(team)
            })

        })
        
        
        //inserts team Bobcat into Leaderboard
        ref?.child("Teams").child("Bobcats").child("TotalKm").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? Double
            let trueValue = value!
            self.Bobcatpopulator.append(trueValue)
            
            self.ref?.child("Teams").child("Bobcats").child("Totaltime").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? Double
                let trueTime = value!
                self.Bobcatpopulator.append(trueTime)
                
                team.teamName = "Bobcats"
                team.kmRun = self.Bobcatpopulator[0]
                team.timeRun = self.Bobcatpopulator[1]
                self.Leaderboard.teamArray.append(team)
            })
            
            
        })
        
        //inserts team Eagle into Leaderboard
        ref?.child("Teams").child("Eagles").child("TotalKm").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? Double
            let trueValue = value!
            self.Eaglepopulator.append(trueValue)
            
            self.ref?.child("Teams").child("Eagles").child("Totaltime").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? Double
                let trueTime = value!
                self.Eaglepopulator.append(trueTime)
                
                team.teamName = "Eagles"
                team.kmRun = self.Eaglepopulator[0]
                team.timeRun = self.Eaglepopulator[1]
                self.Leaderboard.teamArray.append(team)
            })
            
            self.teamsPopulated = true
        })

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        Leaderboard.sortbyDistance()
        
        self.TeamTable.reloadData()
        
    }
    
    
    //Functions
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellToBeReturned: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TeamsCell")!
        
        ref = FIRDatabase.database().reference()
        
        
        if teamsPopulated{
            
            if sortByDistance {
                Leaderboard.sortbyDistance()
                
                cellToBeReturned.textLabel?.text = Leaderboard.teamArray[indexPath.row].teamName
                cellToBeReturned.detailTextLabel?.text = "\(String(format: "%.2f", Leaderboard.teamArray[indexPath.row].kmRun )) Km"
            }
                
            else {
                
                Leaderboard.sortByTime()
                cellToBeReturned.textLabel?.text = Leaderboard.teamArray[indexPath.row].teamName
                
                var seconds: Int = Int(Leaderboard.teamArray[indexPath.row].timeRun)
                
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
        return 3
    }
    
    //Actions
    
    @IBAction func BackButton(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SwitchOrder(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            sortByDistance = false
            Leaderboard.sortByTime()
            
            self.TeamTable.reloadData()
        }
        else{
            sortByDistance = true
            Leaderboard.sortbyDistance()
            
            self.TeamTable.reloadData()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            }
    
}
