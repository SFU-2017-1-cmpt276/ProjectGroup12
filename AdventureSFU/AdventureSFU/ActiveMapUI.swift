//  ActiveMapUI.swift
//
//	AdventureSFU: Make Your Path
//	Created for SFU CMPT 276, Instructor Herbert H. Tsang, P.Eng., Ph.D.
//	AdventureSFU was a project created by Group 12 of CMPT 276
//
//  Created by Group 12 on 3/14/17.
//  Copyright © 2017 . All rights reserved.
//
//	Shows current user location, planned route and actual path on current run.
//	Programmers: Karan Aujla, Carlos Abaffy, Eleanor Lewis, Chris Norris-Jones
//
//	Known Bugs:
//	Todo: //


import UIKit
import Mapbox
import MapboxDirections
import Firebase

class ActiveMapUI: MapUI, ActiveRunControllerDelegate {

    //Variables
    weak var activeDelegate: ActiveMapViewDelegate?

    //Functions
    
    //Draws map at specified coordinates and adds planned route.
    override func viewDidLoad() {
        super.viewDidLoad()
        if (GlobalVariables.sharedManager.plannedWaypoints.count > 0) {
        MapUI.setCenter(CLLocationCoordinate2D(latitude: GlobalVariables.sharedManager.plannedWaypoints[0].coordinate.latitude, longitude: GlobalVariables.sharedManager.plannedWaypoints[0].coordinate.longitude),
                        zoomLevel: 13, animated: false) }
      //  MapUI.userTrackingMode = .follow
        self.handleRoute()
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Overrides route-selection gesture recognizer.
    override func handleSingleTap(tap: UITapGestureRecognizer) {
        //do nothing
    }
    
    //Updates map annotations to include most recent user movement.
    func appendToDrawnRoute() {
        if GlobalVariables.sharedManager.actualWaypoints.count > 1 {
        let coords = [GlobalVariables.sharedManager.actualWaypoints[GlobalVariables.sharedManager.actualWaypoints.count-2].coordinate, GlobalVariables.sharedManager.actualWaypoints[GlobalVariables.sharedManager.actualWaypoints.count-1].coordinate]
        let line = MGLPolyline(coordinates: coords, count: 2)
        MapUI.addAnnotation(line)
        }
        
    }

}
