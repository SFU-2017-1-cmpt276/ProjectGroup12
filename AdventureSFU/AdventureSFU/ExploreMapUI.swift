//
//  ExploreMapUI.swift
//  AdventureSFU
//
//  Created by ela50 on 3/19/17.
//  Copyright © 2017 Karan Aujla. All rights reserved.
//

import UIKit
import MapboxDirections
import Mapbox


class ExploreMapUI: MapUI {
    var mapLat: Double?
    var mapLong: Double?
    var exploreTitle: String?
    var target = MGLPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        target.coordinate = CLLocationCoordinate2D(latitude: mapLat!, longitude: mapLong!)
        target.title = exploreTitle
        
        // Add marker `start` to the map.
        MapUI.addAnnotation(target)
        MapUI.userTrackingMode = .follow

        // Do any additional setup after loading the view.
    }
    override func handleSingleTap(tap: UITapGestureRecognizer) {
    //do nooooothing
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
