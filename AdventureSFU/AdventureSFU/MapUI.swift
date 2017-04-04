//
//  MapUI.swift
//
//	AdventureSFU: Make Your Path
//	Created for SFU CMPT 276, Instructor Herbert H. Tsang, P.Eng., Ph.D.
//	AdventureSFU was a project created by Group 12 of CMPT 276
//
//  Created by Group 12 on 3/2/17.
//  Copyright © 2017 . All rights reserved.
//
//	MapUI - The signup screen that alows users to create their account
//	Programmers: Karan Aujla, Carlos Abaffy, Eleanor Lewis, Chris Norris-Jones
//
//	Known Bugs:	-Stop warning flags from unused variables from displaying, when variables are in fact being used
//	Todo:	implement double-tap removes points from planned route
//implement scrap it and start over
//implement Active map changes to gesture recognition - fixed route
//implement remove last waypoint
//remove unneeded variables, format, comment, clean up
//use more attractive map
//implement 25 points max
//remove unnecessary vars
//collapse drawRoute and handleRoute?
//load route from DB

import UIKit
import Mapbox
import MapboxDirections
import Firebase

class MapUI: UIViewController, RunViewControllerDelegate, MGLMapViewDelegate {
    
    //View Outlets
    var MapUI: MGLMapView!
    
    //Variables
    weak var delegate: MapViewDelegate?
    var coordinates: [CLLocationCoordinate2D] = []
    var waypoints: [Waypoint] = []
    var directions = Directions.shared;
    var preselectedRoute: Route?
    var names: Int = 0
    var start = MGLPointAnnotation()
    var preselectedWaypoints: [Waypoint] = []
    var ref: FIRDatabaseReference?
    let userID = FIRAuth.auth()?.currentUser?.uid
 
    //Load Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        let hasRoute = String(describing: ref?.child("Users").child(userID!).child("hasPlannedRoute"))
        if hasRoute=="true" {
            //load route from Firebase
        }
        
        //load map and draw planned route
    
        MapUI = GlobalVariables.sharedManager.mapView
      
        
        MapUI = MGLMapView(frame: view.bounds, styleURL: MGLStyle.outdoorsStyleURL(withVersion: 9))
        MapUI.delegate = self
        MapUI.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(MapUI)
        MapUI.setCenter(CLLocationCoordinate2D(latitude: 49.273382, longitude: -122.908837),
                        zoomLevel: 13, animated: false)
        if (GlobalVariables.sharedManager.plannedWaypoints.count > 0) {
            handleRoute()
        }
        
        //define doubleTap so singleTap can be defined relative to it
        let doubleTap = UITapGestureRecognizer(target: self, action: nil)
        doubleTap.numberOfTapsRequired = 2
        MapUI.addGestureRecognizer(doubleTap)
        
        // define singleTap relative to doubleTap
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        singleTap.require(toFail: doubleTap)
        MapUI.addGestureRecognizer(singleTap)
        
        //Setup offline pack notification handlers.
    //    NotificationCenter.default.addObserver(self, selector: #selector(offlinePackProgressDidChange), name: NSNotification.Name.MGLOfflinePackProgressChanged, object: nil)
      //  NotificationCenter.default.addObserver(self, selector: #selector(offlinePackDidReceiveError), name: NSNotification.Name.MGLOfflinePackError, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(offlinePackDidReceiveMaximumAllowedMapboxTiles), name: NSNotification.Name.MGLOfflinePackMaximumMapboxTilesReached, object: nil)
        
        //Load map centred at specified coordinates. Add gesture recognizers doubleTap and singleTap.
    }
//    
//    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
//        // Start downloading tiles and resources for z13-16.
//        startOfflinePackDownload()
//    }
//    
//    deinit {
//        // Remove offline pack observers.
//        NotificationCenter.default.removeObserver(self)
//    }
    
    
    //Functions
    func deleteAllPoints() {
        if (GlobalVariables.sharedManager.plannedWaypoints.count > 0) {
            GlobalVariables.sharedManager.plannedWaypoints.removeAll()
            //delete Global copy of route
        }
        if (MapUI.annotations?.count != nil) {
            MapUI.removeAnnotations(MapUI.annotations!)
            // remove drawn route so new route can be drawn
        }
        //Deletes a planned route.
    }
    
    
