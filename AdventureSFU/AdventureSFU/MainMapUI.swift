//
//  MainMapUIn.swift
//  AdventureSFU
//
//  Created by ela50 on 3/20/17.
//  Copyright © 2017 Karan Aujla. All rights reserved.
//


//
//  MapViewDelegate.swift
//
//	AdventureSFU: Make Your Path
//	Created for SFU CMPT 276, Instructor Herbert H. Tsang, P.Eng., Ph.D.
//	AdventureSFU was a project created by Group 12 of CMPT 276
//
//  Created by Group 12 on 3/2/17.
//  Copyright © 2017 . All rights reserved.
//
//	MapViewDelegate - gives headers that must be implemented by methods inheriting MapViewDelegate
//	Programmers: Karan Aujla, Carlos Abaffy, Eleanor Lewis, Chris Norris-Jones
//
//	Known Bugs:
//	Todo:
//


import UIKit
import Mapbox

class MainMapUI: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var MainMapUI: MGLMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //   self.MainMapUI.showsUserLocation = true
        MainMapUI = MGLMapView(frame: view.bounds, styleURL: MGLStyle.satelliteStyleURL(withVersion: 9))
        view.addSubview(MainMapUI)
        MainMapUI.setCenter(CLLocationCoordinate2D(latitude: 49.273382, longitude: -122.908837),
                            zoomLevel: 13, animated: false)
        
        
        //    MainMapUI.userTrackingMode = .follow
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
