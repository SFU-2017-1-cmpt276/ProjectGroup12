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


class ViewRunController: UIViewController, MapViewDelegate {
	
//View Outlets
	@IBOutlet weak var distanceField: UILabel!
	@IBOutlet weak var timeField: UILabel!
	
//Variables
	var time: Double = 0
	var distance: Double = 0
	var waypoints: [Waypoint] = []
	var route: Route?
	
//Functions
	func getTime(time: Double) -> Double? {
		self.time = time
		timeField.text = String("min: \(time/60)")
		print("searchabletime\(time)")
		return time
	}
	
	func getDistance(distance: Double) -> Double? {
		self.distance = distance
		distanceField.text = String("kms: \(distance/1000)")
		print("searchabledistance\(time)")
		return distance
		
	}
	
	func getWaypoint(waypoint: Waypoint) {
		self.waypoints.append(waypoint)
		
	}
	
	func getRoute(chosenRoute: Route) -> Route? {
		self.route = chosenRoute
		print("searchableroute\(chosenRoute)")
		return chosenRoute
		
	}
	
//Load Actions
	override func viewDidLoad() {
		super.viewDidLoad()
		
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
	
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == "runpageembed" {
			let childViewController = segue.destination as? MapUI
			childViewController?.delegate = self
			
		}
		
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
	}
 
	
}
