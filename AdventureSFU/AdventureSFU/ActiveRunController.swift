//  ActiveRunController.swift
//
//	AdventureSFU: Make Your Path
//	Created for SFU CMPT 276, Instructor Herbert H. Tsang, P.Eng., Ph.D.
//	AdventureSFU was a project created by Group 12 of CMPT 276
//
//  Created by Group 12 on 3/14/17.
//  Copyright © 2017 . All rights reserved.
//
//	Shows current user location and actual path on current outing.
//	Programmers: Karan Aujla, Carlos Abaffy, Eleanor Lewis, Chris Norris-Jones
//
//	Known Bugs:
//	Todo: zoom out to show both user location and planned start point.
//
import UIKit
import Mapbox
import MapboxDirections
import Firebase
import CoreLocation

class ActiveRunController: ViewRunController, ActiveMapViewDelegate, CLLocationManagerDelegate {
    var locationManager:CLLocationManager!
    var actualWaypointNumber: Int = 0
    var activeDelegate: ActiveRunControllerDelegate?
    var actualWaypoints: [Waypoint] = []
    let calendar = Calendar.current
    var actualTotalDistance: Double = 0
    
    override func getTime(time: Double) {
       
    }
    
    override func getDistance(distance: Double) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GlobalVariables.sharedManager.startTime = Date()
        self.locationManager = CLLocationManager()
        self.locationManager.requestAlwaysAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.distanceFilter = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
        // Initiate user-route updating and set start time.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last! as CLLocation
        let wpt: Waypoint = Waypoint(coordinate: location.coordinate, name: "\(actualWaypointNumber)")
        actualWaypoints.append(wpt)
        actualWaypointNumber = actualWaypointNumber + 1
        GlobalVariables.sharedManager.actualWaypoints.append(wpt)
        if actualWaypointNumber > 2 {
            self.activeDelegate?.appendToDrawnRoute()
        }
        
        if actualWaypointNumber > 1 {
            let prevLocation = CLLocation(latitude: actualWaypoints[actualWaypoints.count-2].coordinate.latitude, longitude: actualWaypoints[actualWaypoints.count-2].coordinate.longitude)
            let tempTotalDistance: Double = location.distance(from: prevLocation)
            self.actualTotalDistance = self.actualTotalDistance + tempTotalDistance
        }
        // Tracks user's position. Sends data to GlobalVariables.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    @IBAction func stopRun() {
        self.locationManager.stopUpdatingLocation()
        performSegue(withIdentifier: "stopRun", sender: self)
    }

    @IBAction func activeRunHelp(_ sender: Any) {
        let infoAlert = UIAlertController(title: "Run Tracking Help", message: "On this page you can see a record of your route on this trip. Select End Run! to stop recording and go back to the Route Planning page. Your total distance and time will be updated to include the distance and time from this trip.", preferredStyle: .alert)
        let agreeAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        infoAlert.addAction(agreeAction)
        self.present(infoAlert, animated: true, completion: nil)
        //Explains Active Run page functionality to user.
    }
    
    
    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "activerunembed" {
            self.activeDelegate = segue.destination as? ActiveMapUI
            let childViewController = segue.destination as? ActiveMapUI
            childViewController?.delegate = self
    //        childViewController?.preselectedRoute = self.presetRoute
  //          childViewController?.waypoints = self.waypoints
            //Define self as delegate for embedded ActiveMapUI.
            //Define embedded ActiveMapUI as delegate for self.
            
        }
        if segue.identifier == "stopRun" {
            print("searchable made it to stopRUN prepare")
            GlobalVariables.sharedManager.hasRunData = true
            GlobalVariables.sharedManager.endTime = Date()
            GlobalVariables.sharedManager.elapsedTimeThisRun = GlobalVariables.sharedManager.endTime!.timeIntervalSince(GlobalVariables.sharedManager.startTime!)
            GlobalVariables.sharedManager.distanceThisRun = self.actualTotalDistance
            super.ref?.child("Users").child(super.userID!).child("totalMins").observeSingleEvent(of: .value, with: { (snapshot) in
                let tempTotalTime = snapshot.value as? TimeInterval
                if var totalTime = tempTotalTime {
                    totalTime = tempTotalTime! + (GlobalVariables.sharedManager.elapsedTimeThisRun! as Double)/60
                    super.ref?.child("Users").child(super.userID!).child("totalMins").setValue(totalTime as Double!)
                    print("searchable totalTime: \(totalTime)")
                }
            })
            
            //test code
            print("searchable time \(GlobalVariables.sharedManager.elapsedTimeThisRun)")
            
            var tempTotalKm: Double?
            super.ref?.child("Users").child(super.userID!).child("KMRun").observeSingleEvent(of: .value, with: { (snapshot) in
                tempTotalKm = snapshot.value as? Double
                print("searchable firebase total km: \(tempTotalKm)")
                if var totalKm = tempTotalKm {
                    totalKm = self.actualTotalDistance/1000 + tempTotalKm!
                    super.ref?.child("Users").child(super.userID!).child("KMRun").setValue(totalKm)
                }
            })
            
            let childViewController = segue.destination as? ViewRunController
    //        childViewController?.route = self.route
      //      childViewController?.presetRoute=self.presetRoute
            
            //Store run data in GlobalVariables and Firebase.
        }
    }
}
