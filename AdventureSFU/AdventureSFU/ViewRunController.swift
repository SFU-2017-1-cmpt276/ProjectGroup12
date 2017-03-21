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
//	ViewRunController - The page where users
//	Programmers: Karan Aujla, Carlos Abaffy, Eleanor Lewis, Chris Norris-Jones
//
//	Known Bugs:	-Route limit set to 25 waypoints currently, then assertion called and app crashes, need better method for either setting a limit or increasing number of waypoints without potentially introducing any stability issues
//	Todo:	-Improve UI elements, set up UI constraints
//			-Have run data pulled in to database from statistics
//			-Further functionality with regards to run details, user's ability to create run
//			-Further run details information upon creating run
//remove most recent point by shifting everything to point to globalvariables class, then modifying that waypoints object
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
    var waypoints: [Waypoint] = []
    var route: Route?
    var presetRoute: Route?
    var ref: FIRDatabaseReference?
    let userID = FIRAuth.auth()?.currentUser?.uid
    var RunViewDelegate: RunViewControllerDelegate?
    
    //Functions
    //Functions implementing MapViewDelegate headers
    func getTime(time: Double) -> Double? {
        self.time = time
        print("searchable time: \(time)")
       let seconds = Int(time) % 60;
       let minutes = Int(time / 60) % 60;
        let hours = Int(time / 3600);
        timeField.text = String("H:M:S: \(hours):\(minutes):\(seconds)")
        return time
    }
    
    func getDistance(distance: Double) -> Double? {
        self.distance = distance/1000
        distanceField.text = String(format: "Kms: %.2f", distance/1000)
        return distance
        
    }
    
    func getWaypoint(waypoint: Waypoint) {
        self.waypoints.append(waypoint)
    }
    
    func deleteWaypoint() {
        self.waypoints.remove(at: waypoints.count-1)
    }
    
    func getRoute(chosenRoute: Route) -> Route? {
        self.route = chosenRoute
        return chosenRoute
    }
    
    //Load Actions
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if (presetRoute != nil) { route = presetRoute }
        ref = FIRDatabase.database().reference()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Actions
    @IBAction func runToMain() {
        performSegue(withIdentifier: "runControllerToMain", sender: self)
    }
    
    
    
    //    @IBAction func DeleteLastPoint(_ sender: UIButton) {
    //        self.RunViewDelegate?.deleteLastPoint()
    //    }
    @IBAction func DeleteAllPoints(_ sender: UIButton) {
        self.RunViewDelegate?.deleteAllPoints()
         distanceField.text = String(format: "Kms: %.2f", 0)
        timeField.text = String("H:M:S: 0:0:0")
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
        //submits run plan to Firebase
    }
    
    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "runpageembed" {
            let childViewController = segue.destination as? MapUI
            childViewController?.delegate = self
            childViewController?.preselectedRoute = self.route
            childViewController?.waypoints = self.waypoints
            self.RunViewDelegate = segue.destination as? MapUI		}
        if segue.identifier == "startRun" {
            let childViewController = segue.destination as? ActiveRunController
            childViewController?.presetRoute = self.route
            childViewController?.waypoints = self.waypoints
        }
        //Define self as MapViewDelegate for embedded MapUI.
    }
    
    
}
