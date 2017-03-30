//
//  MainMapUI.swift
//
//	AdventureSFU: Make Your Path
//	Created for SFU CMPT 276, Instructor Herbert H. Tsang, P.Eng., Ph.D.
//	AdventureSFU was a project created by Group 12 of CMPT 276
//
//  Created by Group 12 on 3/20/17.
//  Copyright © 2017 . All rights reserved.
//
//	Satellite view map centered on SFU.
//	Programmers: Karan Aujla, Carlos Abaffy, Eleanor Lewis, Chris Norris-Jones
//
//	Known Bugs:
//	Todo:
//


import UIKit
import Mapbox

class MainMapUI: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var MainMapUI: MGLMapView!
    
    
    //main page's map display
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //draws the map
        MainMapUI = MGLMapView(frame: view.bounds, styleURL: MGLStyle.satelliteStreetsStyleURL(withVersion: 9))
        view.addSubview(MainMapUI)
        
        //centres the map to burnaby mountain
        MainMapUI.setCenter(CLLocationCoordinate2D(latitude: 49.273382, longitude: -122.908837),
                            zoomLevel: 13, animated: false)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}
