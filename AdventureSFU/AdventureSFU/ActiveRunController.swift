//
//  ActiveRunController.swift
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

class ActiveRunController: ViewRunController, ActiveMapViewDelegate, CLLocationManagerDelegate {
    var locationManager:CLLocationManager!
    var running: Bool = true
    
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBAction func StopStartRun(_ sender: UIButton) {
        if (running) {
            self.locationManager.stopUpdatingLocation()
        pauseButton.setTitle("", for: [])
        pauseButton.setTitle("Resume run recording", for: [])
         running = false
            
        }
        else {
            running = true
            self.locationManager.startUpdatingLocation()
            pauseButton.setTitle("Pause run recording", for: [])
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("searchable active waypoints.count: \(waypoints.count)")
        pauseButton.setTitle("Pause run recording", for: [])
        self.locationManager = CLLocationManager()
        self.locationManager.requestAlwaysAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            // Set a movement threshold for new events.
            self.locationManager.distanceFilter = kCLLocationAccuracyBest // meters
 //           self.locationManager.startUpdatingLocation()
            
            
        
        }

        // Do any additional setup after loading the view.
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last! as CLLocation
        
        
        
        print("searchable long and lat\(location.coordinate.longitude),\(location.coordinate.latitude)")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func getTime(time: Double) -> Double? {
        self.time = time

        return time
    }
    
    override func getDistance(distance: Double) -> Double? {
        self.distance = distance/1000

        return distance
        
    }
    
    @IBAction func stopRun() {
        self.locationManager.stopUpdatingLocation()
        performSegue(withIdentifier: "stopRun", sender: self)
    }
    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "activerunembed" {
            let childViewController = segue.destination as? ActiveMapUI
            childViewController?.delegate = self
            childViewController?.preselectedRoute = self.presetRoute
            childViewController?.waypoints = self.waypoints
        }
        if segue.identifier == "stopRun" {
            let childViewController = segue.destination as? ViewRunController
            childViewController?.route = self.route
            childViewController?.presetRoute=self.presetRoute
            childViewController?.waypoints = self.waypoints
        }
        //Define self as MapViewDelegate for embedded MapUI.
    }
    
}
