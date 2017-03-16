//
//  ActiveMapUI.swift
//  AdventureSFU
//
//  Created by ela50 on 3/14/17.
//  Copyright © 2017 Karan Aujla. All rights reserved.
//

import UIKit
import Mapbox
import MapboxDirections
import Firebase


class ActiveMapUI: MapUI {

    var activeDelegate: ActiveMapViewDelegate?
  //  var route: Route?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MapUI.userTrackingMode = .follow
//        if (route != nil) {
//        var routeCoordinates = route!.coordinates!
//        let routeLine = MGLPolyline(coordinates: &routeCoordinates, count: route!.coordinateCount)
//        self.MapUI.addAnnotation(routeLine)
//        self.MapUI.setVisibleCoordinates(&routeCoordinates, count: route!.coordinateCount, edgePadding: .zero, animated: true)
//        //redraw route
//        }
        // Do any additional setup after loading the view.
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
