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
//implement scrap it and start over
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
    
//Functions
    //Functions implementing MapViewDelegate headers
	func getTime(time: Double) -> Double? {
		self.time = time
		timeField.text = String("min: \(time/60)")
		return time
	}
	
	func getDistance(distance: Double) -> Double? {
		self.distance = distance/1000
		distanceField.text = String("kms: \(distance/1000)")
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
	
    @IBAction func submitRunStats(_ sender: AnyObject) {
//        var tempTotalKm: Double?
//        ref?.child("Users").child(userID!).child("KMRun").observeSingleEvent(of: .value, with: { (snapshot) in
//            tempTotalKm = snapshot.value as? Double
//            if var totalKm = tempTotalKm {
//                totalKm = self.distance + tempTotalKm!
//                self.ref?.child("Users").child(self.userID!).child("KMRun").setValue(totalKm)
//            }
//        })
        
        
        self.ref?.child("Users").child(self.userID!).child("presetRoute").setValue("lats")
        
        self.ref?.child("Users").child(self.userID!).child("presetRoute").setValue("longs")
        
        
        self.ref?.child("Users").child(self.userID!).child("presetRoute").child("lats").setValue([49.2743059909817, 49.2716693043483, 49.2700657079155])
        self.ref?.child("Users").child(self.userID!).child("presetRoute").child("longs").setValue([-122.911805295561, -122.908844152737, -122.903269374788])
        
  //      self.ref?.child("Users").child(self.userID!).child("presetRoute").setValue(GlobalVariables.sharedManager.plannedWaypoints)
    //    print("searchable Global variables presets: \(GlobalVariables.sharedManager.plannedWaypoints)")
        let alertController = UIAlertController(title: "Run is stored", message:nil, preferredStyle: .alert)
		let defaultAction = UIAlertAction(title: "Thanks", style: .cancel, handler: nil)
		alertController.addAction(defaultAction)
		self.present(alertController, animated: true, completion: nil)
        //Submit current route kms to user stats in database.
        var testWaypoints: [Waypoint] = []
     //   ref?.child("Users").child(userID!).child("presetRoute").observeSingleEvent(of: .value, with: { (snapshot) in testWaypoints = (snapshot.value as! NSArray) as! [Waypoint]
       //     GlobalVariables.sharedManager.waypointsTest = testWaypoints
         //   print("searchable firebase test: \(GlobalVariables.sharedManager.waypointsTest)")
       // })
        
    }
	
// Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "runpageembed" {
			let childViewController = segue.destination as? MapUI
			childViewController?.delegate = self
            childViewController?.preselectedRoute = self.route
            childViewController?.waypoints = self.waypoints
		}
        if segue.identifier == "startRun" {
            let childViewController = segue.destination as? ActiveRunController
            childViewController?.presetRoute = self.route
            childViewController?.waypoints = self.waypoints
        }
		//Define self as MapViewDelegate for embedded MapUI.
	}
 
	
}
