//
//  ViewRun.swift
//  AdventureSFU
//
//  Created by Carlos Abaffy paz on 3/4/17.
//  Copyright © 2017 Karan Aujla. All rights reserved.
//

import UIKit
import Mapbox
import MapboxDirections


class ViewRunController: UIViewController, MapViewDelegate {
	@IBOutlet weak var distanceField: UILabel!
	@IBOutlet weak var timeField: UILabel!
	var time: Double = 0
	var distance: Double = 0
	var waypoints: [Waypoint] = []
	var route: Route?
	
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
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
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
