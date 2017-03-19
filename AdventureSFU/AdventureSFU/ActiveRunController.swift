//
//  ActiveRunController.swift
//  AdventureSFU
//
//  Created by ela50 on 3/14/17.
//  Copyright © 2017 Karan Aujla. All rights reserved.
//
//todo: draw polyline from planned route
//draw self-updating polyline, separately from actual route
//log waypoints to firebase
//figure out route storage with multiple points
import UIKit
import Mapbox
import MapboxDirections
import Firebase
import CoreLocation

class ActiveRunController: ViewRunController, ActiveMapViewDelegate, CLLocationManagerDelegate {
    var locationManager:CLLocationManager!
    var running: Bool = true
    var actualWaypointNumber: Int = 0
    var activeDelegate: ActiveRunControllerDelegate?

    var actualWaypoints: [Waypoint] = []
    
    let calendar = Calendar.current
  
    
    
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
        GlobalVariables.sharedManager.startTime = Date()
        pauseButton.setTitle("Pause run recording", for: [])
        self.locationManager = CLLocationManager()
        self.locationManager.requestAlwaysAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            // Set a movement threshold for new events.
            self.locationManager.distanceFilter = kCLLocationAccuracyBest // meters
            self.locationManager.startUpdatingLocation()
            
 
        
        }

        // Do any additional setup after loading the view.
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last! as CLLocation
        
        
        let wpt: Waypoint = Waypoint(coordinate: location.coordinate, name: "\(actualWaypointNumber)")
        actualWaypoints.append(wpt)
        //update current list of coordinates
        self.actualWaypointNumber = self.actualWaypointNumber + 1
        
        GlobalVariables.sharedManager.actualWaypoints.append(wpt)
        //sends waypoint to delegate array
        if actualWaypointNumber > 2 {
   self.activeDelegate?.appendToDrawnRoute()
        }
        let date = Date()
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
   //     print("hours = \(hour):\(minutes):\(seconds)")
    //
   //     print("searchable long and lat\(location.coordinate.longitude),\(location.coordinate.latitude)")
        
  
    
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
            self.activeDelegate = segue.destination as? ActiveMapUI
            let childViewController = segue.destination as? ActiveMapUI
            childViewController?.delegate = self
            childViewController?.preselectedRoute = self.presetRoute
            childViewController?.waypoints = self.waypoints
        }
        if segue.identifier == "stopRun" {
            GlobalVariables.sharedManager.hasRunData = true
            GlobalVariables.sharedManager.endTime = Date()
            GlobalVariables.sharedManager.elapsedTimeThisRun = GlobalVariables.sharedManager.endTime!.timeIntervalSince(GlobalVariables.sharedManager.startTime!)
            GlobalVariables.sharedManager.distanceThisRun = GlobalVariables.sharedManager.distanceThisRun + 10
            print("searchable time \(GlobalVariables.sharedManager.elapsedTimeThisRun)")
print("searchable globalvariables waypoints \(GlobalVariables.sharedManager.actualWaypoints)")
            var tempTotalKm: Double?
            ref?.child("Users").child(userID!).child("KMRun").observeSingleEvent(of: .value, with: { (snapshot) in
                tempTotalKm = snapshot.value as? Double
                if var totalKm = tempTotalKm {
                    totalKm = self.distance + tempTotalKm!
                    self.ref?.child("Users").child(self.userID!).child("KMRun").setValue(totalKm)
                }
            })
    
            let childViewController = segue.destination as? ViewRunController
            childViewController?.route = self.route
            childViewController?.presetRoute=self.presetRoute

        }
        //Define self as MapViewDelegate for embedded MapUI.
    }
    
}
