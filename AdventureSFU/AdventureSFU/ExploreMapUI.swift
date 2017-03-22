//	ExploreMapUI.swift
//	Created for SFU CMPT 276, Instructor Herbert H. Tsang, P.Eng., Ph.D.
//	AdventureSFU was a project created by Group 12 of CMPT 276
//
//	ExploreMapUI - shows the geocache coordinates and current user location.
//	Programmers: Karan Aujla, Carlos Abaffy, Eleanor Lewis, Chris Norris-Jones
//
//  Created by Group12 on 3/19/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import MapboxDirections
import Mapbox


class ExploreMapUI: MapUI {
    var mapLat: Double?
    var mapLong: Double?
    var exploreTitle: String?
    var target = MGLPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        target.coordinate = CLLocationCoordinate2D(latitude: mapLat!, longitude: mapLong!)
        target.title = exploreTitle
        MapUI.addAnnotation(target)
        MapUI.userTrackingMode = .follow
        //Add target coordinate and user location to map.
    }
    
    override func handleSingleTap(tap: UITapGestureRecognizer) {
        //do nothing; overwrites route selection function of MapUI class
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
