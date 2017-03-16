//
//  ActiveMapUI.swift
//  AdventureSFU
//
//  Created by ela50 on 3/14/17.
//  Copyright © 2017 Karan Aujla. All rights reserved.
//

import UIKit
import Mapbox
import MapboxDirections
import Firebase
import CoreLocation

class ActiveMapUI: MapUI, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    var activeDelegate: ActiveMapViewDelegate?
  //  var route: Route?
    
    override func viewDidLoad() {
      self.locationManager = CLLocationManager()
        self.locationManager.requestAlwaysAuthorization()
   
    
        super.viewDidLoad()
        if (CLLocationManager.locationServicesEnabled()) {
        MapUI.userTrackingMode = .follow
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            // Set a movement threshold for new events.
            self.locationManager.distanceFilter = kCLLocationAccuracyBest // meters
            self.locationManager.startUpdatingLocation()


        print("searchable didload check")
        }}
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last! as CLLocation
        
  
        
        print("searchable long and lat\(location.coordinate.longitude),\(location.coordinate.latitude)")
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
