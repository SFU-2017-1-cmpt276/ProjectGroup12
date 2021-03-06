//
//  GlobalVariables.swift
//
//	AdventureSFU: Make Your Path
//	Created for SFU CMPT 276, Instructor Herbert H. Tsang, P.Eng., Ph.D.
//	AdventureSFU was a project created by Group 12 of CMPT 276
//
//  Created by Group 12 on 3/18/17.
//  Copyright © 2017 . All rights reserved.
//
//	GlobalVariables - stores variables for access by classes throughout app.
//	Programmers: Karan Aujla, Carlos Abaffy, Eleanor Lewis, Chris Norris-Jones
//
//	Known Bugs:
//	Todo:
//


import UIKit
import Mapbox
import Firebase
import MapboxDirections

class GlobalVariables {
    

    //Variables
    
    //Struct describing a single explore item

    struct ExploreItem {
        var id : Int?
        var title : String?
        var hint : String?
        var lat : Double?
        var long : Double?
        var pass : String?
    }
    
    //Variables
    var exploreItemArray = [ExploreItem]()
    var actualWaypoints: [Waypoint] = []
    var waypoints: [Waypoint] = []
    var startTime: Date?
    var endTime: Date?
    var elapsedTimeThisRun: TimeInterval?
    var distanceThisRun: Double = 0
    var plannedWaypoints: [Waypoint] = []
    var avgSpeed: Double? 
    var weight: Double = 0.0
    var mapView: MGLMapView?
    
    class var sharedManager: GlobalVariables {
        struct Static {
            static let instance = GlobalVariables()
        }
        return Static.instance
    }
}
