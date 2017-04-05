//
//  ViewRunController.swift
//
//	AdventureSFU: Make Your Path
//	Created for SFU CMPT 276, Instructor Herbert H. Tsang, P.Eng., Ph.D.
//	AdventureSFU was a project created by Group 12 of CMPT 276
//
//  Created by Group 12 on 3/2/17.
//  Copyright © 2017 . All rights reserved.
//
//	ViewRunController - A page where users can check out the trails map and plan a route.
//	Programmers: Karan Aujla, Carlos Abaffy, Eleanor Lewis, Chris Norris-Jones
//
//	Known Bugs:	memory leak ~5 mb per page view
//

import UIKit
import Mapbox
import MapboxDirections
import Firebase

class ViewRunController: UIViewController, MapViewDelegate {
    
    //View Outlets
    @IBOutlet weak var distanceField: UILabel!
    @IBOutlet weak var timeField: UILabel!
    
    //Variables
    var time: Double = 0
    var distance: Double = 0
    var ref: FIRDatabaseReference?
    let userID = FIRAuth.auth()?.currentUser?.uid
    weak var RunViewDelegate: RunViewControllerDelegate?
 
    //Functions
    
    
    //Updates the time stat of the planned route with the user's average speed if initialized or the Mapbox time estimate.
    func getDistanceAndTime(distance: Double, time: Double) {
        self.distance = distance/1000
        distanceField.text = String(format: "Kms: %.2f", distance/1000)
        //Updates the distance stat of the planned route.

        let tempSpeed = GlobalVariables.sharedManager.avgSpeed
        self.time = time
        if (tempSpeed! > 0.0) {
            self.time = Double((self.distance / tempSpeed!)*3600)
        }
        let seconds = Int(self.time) % 60;
        let minutes = Int(self.time / 60) % 60;
        let hours = Int(self.time / 3600);
        self.timeField.text = String(format: "H:M:S: %d:%.2d:%.2d", hours, minutes, seconds)
        
    }
    
    //Alerts the user that no more coordinates can be added (limit set by Mapbox).
    func maxPointsAlert() {
        let infoAlert = UIAlertController(title: "Max Coordinates Entered", message: "At most 25 user-entered coordinates can included in a route.", preferredStyle: .alert)
        let agreeAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        infoAlert.addAction(agreeAction)
        self.present(infoAlert, animated: true, completion: nil)
            }
    
 
    

    //IBAction functions
    
    
    //clears current route from memory, then loads stored route, if any, from Firebase

    @IBAction func restoreRoute(_ sender: AnyObject) {
        self.RunViewDelegate?.deleteAllPoints()
        GlobalVariables.sharedManager.plannedWaypoints.removeAll()
        self.getRouteFromDB()
        
    }
    
    //dismisses self and contained mapView
    @IBAction func dismissRunView(_ sender: AnyObject) {
        self.RunViewDelegate?.dismissMapView()
        dismiss(animated: false, completion: nil)
        
    }
    
    //Info for the user about what to do on this page.
    @IBAction func helpPopup(_ sender: Any) {
        let infoAlert = UIAlertController(title: "Route Plan Help", message: "On this page you can plan your route. Select a starting point and subsequent points by single tap to generate a route and get its distance and estimated travel time. Select CLEAR to start over. Select SAVE to keep this route available for when you next log in. Select RESTORE to load a saved route. Select Run! to start tracking your run!", preferredStyle: .alert)
        let agreeAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        infoAlert.addAction(agreeAction)
        self.present(infoAlert, animated: true, completion: nil)
        
    }
    
    //Resets time and distance stats to zero and prompts MapUI to delete the planned route.
    @IBAction func DeleteAllPoints(_ sender: UIButton) {
        GlobalVariables.sharedManager.plannedWaypoints.removeAll()
        self.RunViewDelegate?.deleteAllPoints()
        distanceField.text = String(format: "Kms: %.2f", 0)
        timeField.text = String("H:M:S: 0:00:00")
        
    }
    
      //Submits run plan to Firebase (as a list of coordinates).
    @IBAction func submitRunStats(_ sender: AnyObject) {
        self.ref?.child("Users").child(self.userID!).child("presetRoute").setValue("")
        for wpt in GlobalVariables.sharedManager.plannedWaypoints {
            let key = self.ref?.child("Users").child(self.userID!).child("presetRoute").childByAutoId().key
            let waypt: NSDictionary = ["lat" : wpt.coordinate.latitude,
                                       "long" : wpt.coordinate.longitude]
            self.ref?.child("Users").child(self.userID!).child("presetRoute").updateChildValues(["/\(String(describing: key))" : waypt])
        }
        let alertController = UIAlertController(title: "Run is stored", message:nil, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
      
    }
    
    //Load Actions
    
    //set the Firebase user reference.
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
       
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // one by one, get the coordinates from the preset Route, if any, load them into GlobalVariables
    //and call the MapUI method to add them to the map
    func getRouteFromDB() {
        self.ref?.child("Users").child(userID!).child("presetRoute").queryOrderedByKey().observeSingleEvent(of: .value, with: {
            snapshot in
            for childSnap in snapshot.children{
                guard let childSnapshot = childSnap as? FIRDataSnapshot else {
                    continue
                }
                let id = childSnapshot.key

                self.ref?.child("Users").child(self.userID!).child("presetRoute").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let lat = value!["lat"] as! Double
                    let long = value!["long"] as! Double
                    let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let wpt = Waypoint(coordinate: location, name: String(id))
                    GlobalVariables.sharedManager.plannedWaypoints.append(wpt)
                    self.RunViewDelegate?.handleRoute()
                })
            }
        })
      
    }


    
    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "runpageembed" {
            let childViewController = segue.destination as? MapUI
            childViewController?.delegate = self
            self.RunViewDelegate = segue.destination as? MapUI
        }
        //Define self as MapViewDelegate for embedded MapUI, and embedded MapUI as RunViewDelegate for self.
    }
    
    
}
