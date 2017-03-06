//
//  MapViewDelegate.swift
//  AdventureSFU
//
//  Created by ela50 on 3/6/17.
//  Copyright © 2017 Karan Aujla. All rights reserved.
//

import UIKit
import Mapbox
import MapboxDirections
protocol MapViewDelegate {

    func getTime(time: Double) -> Double?
    func getDistance(distance: Double) -> Double?
    func getWaypoint(waypoint: Waypoint)
    func getRoute(chosenRoute: Route) -> Route?

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
