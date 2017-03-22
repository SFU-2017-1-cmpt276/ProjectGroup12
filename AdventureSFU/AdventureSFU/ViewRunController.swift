//
//  ViewRunController.swift
//
//	AdventureSFU: Make Your Path
//	Created for SFU CMPT 276, Instructor Herbert H. Tsang, P.Eng., Ph.D.
//	AdventureSFU was a project created by Group 12 of CMPT 276
//
//  Created by Group 12 on 3/2/17.
//  Copyright © 2017 . All rights reserved.
//
//	ViewRunController - A page where users can check out the trails map and plan a route.
//	Programmers: Karan Aujla, Carlos Abaffy, Eleanor Lewis, Chris Norris-Jones
//
//	Known Bugs:	-Route limit set to 25 waypoints currently, then assertion called and app crashes, need better method for either setting a limit or increasing number of waypoints without potentially introducing any stability issues
//              -Map sometimes will not load if info button is clicked first
//	Todo:   -Further functionality with regards to run details, user's ability to create run
//			-Further run details information upon creating run
//          -'Delete last point' function
//          -Choose speed
import UIKit
import Mapbox
import MapboxDirections
import Firebase

class ViewRunController: UIViewController, MapViewDelegate {
    
    //View Outlets
    @IBOutlet weak var distanceField: UILabel!
    @IBOutlet weak var timeField: UILabel!
    
    //Variables
    var time: Double = 0
    var distance: Double = 0
    var ref: FIRDatabaseReference?
    let userID = FIRAuth.auth()?.currentUser?.uid
    var RunViewDelegate: RunViewControllerDelegate?
    
    //Functions
    //Functions implementing MapViewDelegate headers
    func getTime(time: Double) {
        self.time = time
        print("searchable time: \(time)")
        let seconds = Int(time) % 60;
        let minutes = Int(time / 60) % 60;
        let hours = Int(time / 3600);
        timeField.text = String("H:M:S: \(hours):\(minutes):\(seconds)")
        //Updates the time stat of the planned route.
    }
    
    func getDistance(distance: Double) {
        self.distance = distance/1000
        distanceField.text = String(format: "Kms: %.2f", distance/1000)
        //Updates the distance stat of the planned route.
    }
    
    //Load Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Actions
    @IBAction func runToMain() {
        performSegue(withIdentifier: "runControllerToMain", sender: self)
        //Returns user to main page.
    }
    
    @IBAction func helpPopup(_ sender: Any) {
        let infoAlert = UIAlertController(title: "Route Plan Help", message: "On this page you can plan your route. Select a starting point and subsequent points by single tap to generate a route and get its distance and estimated travel time. Select CLEAR to start over. Select SAVE to keep this route available for when you next log in. Select Run! to start tracking your route!", preferredStyle: .alert)
        let agreeAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        infoAlert.addAction(agreeAction)
        self.present(infoAlert, animated: true, completion: nil)
        //Info for the user about what to do on this page.
    }
   
    @IBAction func DeleteAllPoints(_ sender: UIButton) {
        self.RunViewDelegate?.deleteAllPoints()
        distanceField.text = String(format: "Kms: %.2f", 0)
        timeField.text = String("H:M:S: 0:0:0")
        //Resets time and distance stats to zero and prompts MapUI to delete the planned route.
    }
    
    @IBAction func submitRunStats(_ sender: AnyObject) {
        self.ref?.child("Users").child(self.userID!).child("presetRoute").setValue("")
        for wpt in GlobalVariables.sharedManager.plannedWaypoints {
            let key = self.ref?.child("Users").child(self.userID!).child("presetRoute").childByAutoId().key
            let waypt: NSDictionary = ["lat" : wpt.coordinate.latitude,
                                       "long" : wpt.coordinate.longitude]
            self.ref?.child("Users").child(self.userID!).child("presetRoute").updateChildValues(["/\(key)" : waypt])
        }
        let alertController = UIAlertController(title: "Run is stored", message:nil, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        //Submits run plan to Firebase (as a list of coordinates).
    }
    
    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "runpageembed" {
            let childViewController = segue.destination as? MapUI
            childViewController?.delegate = self
            self.RunViewDelegate = segue.destination as? MapUI
        }
        //Define self as MapViewDelegate for embedded MapUI, and embedded MapUI as RunViewDelegate for self.
    }
    
    
}
