//  ActiveRunController.swift
//
//	AdventureSFU: Make Your Path
//	Created for SFU CMPT 276, Instructor Herbert H. Tsang, P.Eng., Ph.D.
//	AdventureSFU was a project created by Group 12 of CMPT 276
//
//  Created by Group 12 on 3/14/17.
//  Copyright © 2017 . All rights reserved.
//
//	Houses ActiveMapUI. Keeps track of user's route and updates map annotations to include it. Calculates and submits to Firebase
//  user's total distance, time and calories burned at the conclusion of the run.
//	Programmers: Karan Aujla, Carlos Abaffy, Eleanor Lewis, Chris Norris-Jones
//
//	Known Bugs:
//
import UIKit
import Mapbox
import MapboxDirections
import Firebase
import CoreLocation

class ActiveRunController: ViewRunController, ActiveMapViewDelegate, CLLocationManagerDelegate {

    //Variables
    var locationManager:CLLocationManager!
    var actualWaypointNumber: Int = 0
    weak var activeDelegate: ActiveRunControllerDelegate?
    var actualWaypoints: [Waypoint] = []
    let calendar = Calendar.current
    var actualTotalDistance: Double = 0
    var tracking: Bool = true
    
    @IBOutlet weak var runToggle: UIButton!
    
    //Functions
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
        // Initiate user-route updating and set start time. Alternately, set STOP button label to reflect run is not being tracked.
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
                self.submitRunInfo()
                runToggle.setTitle("Start Run", for: [])
                self.tracking = false
            } else {
                self.tracking = true
                runToggle.setTitle("Stop Run", for: [])
                GlobalVariables.sharedManager.startTime = Date()
                self.locationManager.startUpdatingLocation()
            }
        }
        //Allows the user to start and stop run tracking. Each Stopped run is treated as a complete run - stats are submitted.
    }


    
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
        GlobalVariables.sharedManager.endTime = Date()
        GlobalVariables.sharedManager.elapsedTimeThisRun = GlobalVariables.sharedManager.endTime!.timeIntervalSince(GlobalVariables.sharedManager.startTime!)
      //  GlobalVariables.sharedManager.startTime = nil
        GlobalVariables.sharedManager.distanceThisRun = self.actualTotalDistance
        let time = GlobalVariables.sharedManager.elapsedTimeThisRun!
        let seconds = Int(time) % 60;
        let minutes = Int(time / 60) % 60;
        let hours = Int(time / 3600);
        let formattedTime = String(format: "H:M:S: %d:%.2d:%.2d", hours, minutes, seconds)
        
        let formattedDistance = String(format: "Kms: %.2f", GlobalVariables.sharedManager.distanceThisRun/1000)

        let weight: Double = GlobalVariables.sharedManager.weight / 2.2
        let calsBurned: Double = Double(0.0175 * weight * 6*(Double(time/60))) //formula source: www .hss.edu/conditions_burning-calories-with-exercise-calculating-estimated-energy-expenditure.asp

        let formattedCalsBurned = String(format: "Approximate calories burned: %0.f", calsBurned)
        let infoAlert = UIAlertController(title: "Stats for this run:", message: "\(formattedDistance) \(formattedTime), \(formattedCalsBurned)", preferredStyle: .alert)
        let agreeAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        infoAlert.addAction(agreeAction)
        self.present(infoAlert, animated: true, completion: nil)
  
        //calculates total distance, time and calories burned, and reports them to the user
        
        self.ref?.child("Users").child(self.userID!).child("Team").observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
                let tempTeam = snapshot.value as? String
                if let team = tempTeam {
                self.ref?.child("Users").child(self.userID!).child("totalSeconds").observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
                    let tempTotalTime = snapshot.value as? TimeInterval
                    if var totalTime = tempTotalTime {
                        totalTime = tempTotalTime! + (GlobalVariables.sharedManager.elapsedTimeThisRun! as Double)
                        self.ref?.child("Users").child(self.userID!).child("totalSeconds").setValue(totalTime as Double!)
                        self.ref?.child("Teams").child(team).child("Totaltime").observeSingleEvent(of: .value, with: { (snapshot) in
                            let tempTotaltimeT = snapshot.value as? Double
                            if var totaltimeT = tempTotaltimeT {
                                totaltimeT = totaltimeT + (GlobalVariables.sharedManager.elapsedTimeThisRun! as Double)
                                self.ref?.child("Teams").child(team).child("Totaltime").setValue(totaltimeT)
                                GlobalVariables.sharedManager.elapsedTimeThisRun = 0
                            }
                        })
                    }
                }) //updates Firebase user and team records with time from this run
                self.ref?.child("Users").child(self.userID!).child("KMRun").observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
                    let tempTotalDistance = snapshot.value as? Double
                    if var totalKM = tempTotalDistance {
                        totalKM = tempTotalDistance! + (self.actualTotalDistance/1000 as Double)                   
                        self.ref?.child("Users").child(self.userID!).child("KMRun").setValue(totalKM)
                        self.ref?.child("Teams").child(team).child("TotalKm").observeSingleEvent(of: .value, with: { (snapshot) in
                            let tempTotalDistanceT = snapshot.value as? Double

                            if var totalkmT = tempTotalDistanceT {
                                totalkmT = totalkmT + (self.actualTotalDistance/1000 as Double)
                                self.ref?.child("Teams").child(team).child("TotalKm").setValue(totalkmT)
                                self.actualTotalDistance = 0
                            }
                        })
                    }
                }) //updates Firebase user and team records with distance from this run
  
                var tempTotalCals: Double?
                self.ref?.child("Users").child(self.userID!).child("TotalCalories").observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
                    tempTotalCals = snapshot.value as? Double
                    if var totalCals = tempTotalCals {
                        totalCals = tempTotalCals! + calsBurned
                        self.ref?.child("Users").child(self.userID!).child("TotalCalories").setValue(totalCals as Double!)
                    }
                })
            } //updates Firebase user record with calories burned on this run
        })
    } //calculates total distance, time and calories burned on this run, reports them to the user, and updates the user's and user's team's records on Firebase.
}
