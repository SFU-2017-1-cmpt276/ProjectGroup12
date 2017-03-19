//
//  GlobalVariables.swift
//  AdventureSFU
//
//  Created by Eleanor on 3/18/17.
//  Copyright © 2017 Karan Aujla. All rights reserved.
//

import UIKit
import Mapbox
import Firebase
import MapboxDirections

class GlobalVariables {
    
    var actualWaypoints: [Waypoint] = []
    var waypoints: [Waypoint] = []
    var startTime: Date?
    var endTime: Date?
    var elapsedTimeThisRun: TimeInterval?
    var distanceThisRun: Double = 0
    var hasRunData: Bool = false
    var plannedWaypoints: [Waypoint] = []

    
    class var sharedManager: GlobalVariables {
        struct Static {
            static let instance = GlobalVariables()
        }
        return Static.instance
    }
}
