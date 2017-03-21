//
//  ActiveMapUI.swift
//  AdventureSFU
//
//  Created by ela50 on 3/14/17.
//  Copyright © 2017 Karan Aujla. All rights reserved.
//
//
import UIKit
import Mapbox
import MapboxDirections
import Firebase

class ActiveMapUI: MapUI, ActiveRunControllerDelegate {

    var activeDelegate: ActiveMapViewDelegate?

    
    override func viewDidLoad() {
        print("made it here")
        super.viewDidLoad()
        if (GlobalVariables.sharedManager.plannedWaypoints.count > 0) {
        MapUI.setCenter(CLLocationCoordinate2D(latitude: GlobalVariables.sharedManager.plannedWaypoints[0].coordinate.latitude, longitude: GlobalVariables.sharedManager.plannedWaypoints[0].coordinate.longitude),
                        zoomLevel: 13, animated: false) }
        MapUI.userTrackingMode = .follow
        self.handleRoute()
     }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    func appendToDrawnRoute() {
        print("searchable test of appendToDrawnRoute delegation")
        let coords = [GlobalVariables.sharedManager.actualWaypoints[GlobalVariables.sharedManager.actualWaypoints.count-2].coordinate, GlobalVariables.sharedManager.actualWaypoints[GlobalVariables.sharedManager.actualWaypoints.count-1].coordinate]
        let line = MGLPolyline(coordinates: coords, count: 2)
        MapUI.addAnnotation(line)
        //Updates user-route polyline.
    }

    

}