//    func startOfflinePackDownload() {
//        // Create a region that includes the current viewport and any tiles needed to view it when zoomed further in.
//        // Because tile count grows exponentially with the maximum zoom level, you should be conservative with your `toZoomLevel` setting.
//        let swcoord = CLLocationCoordinate2D(latitude: 49.261120, longitude: -122.953269)
//        let necoord = CLLocationCoordinate2D(latitude: 49.292817, longitude: -122.892581)
//        let sfubounds = MGLCoordinateBounds(sw: swcoord, ne: necoord)
//        let region = MGLTilePyramidOfflineRegion(styleURL: MapUI.styleURL, bounds: sfubounds, fromZoomLevel: MapUI.zoomLevel, toZoomLevel: 16)
//        print("searchable mapui bounds: \(MapUI.visibleCoordinateBounds)")
//        
//        // Store some data for identification purposes alongside the downloaded resources.
//        let userInfo = ["name": "MapUI Offline Pack"]
//        let context = NSKeyedArchiver.archivedData(withRootObject: userInfo)
//        
//        // Create and register an offline pack with the shared offline storage object.
//        
//        MGLOfflineStorage.shared().addPack(for: region, withContext: context) { (pack, error) in
//            guard error == nil else {
//                // The pack couldn’t be created for some reason.
//                print("Error: \(String(describing: error?.localizedDescription))")
//                return
//            }
//            
//            // Start downloading.
//            pack!.resume()
//        }
//        
//    }
//    
//    
//    // MARK: - MGLOfflinePack notification handlers
//    
//    func offlinePackProgressDidChange(notification: NSNotification) {
//        // Get the offline pack this notification is regarding,
//        // and the associated user info for the pack; in this case, `name = My Offline Pack`
//        if let pack = notification.object as? MGLOfflinePack,
//            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String] {
//            let progress = pack.progress
//            // or notification.userInfo![MGLOfflinePackProgressUserInfoKey]!.MGLOfflinePackProgressValue
//            let completedResources = progress.countOfResourcesCompleted
//            let expectedResources = progress.countOfResourcesExpected
//            
//            // Calculate current progress percentage.
//            let progressPercentage = Float(completedResources) / Float(expectedResources)
//
//            
//            // If this pack has finished, print its size and resource count.
//            if completedResources == expectedResources {
//                let byteCount = ByteCountFormatter.string(fromByteCount: Int64(pack.progress.countOfBytesCompleted), countStyle: ByteCountFormatter.CountStyle.memory)
//                print("Offline pack “\(String(describing: userInfo["name"]))” completed: \(byteCount), \(completedResources) resources")
//            } else {
//                // Otherwise, print download/verification progress.
//                print("Offline pack “\(String(describing: userInfo["name"]))” has \(completedResources) of \(expectedResources) resources — \(progressPercentage * 100)%.")
//            }
//        }
//    }
//    
//    
//    func offlinePackDidReceiveError(notification: NSNotification) {
//        if let pack = notification.object as? MGLOfflinePack,
//            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String],
//            let error = notification.userInfo?[MGLOfflinePackUserInfoKey.error] as? NSError {
//            print("Offline pack “\(String(describing: userInfo["name"]))” received error: \(String(describing: error.localizedFailureReason))")
//        }
//    }
//    
//    func offlinePackDidReceiveMaximumAllowedMapboxTiles(notification: NSNotification) {
//        if let pack = notification.object as? MGLOfflinePack,
//            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String],
//            let maximumCount = (notification.userInfo?[MGLOfflinePackUserInfoKey.maximumCount] as AnyObject).uint64Value {
//            print("Offline pack “\(String(describing: userInfo["name"]))” reached limit of \(maximumCount) tiles.")
//        }
//    }
    
    func handleSingleTap(tap: UITapGestureRecognizer) {
        if GlobalVariables.sharedManager.plannedWaypoints.count < 25 {
        let location: CLLocationCoordinate2D = MapUI.convert(tap.location(in: MapUI), toCoordinateFrom: MapUI)
        let wpt: Waypoint = Waypoint(coordinate: location, name: "\(names)")
        GlobalVariables.sharedManager.plannedWaypoints.append(wpt)
        self.names = self.names + 1
        //update current list of coordinates
        
        // if at least 2 points are specified, calculate and draw route. update local and delegate stats.
        handleRoute()
        } else {
            self.delegate?.maxPointsAlert()
        }
        //Adds selected location to user route.
    }
    
    
    func handleRoute() {
        if GlobalVariables.sharedManager.plannedWaypoints.count > 0 {
            start.coordinate = GlobalVariables.sharedManager.plannedWaypoints[0].coordinate
            start.title="Start"
            MapUI.addAnnotation(start)
            // Add 'start' to map.
            
            
            if GlobalVariables.sharedManager.plannedWaypoints.count > 1 {
                let options = RouteOptions(waypoints: GlobalVariables.sharedManager.plannedWaypoints, profileIdentifier: MBDirectionsProfileIdentifierWalking)
                //define directions info - coordinates and travel speed
                
                _ = directions.calculate(options) { (waypoints, routes, error) in
                    guard error == nil else {
                        return //breaks if route can't be calculated
                    }
                    
                    if let route = routes?.first {
                        self.drawRoute(route: route)
                    }
                }
            } //generates route if there is more than one point. submits it to be drawn.
        }
       
    }

    func drawRoute(route: Route) {
        print("expectedtraveltime: \(route.expectedTravelTime)")
        //passes time and distance to containing view for display to user.
        self.delegate?.getDistanceAndTime(distance: route.distance, time: route.expectedTravelTime)
        var routeCoordinates = route.coordinates!
        let routeLine = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)
        self.MapUI.addAnnotation(routeLine)
        //redraw route
    }
    
    
    func dismissMapView() {
        
        dismiss(animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}


