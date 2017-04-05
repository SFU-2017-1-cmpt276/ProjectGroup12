//
//  MainViewController.swift
//
//	AdventureSFU: Make Your Path
//	Created for SFU CMPT 276, Instructor Herbert H. Tsang, P.Eng., Ph.D.
//	AdventureSFU was a project created by Group 12 of CMPT 276
//
//  Created by Group 12 on 3/2/17.
//  Copyright © 2017 . All rights reserved.
//
//	MainViewController - The Main screen, that allows users to go to the various application modules
//	Programmers: Karan Aujla, Carlos Abaffy, Eleanor Lewis, Chris Norris-Jones
//
//	Known Bugs:
//	Todo:
//		
//
import UIKit
import Firebase
import Mapbox

class MainViewController: UIViewController, UITextFieldDelegate, MGLMapViewDelegate {
    
    //Variables
    
    var ref: FIRDatabaseReference?
    //var databaseHandle: FIRDatabaseHandle?
    var mapView: MGLMapView?
    @IBOutlet weak var welcomeUserLabel: UILabel!
    let defaultWIPMessage = "This module is still in development!"
    
    //Functions
    //Load Actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // get the uid for the logged in user
        let userID = FIRAuth.auth()?.currentUser?.uid
        GlobalVariables.sharedManager.userID = userID
        mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.outdoorsStyleURL(withVersion: 9))
        mapView?.delegate = self
