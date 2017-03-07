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
//

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
	
	func getRoute(chosenRoute: Route) -> Route? {
		self.route = chosenRoute
		return chosenRoute
	}
	
//Load Actions
	override func viewDidLoad() {
		super.viewDidLoad()
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
        var tempTotalKm: Double?
        ref?.child("Users").child(userID!).child("KMRun").observeSingleEvent(of: .value, with: { (snapshot) in
            tempTotalKm = snapshot.value as? Double
            if var totalKm = tempTotalKm {
                totalKm = self.distance + tempTotalKm!
                self.ref?.child("Users").child(self.userID!).child("KMRun").setValue(totalKm)
            }
        })
        //Submit current route kms to user stats in database.
    }
	
// Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "runpageembed" {
			let childViewController = segue.destination as? MapUI
			childViewController?.delegate = self
		}
		//Define self as MapViewDelegate for embedded MapUI.
	}
 
	
}
