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
