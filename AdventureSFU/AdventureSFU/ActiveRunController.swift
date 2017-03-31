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
// - straighten out naming/units of total time in Firebase and Global variables.
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
    var tracking: Bool = true

    
    override func getDistanceAndTime(distance: Double, time: Double) {
        //prevents this inherited function from doing anything.
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
            runToggle.setTitle("Stop Run", for: [])
        } else {
            runToggle.setTitle("Not tracking run", for: [])
        }
        // Initiate user-route updating and set start time.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last! as CLLocation
        let wpt: Waypoint = Waypoint(coordinate: location.coordinate, name: "\(actualWaypointNumber)")
        //Gets user's current location.
        
        actualWaypoints.append(wpt)
        actualWaypointNumber = actualWaypointNumber + 1
        GlobalVariables.sharedManager.actualWaypoints.append(wpt)
        if actualWaypointNumber > 2 {
            self.activeDelegate?.appendToDrawnRoute()
        }
        // Draws user's latest movement to map.
        
        if actualWaypointNumber > 1 {
            let prevLocation = CLLocation(latitude: actualWaypoints[actualWaypoints.count-2].coordinate.latitude, longitude: actualWaypoints[actualWaypoints.count-2].coordinate.longitude)
            let tempTotalDistance: Double = location.distance(from: prevLocation)
            self.actualTotalDistance = self.actualTotalDistance + tempTotalDistance
        }
        //Updates distance travelled in GlobalVariables.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  

    @IBAction func stopRun(_ sender: UIButton) {
        if (CLLocationManager.locationServicesEnabled()) {
        if (self.tracking == true)  {
            self.locationManager.stopUpdatingLocation()
        //performSegue(withIdentifier: "stopRun", sender: self)
            self.submitRunInfo()
            //print("sender.title: \(sender.titleLabel)")
           runToggle.setTitle("Start Run", for: [])
            self.tracking = false
        } else {
            self.tracking = true
            runToggle.setTitle("Stop Run", for: [])
            GlobalVariables.sharedManager.startTime = Date()
            self.locationManager.startUpdatingLocation()
            
        }
        }
      // dismiss(animated: false, completion: nil)
    } //Discontinues user tracking and sends user back to Route Planner page.
 //   @IBOutlet weak var runToggleButton: UIButton!

    @IBOutlet weak var runToggle: UIButton!
    
    @IBAction func activeRunHelp(_ sender: UIButton) {
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
        } //sets self and embedded map as delegates of each other.
        }
    
    @IBAction func dismissActive(_ sender: AnyObject) {
        dismiss(animated: false, completion: nil)
    }
   
    func submitRunInfo() {
            GlobalVariables.sharedManager.hasRunData = true
            GlobalVariables.sharedManager.endTime = Date()
            GlobalVariables.sharedManager.elapsedTimeThisRun = GlobalVariables.sharedManager.endTime!.timeIntervalSince(GlobalVariables.sharedManager.startTime!)
            GlobalVariables.sharedManager.startTime = nil
            GlobalVariables.sharedManager.distanceThisRun = self.actualTotalDistance
   
            super.ref?.child("Users").child(super.userID!).child("Team").observeSingleEvent(of: .value, with: { (snapshot) in
                let tempTeam = snapshot.value as? String
                if let team = tempTeam {
                super.ref?.child("Users").child(super.userID!).child("totalSeconds").observeSingleEvent(of: .value, with: { (snapshot) in
                    let tempTotalTime = snapshot.value as? TimeInterval
                    if var totalTime = tempTotalTime {
                        totalTime = tempTotalTime! + (GlobalVariables.sharedManager.elapsedTimeThisRun! as Double)
                        super.ref?.child("Users").child(super.userID!).child("totalSeconds").setValue(totalTime as Double!)
                        super.ref?.child("Teams").child(team).child("Totaltime").observeSingleEvent(of: .value, with: { (snapshot) in
                            let tempTotaltimeT = snapshot.value as? Double
                            if var totaltimeT = tempTotaltimeT {
                                totaltimeT = totaltimeT + (GlobalVariables.sharedManager.elapsedTimeThisRun! as Double)
                                super.ref?.child("Teams").child(team).child("Totaltime").setValue(totaltimeT)
                                GlobalVariables.sharedManager.elapsedTimeThisRun = 0
                            }
                        })
                    }
                })
                    
                var tempTotalKm: Double?
                super.ref?.child("Users").child(super.userID!).child("KMRun").observeSingleEvent(of: .value, with: { (snapshot) in
                tempTotalKm = snapshot.value as? Double
                if var totalKm = tempTotalKm {
                    totalKm = self.actualTotalDistance/1000 + tempTotalKm!
                    let kmUpdate = self.actualTotalDistance/1000
                    super.ref?.child("Users").child(super.userID!).child("KMRun").setValue(totalKm)
                        super.ref?.child("Teams").child(team).child("TotalKm").observeSingleEvent(of: .value, with: { (snapshot) in
                            let tempTotalKmT = snapshot.value as? Double
                            if var totalKmT = tempTotalKmT {
                                totalKmT = totalKmT + kmUpdate
                                super.ref?.child("Teams").child(team).child("TotalKm").setValue(totalKmT)
                            }
                        })
                        super.ref?.child("Users").child(super.userID!).observe(FIRDataEventType.value, with: { (snapshot) in
                            if let data = snapshot.value as? [String : AnyObject] {
                                super.ref?.child("Teams").child(team).child(super.userID!).setValue(data)
                                self.actualTotalDistance = 0
                            }
                        })
                    }
                })
            }
        })
    }
}
