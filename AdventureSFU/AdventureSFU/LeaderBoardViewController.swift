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
    
    
    //Variables 
    
    var ref: FIRDatabaseReference?
    var team = "No Team"
    var  userCount = 1
    var userKeys = [String]()
    var kmValues = [Double]()
    var timeValues = [Double]()
    var usersPopulated = false
    var sortByDistance = true
    @IBOutlet weak var users: UITableView!
    @IBOutlet weak var TeamTitle: UITextField!
    
    //Load & Appear Actions
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.sortByKm()

        self.users.reloadData()

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref = FIRDatabase.database().reference()
        print("THIS IS LOAD PAGE")
        ref?.child("Users").child(userID!).child("Team").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? String
            self.team = value!
            self.ref?.child("Teams").child(self.team).child("UserCount").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? Int
                self.userCount = value!
            })
            
            self.TeamTitle.text = "Team " + self.team
            self.ref?.child("Teams").child(self.team).observeSingleEvent(of: .value, with: { snapshot in
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? FIRDataSnapshot {
            
                    if rest.hasChildren(){
                        self.userKeys.append(rest.key)
                    }

                }
                
                for user in self.userKeys {
                    self.ref?.child("Users").child(user).child("KMRun").observeSingleEvent(of: .value, with: { snapshot in
                        let value = snapshot.value as? Double
                        let kmRun = value!
                        self.kmValues.append(kmRun)
                        
                        self.ref?.child("Users").child(user).child("totalSeconds").observeSingleEvent(of: .value, with: { snapshot in
                            let value = snapshot.value as? Double
                            let time = value!
                            self.timeValues.append(time)
                        })
                    })
//                    self.ref?.child("Users").child(user).child("totalSeconds").observeSingleEvent(of: .value, with: { snapshot in
//                        let value = snapshot.value as? Double
//                        let time = value!
//                        self.timeValues.append(time)
//                    })
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
        
        print("THIS IS IT \(userKeys.count)")
        
       
        if usersPopulated{
            
            if sortByDistance {
                sortByKm()
                ref?.child("Users").child(userKeys[indexPath.row]).child("username").observeSingleEvent(of: .value, with: { snapshot in
                    let value = snapshot.value as? String
                    cellToBeReturned.textLabel?.text = value
            
            
                })
        
                ref?.child("Users").child(userKeys[indexPath.row]).child("KMRun").observeSingleEvent(of: .value, with: { snapshot in
                    let value = snapshot.value as? Double
                    let kmRun = value!
                    cellToBeReturned.detailTextLabel?.text =  "\(String(format: "%.2f", kmRun )) Km"
            
                })
            }
            
            else {
                sortByTime()
                ref?.child("Users").child(userKeys[indexPath.row]).child("username").observeSingleEvent(of: .value, with: { snapshot in
                    let value = snapshot.value as? String
                    cellToBeReturned.textLabel?.text = value
                    
                    
                })
                
                ref?.child("Users").child(userKeys[indexPath.row]).child("totalSeconds").observeSingleEvent(of: .value, with: { snapshot in
                    let value = snapshot.value as? Int
                    let time = value!
                    let Minutes : Int = time / 60
                    cellToBeReturned.detailTextLabel?.text =  "\(Minutes) : \(time%60)"
                    
                })
                
            }
        }

        
        return cellToBeReturned
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return userCount
    }
    
    func sortByKm () -> Void {
        if userKeys.count == 1 {
            return
        }

        for index in 0...userKeys.count - 2 {
            for innerIndex in index + 1...userKeys.count - 1{
                if kmValues[innerIndex]  < kmValues[index] {
                    (kmValues[index],kmValues[innerIndex]) = (kmValues[innerIndex],kmValues[index])
                    (userKeys[index],userKeys[innerIndex]) = (userKeys[innerIndex],userKeys[index])
                }
            }
        }
        
    }
    
    func sortByTime () -> Void {
        if userKeys.count == 1 {
            return
        }
        
        for index in 0...userKeys.count - 2 {
            for innerIndex in index + 1...userKeys.count - 1{
                if timeValues[innerIndex] > timeValues[index] {
                    (timeValues[index],timeValues[innerIndex]) = (timeValues[innerIndex],timeValues[index])
                    (userKeys[index],userKeys[innerIndex]) = (userKeys[innerIndex],userKeys[index])
                }
            }
        }
        
    }

    
    //Actions
    
    @IBAction func BackButton(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SwitchOrder(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            sortByDistance = false
            sortByTime()
            self.users.reloadData()
        }
        else{
            sortByDistance = true
            sortByKm()
            self.users.reloadData()
        }
        
    }
    

}
