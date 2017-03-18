//
//  GlobalVariables.swift
//  AdventureSFU
//
//  Created by Eleanor on 3/18/17.
//  Copyright © 2017 Karan Aujla. All rights reserved.
//

import UIKit
import Mapbox
import Firebase
import MapboxDirections

class GlobalVariables {
    
    // These are the properties you can store in your singleton
    var waypoints: [Waypoint] = []
    
    
    // Here is how you would get to it without there being a global collision of variables.
    // , or in other words, it is a globally accessable parameter that is specific to the
    // class.
    class var sharedManager: GlobalVariables {
        struct Static {
            static let instance = GlobalVariables()
        }
        return Static.instance
    }
}
