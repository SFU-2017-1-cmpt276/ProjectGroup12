//
//  ActiveRunController.swift
//  AdventureSFU
//
//  Created by ela50 on 3/14/17.
//  Copyright © 2017 Karan Aujla. All rights reserved.
//

import UIKit
import Mapbox
import MapboxDirections
import Firebase
class ActiveRunController: ViewRunController, ActiveMapViewDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func getTime(time: Double) -> Double? {
        self.time = time

        return time
    }
    
    override func getDistance(distance: Double) -> Double? {
        self.distance = distance/1000

        return distance
        
    }
    
    @IBAction func stopRun() {
        performSegue(withIdentifier: "stopRun", sender: self)
    }
    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "activerunembed" {
            let childViewController = segue.destination as? ActiveMapUI
            childViewController?.delegate = self
            childViewController?.preselectedRoute = self.presetRoute
        }
        if segue.identifier == "stopRun" {
            let childViewController = segue.destination as? ViewRunController
            childViewController?.route = self.route
            childViewController?.presetRoute=self.presetRoute
        }
        //Define self as MapViewDelegate for embedded MapUI.
    }
    
}
