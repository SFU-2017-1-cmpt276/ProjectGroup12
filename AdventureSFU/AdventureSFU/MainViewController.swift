//
//  MainViewController.swift
//
//	AdventureSFU: Make Your Path
//	Created for SFU CMPT 276, Instructor Herbert H. Tsang, P.Eng., Ph.D.
//	AdventureSFU was a project created by Group 12 of CMPT 276
//
//  Sections of code directing the creation and updating of offline map pack derived from the Mapbox Offline Map iOS Tutorial
//  at https: //www.mapbox.com/ios-sdk/examples/offline-pack/ . Last retrieved April 3, 3017.
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
    var mapView: MGLMapView?
    @IBOutlet weak var welcomeUserLabel: UILabel!
    
    
    //Functions
    //Load Actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // get the uid for the logged in user
        let userID = FIRAuth.auth()?.currentUser?.uid
        //and get a reference to the database
        ref = FIRDatabase.database().reference()

        mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.outdoorsStyleURL(withVersion: 9))
        mapView?.delegate = self
        GlobalVariables.sharedManager.mapView = self.mapView

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
        }) //load weight into GlobalVariables for later use
     
        ref?.child("Users").child(userID!).child("totalSeconds").observeSingleEvent(of: .value, with: { (snapshot) in
            let timevalue = snapshot.value as? Double
            let time = timevalue!
            self.ref?.child("Users").child(userID!).child("KMRun").observeSingleEvent(of: .value, with: { (snapshot) in
                let distancevalue = snapshot.value as? Double
                let distance = distancevalue!
                if (distance > 0.0 && time > 0.0) {
                    let avgSpeed = distance / (Double(time / 3600.0))
                    if (avgSpeed > 0.0) {
                        GlobalVariables.sharedManager.avgSpeed = avgSpeed
                    }
                } else {
                    GlobalVariables.sharedManager.avgSpeed = 0.0
                }
            })
        })//loading user total KM and distance to calculate average speed for later use
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Actions
    
    //logout of firebase and app
    @IBAction func logoutAction(){
        //Call to firebase to logout, then move back to ViewController
        try! FIRAuth.auth()?.signOut()
        dismiss(animated: true, completion: nil)
    }
    
    //navigate to stats page
    @IBAction func toStatsPage() {
        performSegue(withIdentifier: "mainToStats", sender: self)
    }
    
    //navigate to run page
    @IBAction func toRunControllerPage() {
        performSegue(withIdentifier: "mainToRunController", sender: self)
    }
    
    //navigate to explore page
    @IBAction func toExploreControllerPage() {
        performSegue(withIdentifier: "mainToExplore", sender: self)
    }
    
    //load or update offline map pack
    @IBAction func loadOfflineMap(_ sender: AnyObject) {
            NotificationCenter.default.addObserver(self, selector: #selector(self.offlinePackProgressDidChange), name: NSNotification.Name.MGLOfflinePackProgressChanged, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.offlinePackDidReceiveError), name: NSNotification.Name.MGLOfflinePackError, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.offlinePackDidReceiveMaximumAllowedMapboxTiles), name: NSNotification.Name.MGLOfflinePackMaximumMapboxTilesReached, object: nil)
            self.mapViewDidFinishLoadingMap(self.mapView!)
    }

    //summary of buttons on main page
    @IBAction func infoAlert(_ sender: Any) {
        let alert = UIAlertController(title: "Main Page Help",
                                      message: "Select 'Get Offline Map' to download or update a copy of the trail map for offline use. Select Teams to view your team leaderboard and all-team leaderboard. Select Run to plan your route and track your run. Select Explore to go geocaching. Select Stats to view your user information and statistics.",
                                      preferredStyle: .alert)
        let alertConfirmation = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(alertConfirmation)
        self.present(alert, animated: true, completion: nil)
    }
    
    //navigation to Team page
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
    
    
    //Code from here to end obtained from https: //www.mapbox.com/ios-sdk/examples/offline-pack/ , somewhat altered to suit current use. 
    //Last retrieved April 3 2017
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        // Start downloading tiles and resources.
        startOfflinePackDownload()
    }

    deinit {
        // Remove offline pack observers.
        NotificationCenter.default.removeObserver(self)
    }
    
    //downloads the offline pack
    func startOfflinePackDownload() {
        // Create a region that includes the current viewport and any tiles needed to view it when zoomed further in.
        // Because tile count grows exponentially with the maximum zoom level, you should be conservative with your `toZoomLevel` setting.
        let swcoord = CLLocationCoordinate2D(latitude: 49.261120, longitude: -122.953269)
        let necoord = CLLocationCoordinate2D(latitude: 49.292817, longitude: -122.892581)
        let sfubounds = MGLCoordinateBounds(sw: swcoord, ne: necoord)
        let region = MGLTilePyramidOfflineRegion(styleURL: mapView?.styleURL, bounds: sfubounds, fromZoomLevel: (mapView?.zoomLevel)!, toZoomLevel: 16)
        // Store some data for identification purposes alongside the downloaded resources.
        let userInfo = ["name": "MapUI Offline Pack"]
        let context = NSKeyedArchiver.archivedData(withRootObject: userInfo)

        // Create and register an offline pack with the shared offline storage object.

        MGLOfflineStorage.shared().addPack(for: region, withContext: context) { (pack, error) in
            guard error == nil else {
                // The pack couldn’t be created for some reason.
                let alert = UIAlertController(title: "Could not download offline pack",
                                              message: "Unknown error. Please try again later.",
                                              preferredStyle: .alert)
                let alertConfirmation = UIAlertAction(title: "ok", style: .default, handler: nil)
                alert.addAction(alertConfirmation)
                self.present(alert, animated: true, completion: nil)
                return
            }
            // Start downloading.
            pack!.resume()
        }
    }


    // MARK: - MGLOfflinePack notification handlers

    //alerts user when pack is finished downloading
    func offlinePackProgressDidChange(notification: NSNotification) {
        // Get the offline pack this notification is regarding,
        // and the associated user info for the pack; in this case, `name = My Offline Pack`
        if let pack = notification.object as? MGLOfflinePack,
            let _ = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String] {
            let progress = pack.progress
            let completedResources = progress.countOfResourcesCompleted
            let expectedResources = progress.countOfResourcesExpected

            // If this pack has finished, print its size and resource count.
            if completedResources == expectedResources {
                let alert = UIAlertController(title: "Map download complete", message: "", preferredStyle: .alert)
                let alertConfirmation = UIAlertAction(title: "ok", style: .default, handler: nil)
                alert.addAction(alertConfirmation)
                self.present(alert, animated: true, completion: nil)
            } 
        }
    }

    //alerts user of problem downloading pack for miscellaneous errors
    func offlinePackDidReceiveError(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String],
            let error = notification.userInfo?[MGLOfflinePackUserInfoKey.error] as? NSError {
            print("Offline pack “\(String(describing: userInfo["name"]))” received error: \(String(describing: error.localizedFailureReason))")
            let alert = UIAlertController(title: "Could not download offline pack",
                                         message: "Offline pack “\(String(describing: userInfo["name"]))” received error: \(String(describing: error.localizedFailureReason))",
                                         preferredStyle: .alert)
            let alertConfirmation = UIAlertAction(title: "ok", style: .default, handler: nil)
            alert.addAction(alertConfirmation)
            self.present(alert, animated: true, completion: nil)
        }
    }

    //alerts user of problem downloading pack due to maximum tiles downloaded already
    func offlinePackDidReceiveMaximumAllowedMapboxTiles(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String],
            let maximumCount = (notification.userInfo?[MGLOfflinePackUserInfoKey.maximumCount] as AnyObject).uint64Value {
            let alert = UIAlertController(title: "Could not download offline pack", message: "Offline pack “\(String(describing: userInfo["name"]))” reached limit of \(maximumCount) tiles.", preferredStyle: .alert)
            let alertConfirmation = UIAlertAction(title: "ok", style: .default, handler: nil)
            alert.addAction(alertConfirmation)
            self.present(alert, animated: true, completion: nil)
        }
    }




}
