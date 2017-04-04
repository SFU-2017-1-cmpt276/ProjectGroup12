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
//	Known Bugs:
//	Todo:

import UIKit
import Mapbox
import MapboxDirections
import Firebase

class MapUI: UIViewController, RunViewControllerDelegate, MGLMapViewDelegate {
    
    //View Outlets
    var MapUI: MGLMapView!
    
    //Variables
    weak var delegate: MapViewDelegate?
    var coordinates: [CLLocationCoordinate2D] = []
    var waypoints: [Waypoint] = []
    var directions = Directions.shared;
    var preselectedRoute: Route?
    var names: Int = 0
    var start = MGLPointAnnotation()
    var preselectedWaypoints: [Waypoint] = []
    var ref: FIRDatabaseReference?
    let userID = FIRAuth.auth()?.currentUser?.uid
 
    //Load Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        let hasRoute = String(describing: ref?.child("Users").child(userID!).child("hasPlannedRoute"))
        if hasRoute=="true" {
            //load route from Firebase
        }
        
        //load map and draw planned route
    
        MapUI = GlobalVariables.sharedManager.mapView
      
        
        MapUI = MGLMapView(frame: view.bounds, styleURL: MGLStyle.outdoorsStyleURL(withVersion: 9))
        MapUI.delegate = self
        MapUI.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(MapUI)
        MapUI.setCenter(CLLocationCoordinate2D(latitude: 49.273382, longitude: -122.908837),
                        zoomLevel: 13, animated: false)
        if (GlobalVariables.sharedManager.plannedWaypoints.count > 0) {
            handleRoute()
        }
        
        //define doubleTap so singleTap can be defined relative to it
        let doubleTap = UITapGestureRecognizer(target: self, action: nil)
        doubleTap.numberOfTapsRequired = 2
        MapUI.addGestureRecognizer(doubleTap)
        
        // define singleTap relative to doubleTap
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        singleTap.require(toFail: doubleTap)
        MapUI.addGestureRecognizer(singleTap)
    }
    
    //Functions
    func deleteAllPoints() {
        if (GlobalVariables.sharedManager.plannedWaypoints.count > 0) {
            GlobalVariables.sharedManager.plannedWaypoints.removeAll()
            //delete Global copy of route
        }
        if (MapUI.annotations?.count != nil) {
            MapUI.removeAnnotations(MapUI.annotations!)
            // remove drawn route so new route can be drawn
        }
        //Deletes a planned route.
    }
    
    
    func handleSingleTap(tap: UITapGestureRecognizer) {
        if GlobalVariables.sharedManager.plannedWaypoints.count < 25 {
        let location: CLLocationCoordinate2D = MapUI.convert(tap.location(in: MapUI), toCoordinateFrom: MapUI)
        let wpt: Waypoint = Waypoint(coordinate: location, name: "\(names)")
        GlobalVariables.sharedManager.plannedWaypoints.append(wpt)
        self.names = self.names + 1
        //update current list of coordinates
        
        // if at least 2 points are specified, calculate and draw route. update local and delegate stats.
        handleRoute()
        } else {
            self.delegate?.maxPointsAlert()
        }
        //Adds selected location to user route.
    }
    
    
    func handleRoute() {
        if GlobalVariables.sharedManager.plannedWaypoints.count > 0 {
            start.coordinate = GlobalVariables.sharedManager.plannedWaypoints[0].coordinate
            start.title="Start"
            MapUI.addAnnotation(start)
            // Add 'start' to map.
            
            
            if GlobalVariables.sharedManager.plannedWaypoints.count > 1 {
                let options = RouteOptions(waypoints: GlobalVariables.sharedManager.plannedWaypoints, profileIdentifier: MBDirectionsProfileIdentifierWalking)
                //define directions info - coordinates and travel speed
                
                _ = directions.calculate(options) { (waypoints, routes, error) in
                    guard error == nil else {
                        return //breaks if route can't be calculated
                    }
                    
                    if let route = routes?.first {
                        self.drawRoute(route: route)
                    }
                }
            } //generates route if there is more than one point. submits it to be drawn.
        }
       
    }

    func drawRoute(route: Route) {
        print("expectedtraveltime: \(route.expectedTravelTime)")
        //passes time and distance to containing view for display to user.
        self.delegate?.getDistanceAndTime(distance: route.distance, time: route.expectedTravelTime)
        var routeCoordinates = route.coordinates!
        let routeLine = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)
        self.MapUI.addAnnotation(routeLine)
        //redraw route
    }
    
    
    func dismissMapView() {
        
        dismiss(animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}


