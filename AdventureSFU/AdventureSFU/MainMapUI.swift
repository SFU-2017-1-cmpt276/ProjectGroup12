//
//  MainMapUIn.swift
//  AdventureSFU
//
//  Created by ela50 on 3/20/17.
//  Copyright © 2017 Karan Aujla. All rights reserved.
//
import UIKit
import Mapbox

class MainMapUI: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var MainMapUI: MGLMapView!
    
    
    //main page's map display
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //draws the map
        MainMapUI = MGLMapView(frame: view.bounds, styleURL: MGLStyle.satelliteStyleURL(withVersion: 9))
        view.addSubview(MainMapUI)
        
        //centres the map to burnaby mountain
        MainMapUI.setCenter(CLLocationCoordinate2D(latitude: 49.273382, longitude: -122.908837),
                            zoomLevel: 13, animated: false)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}
