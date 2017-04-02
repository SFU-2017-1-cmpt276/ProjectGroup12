//
// code seized from Mapbox Offline maps for IOs example
// source url: https://www.mapbox.com/ios-sdk/examples/offline-pack/
// Accessed March 30 2017
//
//  MainMapUI.swift
//
//	AdventureSFU: Make Your Path
//	Created for SFU CMPT 276, Instructor Herbert H. Tsang, P.Eng., Ph.D.
//	AdventureSFU was a project created by Group 12 of CMPT 276
//
//  Created by Group 12 on 3/20/17.
//  Copyright © 2017 . All rights reserved.
//
//	Satellite view map centered on SFU.
//	Programmers: Karan Aujla, Carlos Abaffy, Eleanor Lewis, Chris Norris-Jones
//
//	Known Bugs:
//	Todo:
//


import UIKit
import Mapbox

class MainMapUI: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate {
    var MainMapUI: MGLMapView!
    var progressView: UIProgressView!
    
    //main page's map display
    override func viewDidLoad() {
        super.viewDidLoad()
  
        //draws the map
        MainMapUI = MGLMapView(frame: view.bounds, styleURL: MGLStyle.satelliteStreetsStyleURL(withVersion: 9))
        MainMapUI.delegate = self
        view.addSubview(MainMapUI)
        
        //centres the map to burnaby mountain
        MainMapUI.setCenter(CLLocationCoordinate2D(latitude: 49.273382, longitude: -122.908837),
                            zoomLevel: 13, animated: false)
        
        //Setup offline pack notification handlers.
        NotificationCenter.default.addObserver(self, selector: #selector(offlinePackProgressDidChange), name: NSNotification.Name.MGLOfflinePackProgressChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(offlinePackDidReceiveError), name: NSNotification.Name.MGLOfflinePackError, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(offlinePackDidReceiveMaximumAllowedMapboxTiles), name: NSNotification.Name.MGLOfflinePackMaximumMapboxTilesReached, object: nil)
        
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
            let region = MGLTilePyramidOfflineRegion(styleURL: MainMapUI.styleURL, bounds: sfubounds, fromZoomLevel: MainMapUI.zoomLevel, toZoomLevel: 16)
        print("searchable bounds: \(MainMapUI.visibleCoordinateBounds)")
    
            // Store some data for identification purposes alongside the downloaded resources.
            let userInfo = ["name": "MainMapUI Offline Pack"]
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
    
                // Setup the progress bar.
                if progressView == nil {
                    progressView = UIProgressView(progressViewStyle: .default)
                    let frame = view.bounds.size
                    progressView.frame = CGRect(x: frame.width / 4, y: frame.height * 0.75, width: frame.width / 2, height: 10)
                    view.addSubview(progressView)
                }
    
                progressView.progress = progressPercentage
    
                // If this pack has finished, print its size and resource count.
                if completedResources == expectedResources {
                    let byteCount = ByteCountFormatter.string(fromByteCount: Int64(pack.progress.countOfBytesCompleted), countStyle: ByteCountFormatter.CountStyle.memory)
                    print("Offline pack “\(userInfo["name"])” completed: \(byteCount), \(completedResources) resources")
                } else {
                    // Otherwise, print download/verification progress.
                    print("Offline pack “\(userInfo["name"])” has \(completedResources) of \(expectedResources) resources — \(progressPercentage * 100)%.")
                }
            }
        }
    
        func offlinePackDidReceiveError(notification: NSNotification) {
            if let pack = notification.object as? MGLOfflinePack,
                let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String],
                let error = notification.userInfo?[MGLOfflinePackUserInfoKey.error] as? NSError {
                print("Offline pack “\(userInfo["name"])” received error: \(error.localizedFailureReason)")
            }
        }
    
        func offlinePackDidReceiveMaximumAllowedMapboxTiles(notification: NSNotification) {
            if let pack = notification.object as? MGLOfflinePack,
                let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String],
                let maximumCount = (notification.userInfo?[MGLOfflinePackUserInfoKey.maximumCount] as AnyObject).uint64Value {
                print("Offline pack “\(userInfo["name"])” reached limit of \(maximumCount) tiles.")
            }
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}



