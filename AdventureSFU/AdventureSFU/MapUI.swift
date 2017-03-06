//
//  MapUI.swift
//  AdventureSFU
//
//  Created by ela50 on 3/4/17.
//  Copyright © 2017 Karan Aujla. All rights reserved.
//

import UIKit
import Mapbox
import MapboxDirections


//  let directions = Directions.shared
var directions = Directions.shared;
//var restorationIdentifier: String? { get set }
class MapUI: UIViewController {
    @IBOutlet var MapUI: MGLMapView!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        MapUI = MGLMapView(frame: view.bounds)
        MapUI.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(MapUI)
        
        // double tapping zooms the map, so ensure that can still happen
        let doubleTap = UITapGestureRecognizer(target: self, action: nil)
        doubleTap.numberOfTapsRequired = 2
      MapUI.addGestureRecognizer(doubleTap)
        
        
        // delay single tap recognition until it is clearly not a double
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        singleTap.require(toFail: doubleTap)
        MapUI.addGestureRecognizer(singleTap)
        

        // convert `mapView.centerCoordinate` (CLLocationCoordinate2D)
        // to screen location (CGPoint)
        let centerScreenPoint: CGPoint = MapUI.convert(MapUI.centerCoordinate, toPointTo: MapUI)
        print("Screen center: \(centerScreenPoint) = \(MapUI.center)")
        // Do any additional setup after loading the view.
    }
    
    var coordinates: [CLLocationCoordinate2D] = []
   
    
    
    
    var waypoints: [Waypoint] = [Waypoint(coordinate: CLLocationCoordinate2D(latitude: 49.273515, longitude: -122.909279), name: "Home"),
                                 Waypoint(coordinate: CLLocationCoordinate2D(latitude: 49.273515, longitude: -122.909279), name: "Home")]
    
    func handleSingleTap(tap: UITapGestureRecognizer) {
        // convert tap location (CGPoint)
        // to geographic coordinates (CLLocationCoordinate2D)
        var location: CLLocationCoordinate2D = MapUI.convert(tap.location(in: MapUI), toCoordinateFrom: MapUI)
        let names = "0"
        print("You tapped at: \(location.latitude), \(location.longitude)")
        
        
        waypoints.append(Waypoint(coordinate: location, name: names))
        
        // remove existing polyline from the map, (re)add polyline with coordinates
        if (MapUI.annotations?.count != nil) {
            MapUI.removeAnnotations(MapUI.annotations!)
        }
        
       // let polyline = MGLPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
        
       // MapUI.addAnnotation(polyline)
        let options = RouteOptions(waypoints: waypoints, profileIdentifier: MBDirectionsProfileIdentifierWalking)
        options.includesSteps = true
      
        
        _ = directions.calculate(options) { (waypoints, routes, error) in
            guard error == nil else {
                print("Error calculating directions: \(error!)")
                return
            }
            
           
            
            if let route = routes?.first, let leg = route.legs.first {
                print("Route via \(leg):")
                
                let distanceFormatter = LengthFormatter()
                let formattedDistance = distanceFormatter.string(fromMeters: route.distance)
                
                let travelTimeFormatter = DateComponentsFormatter()
                travelTimeFormatter.unitsStyle = .short
                let formattedTravelTime = travelTimeFormatter.string(from: route.expectedTravelTime)
                
                print("Distance: \(formattedDistance); ETA: \(formattedTravelTime!)")
                
                for step in leg.steps {
                    print("\(step.instructions)")
                    if step.distance > 0 {
                        let formattedDistance = distanceFormatter.string(fromMeters: step.distance)
                        print("— \(formattedDistance) —")
                    }
                }
                
                if route.coordinateCount > 0 {
                    // Convert the route’s coordinates into a polyline.
                    var routeCoordinates = route.coordinates!
                    let routeLine = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)
                    
                    // Add the polyline to the map and fit the viewport to the polyline.
                    self.MapUI.addAnnotation(routeLine)
                    self.MapUI.setVisibleCoordinates(&routeCoordinates, count: route.coordinateCount, edgePadding: .zero, animated: true)
                }
            }
        }

    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
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


