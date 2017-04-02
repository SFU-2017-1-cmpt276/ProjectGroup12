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
//	Todo: - remove unused vars
//


import UIKit
import Mapbox
import Firebase
import MapboxDirections

class GlobalVariables {
    
    struct ExploreItem {
        var id : Int?
        var title : String?
        var hint : String?
        var lat : Double?
        var long : Double?
        var pass : String?
    }
    
    var exploreItemArray = [ExploreItem]()
    var actualWaypoints: [Waypoint] = []
    var waypoints: [Waypoint] = []
    var startTime: Date?
    var endTime: Date?
    var elapsedTimeThisRun: TimeInterval?
    var distanceThisRun: Double = 0
    var hasRunData: Bool = false
    var plannedWaypoints: [Waypoint] = []
    var waypointsTest: [Waypoint] = []
    
    var height: Double = 0.0
    var weight: Double = 0.0

    var countingCalories: Bool = false


    var ref: FIRDatabaseReference?
    var userID: String?
    
    class var sharedManager: GlobalVariables {
        struct Static {
            static let instance = GlobalVariables()
        }
        return Static.instance
    }
}
