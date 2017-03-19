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
  //  var route: Route?
    
    override func viewDidLoad() {

   
    
        super.viewDidLoad()
MapUI.userTrackingMode = .follow
        print("searchable active waypoints \(waypoints)")
        print("searchable active waypoints in mapui: \(waypoints.count)")
        self.handleRoute()
     }

    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func handleRoute() {
        super.handleRoute()
        print("handleRoute in active")
    }
    
    override func drawRoute(route: Route) {
        super.drawRoute(route: route)
        print("drawRoute in active")
    }
  
    func appendToDrawnRoute() {
        print("searchable test of appendToDrawnRoute delegation")
       let coords = [GlobalVariables.sharedManager.actualWaypoints[GlobalVariables.sharedManager.actualWaypoints.count-2].coordinate, GlobalVariables.sharedManager.actualWaypoints[GlobalVariables.sharedManager.actualWaypoints.count-1].coordinate]
        
        let line = MGLPolyline(coordinates: coords, count: 2)
        MapUI.addAnnotation(line)
        
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