GlobalVariables.sharedManager.mapView = self.mapView
        //and get a reference to the database
        ref = FIRDatabase.database().reference()
        GlobalVariables.sharedManager.ref = ref
        ref?.child("Users").child(userID!).child("firstLogin").observeSingleEvent(of: .value, with: { (snapshot) in
            //if it is the first time the user logged in, present the team select page
            let value = snapshot.value as? Bool
            let condition = value!
            if(condition == true) {
                self.performSegue(withIdentifier: "TeamSelect", sender: self)
            }
            
        })
        
        ref?.child("Users").child(userID!).child("username").observeSingleEvent(of: .value, with: { (snapshot) in
            //pull the user's name and display a welcome message
            let value = snapshot.value as? String
            let username = value!
            
            self.welcomeUserLabel.text = "Welcome, \(username)!"
            
        })

        ref?.child("Users").child(userID!).child("weight").observeSingleEvent(of: .value, with: { (snapshot) in
            //pull the user's weight
            let value = snapshot.value as? Double
            let weight = value!
            
            GlobalVariables.sharedManager.weight = weight
            
        }) //loading this variable now to reduce delay when calories burned is calculated
     
        ref?.child("Users").child(userID!).child("totalSeconds").observeSingleEvent(of: .value, with: { (snapshot) in
            //pull the user's name and display a welcome message
            let timevalue = snapshot.value as? Double
            let time = timevalue!
            self.ref?.child("Users").child(userID!).child("KMRun").observeSingleEvent(of: .value, with: { (snapshot) in
                //pull the user's name and display a welcome message
                let distancevalue = snapshot.value as? Double
                let distance = distancevalue!
            
                if (distance > 0.0 && time > 0.0) {
                    let avgSpeed = distance / (Double(time / 3600.0))
                    if (avgSpeed > 0.0) {
                        GlobalVariables.sharedManager.avgSpeed = avgSpeed
                    }
                }

                //Updates the time stat of the planned route with the user's average speed if initialized or the Mapbox time estimate.
            })
        })//loading to prevent conflicts due to asynchronicity in firebase methods in planned route time estimation
        

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Actions
    
    @IBAction func logoutAction(){
        //Call to firebase to logout, then move back to ViewController
        try! FIRAuth.auth()?.signOut()
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func toStatsPage() {
        performSegue(withIdentifier: "mainToStats", sender: self)
    }
    
    @IBAction func toRunControllerPage() {
        performSegue(withIdentifier: "mainToRunController", sender: self)
    }
    
    @IBAction func toExploreControllerPage() {
        performSegue(withIdentifier: "mainToExplore", sender: self)
    }
    
    @IBAction func loadOfflineMap(_ sender: AnyObject) {
        
  
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.offlinePackProgressDidChange), name: NSNotification.Name.MGLOfflinePackProgressChanged, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.offlinePackDidReceiveError), name: NSNotification.Name.MGLOfflinePackError, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.offlinePackDidReceiveMaximumAllowedMapboxTiles), name: NSNotification.Name.MGLOfflinePackMaximumMapboxTilesReached, object: nil)
            self.mapViewDidFinishLoadingMap(self.mapView!)
    }

       
        
        
        

    @IBAction func toTeamsPage() {
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        ref?.child("Users").child(userID!).child("Team").observeSingleEvent(of: .value, with: { (snapshot) in

            let value = snapshot.value as? String
            let team = value!
            
            //displays alert if user has no team
            if team == "No Team" {
                let alert = UIAlertController(title: "You are not in a Team",
                                              message: "Team Stats are only available for those who are in a team. If you wish access Team Stats, select a team from the Stats page.",
                                              preferredStyle: .alert)
                
                let alertConfirmation = UIAlertAction(title: "ok", style: .default, handler: nil)
                
                alert.addAction(alertConfirmation)
                self.present(alert, animated: true, completion: nil)
            }
            
            //goes to Team page 
            else {
                self.performSegue(withIdentifier: "toTeams", sender: self)
            }
            
        })
    }
    
    
       func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        // Start downloading tiles and resources for z13-16.
        startOfflinePackDownload()
    }

    deinit {
        // Remove offline pack observers.
        NotificationCenter.default.removeObserver(self)
    }
    func startOfflinePackDownload() {
        // Create a region that includes the current viewport and any tiles needed to view it when zoomed further in.
        // Because tile count grows exponentially with the maximum zoom level, you should be conservative with your `toZoomLevel` setting.
        let swcoord = CLLocationCoordinate2D(latitude: 49.261120, longitude: -122.953269)
        let necoord = CLLocationCoordinate2D(latitude: 49.292817, longitude: -122.892581)
        let sfubounds = MGLCoordinateBounds(sw: swcoord, ne: necoord)
        let region = MGLTilePyramidOfflineRegion(styleURL: mapView?.styleURL, bounds: sfubounds, fromZoomLevel: (mapView?.zoomLevel)!, toZoomLevel: 16)
        print("searchable mapui bounds: \(self.mapView?.visibleCoordinateBounds)")

        // Store some data for identification purposes alongside the downloaded resources.
        let userInfo = ["name": "MapUI Offline Pack"]
        let context = NSKeyedArchiver.archivedData(withRootObject: userInfo)

        // Create and register an offline pack with the shared offline storage object.

        MGLOfflineStorage.shared().addPack(for: region, withContext: context) { (pack, error) in
            guard error == nil else {
                // The pack couldn’t be created for some reason.
                print("Error: \(String(describing: error?.localizedDescription))")
                return
            }

            // Start downloading.
            pack!.resume()
        }

    }


    // MARK: - MGLOfflinePack notification handlers

    func offlinePackProgressDidChange(notification: NSNotification) {
        // Get the offline pack this notification is regarding,
        // and the associated user info for the pack; in this case, `name = My Offline Pack`
        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String] {
            let progress = pack.progress
            // or notification.userInfo![MGLOfflinePackProgressUserInfoKey]!.MGLOfflinePackProgressValue
            let completedResources = progress.countOfResourcesCompleted
            let expectedResources = progress.countOfResourcesExpected

            // Calculate current progress percentage.
            let progressPercentage = Float(completedResources) / Float(expectedResources)


            // If this pack has finished, print its size and resource count.
            if completedResources == expectedResources {
                let byteCount = ByteCountFormatter.string(fromByteCount: Int64(pack.progress.countOfBytesCompleted), countStyle: ByteCountFormatter.CountStyle.memory)
                print("Offline pack “\(String(describing: userInfo["name"]))” completed: \(byteCount), \(completedResources) resources")
            } else {
                // Otherwise, print download/verification progress.
                print("Offline pack “\(String(describing: userInfo["name"]))” has \(completedResources) of \(expectedResources) resources — \(progressPercentage * 100)%.")
            }
        }
    }


    func offlinePackDidReceiveError(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String],
            let error = notification.userInfo?[MGLOfflinePackUserInfoKey.error] as? NSError {
            print("Offline pack “\(String(describing: userInfo["name"]))” received error: \(String(describing: error.localizedFailureReason))")
        }
    }

    func offlinePackDidReceiveMaximumAllowedMapboxTiles(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String],
            let maximumCount = (notification.userInfo?[MGLOfflinePackUserInfoKey.maximumCount] as AnyObject).uint64Value {
            print("Offline pack “\(String(describing: userInfo["name"]))” reached limit of \(maximumCount) tiles.")
        }
    }




}
