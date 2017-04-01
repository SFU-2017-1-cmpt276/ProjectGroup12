//
//  ActiveMapViewDelegate.swift
//
//	AdventureSFU: Make Your Path
//	Created for SFU CMPT 276, Instructor Herbert H. Tsang, P.Eng., Ph.D.
//	AdventureSFU was a project created by Group 12 of CMPT 276
//
//  Created by Group 12 on 3/2/17.
//  Copyright © 2017 . All rights reserved.
//
//	ActiveMapViewDelegate - gives headers that must be implemented by methods inheriting ActiveMapViewDelegate
//	Programmers: Karan Aujla, Carlos Abaffy, Eleanor Lewis, Chris Norris-Jones
//
//	Known Bugs:
//	Todo:
//
//why does this protocol still exist?

import UIKit
import Mapbox
import MapboxDirections
protocol ActiveMapViewDelegate: MapViewDelegate {
    
 //   func getTime(time: Double)
    func getDistanceAndTime(distance: Double, time: Double)
    
}
