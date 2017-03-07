//
//  MapUI.swift
//
//	AdventureSFU: Make Your Path
//	Created for SFU CMPT 276, Instructor Herbert H. Tsang, P.Eng., Ph.D.
//	AdventureSFU was a project created by Group 12 of CMPT 276
//
//  Created by Group 12 on 3/2/17.
//  Copyright © 2017 . All rights reserved.
//
//	MapUI - The signup screen that alows users to create their account
//	Programmers: Karan Aujla, Carlos Abaffy, Eleanor Lewis, Chris Norris-Jones
//
//	Known Bugs:	-Stop warning flags from unused variables from displaying, when variables are in fact being used
//	Todo:	
//

import UIKit
import Mapbox
import MapboxDirections


//  let directions = Directions.shared
var directions = Directions.shared;
//var restorationIdentifier: String? { get set }
class MapUI: UIViewController {
	
//View Outlets
	@IBOutlet var MapUI: MGLMapView!
	
//Variables
	var delegate: MapViewDelegate?
	var coordinates: [CLLocationCoordinate2D] = []
	var waypoints: [Waypoint] = []
	
//Load Actions
	override func viewDidLoad() {
		super.viewDidLoad()
		MapUI = MGLMapView(frame: view.bounds)
		MapUI.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		view.addSubview(MapUI)
		MapUI.setCenter(CLLocationCoordinate2D(latitude: 49.273382, longitude: -122.908837),
		                zoomLevel: 15, animated: false)
		// double tapping zooms the map, so ensure that can still happen
		let doubleTap = UITapGestureRecognizer(target: self, action: nil)
		doubleTap.numberOfTapsRequired = 2
		MapUI.addGestureRecognizer(doubleTap)
		
		
		
		// delay single tap recognition until it is clearly not a double
		let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
		singleTap.require(toFail: doubleTap)
		MapUI.addGestureRecognizer(singleTap)
		
		
		// convert `mapView.centerCoordinate` (CLLocationCoordinate2D)
		// to screen location (CGPoint)
		let centerScreenPoint: CGPoint = MapUI.convert(MapUI.centerCoordinate, toPointTo: MapUI)
		print("Screen center: \(centerScreenPoint) = \(MapUI.center)")
		// Do any additional setup after loading the view.
	}
	
//Functions
	
	func handleSingleTap(tap: UITapGestureRecognizer) {
		// convert tap location (CGPoint)
		// to geographic coordinates (CLLocationCoordinate2D)
		var location: CLLocationCoordinate2D = MapUI.convert(tap.location(in: MapUI), toCoordinateFrom: MapUI)
		let names = "0"
		print("You tapped at: \(location.latitude), \(location.longitude)")
		
		let wpt: Waypoint = Waypoint(coordinate: location, name: names)
		waypoints.append(wpt)
		self.delegate?.getWaypoint(waypoint: wpt)
		
		
		// remove existing polyline from the map, (re)add polyline with coordinates
		if (MapUI.annotations?.count != nil) {
			MapUI.removeAnnotations(MapUI.annotations!)
		}
		
		// let polyline = MGLPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
		if waypoints.count > 1 {
			// MapUI.addAnnotation(polyline)
			let options = RouteOptions(waypoints: waypoints, profileIdentifier: MBDirectionsProfileIdentifierWalking)
			options.includesSteps = true
			
			
			_ = directions.calculate(options) { (waypoints, routes, error) in
				guard error == nil else {
					print("Error calculating directions: \(error!)")
					return
				}
				
				
				
				if let route = routes?.first, let leg = route.legs.first {
					print("Route via \(leg):")
					self.delegate?.getRoute(chosenRoute: route)
					let distanceFormatter = LengthFormatter()
					let formattedDistance = distanceFormatter.string(fromMeters: route.distance)
					
					let travelTimeFormatter = DateComponentsFormatter()
					travelTimeFormatter.unitsStyle = .short
					let formattedTravelTime = travelTimeFormatter.string(from: route.expectedTravelTime)
					self.delegate?.getTime(time: route.expectedTravelTime)
					self.delegate?.getDistance(distance: route.distance)
					print("Distance: \(formattedDistance); ETA: \(formattedTravelTime!)")
					
					for step in leg.steps {
						print("\(step.instructions)")
						if step.distance > 0 {
							let formattedDistance = distanceFormatter.string(fromMeters: step.distance)
							print("searchableview — \(formattedDistance) —")
						}
					}
					
					if route.coordinateCount > 0 {
						// Convert the route’s coordinates into a polyline.
						var routeCoordinates = route.coordinates!
						let routeLine = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)
						
						// Add the polyline to the map and fit the viewport to the polyline.
						self.MapUI.addAnnotation(routeLine)
						self.MapUI.setVisibleCoordinates(&routeCoordinates, count: route.coordinateCount, edgePadding: .zero, animated: true)
					}
				}
			}
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
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



