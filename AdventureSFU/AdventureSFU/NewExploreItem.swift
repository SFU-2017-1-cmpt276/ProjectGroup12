//
//  NewExploreItem.swift
//  AdventureSFU
//
//  Created by Chris Norris-Jones on 3/24/17.
//  Copyright © 2017 Karan Aujla. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class NewExploreItem: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {

//Variables
	
	var spin:Int = -1
	var ref: FIRDatabaseReference?
	var locationManager = CLLocationManager()
	var latitude:Double = 0.0
	var longitude:Double = 0.0
	@IBOutlet weak var exploreTitle: UITextField!
	@IBOutlet weak var explorePassword: UITextField!
	@IBOutlet weak var exploreHint: UITextField!
	
//Functions
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		let locValue:CLLocationCoordinate2D = manager.location!.coordinate
		latitude = locValue.latitude
		longitude = locValue.longitude
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return false
	}
	
	
//Load Actions
    override func viewDidLoad() {
        super.viewDidLoad()
		self.exploreTitle.delegate = self
		self.explorePassword.delegate = self
		self.exploreHint.delegate = self
		self.exploreHint.delegate = self
		
		
		ref = FIRDatabase.database().reference()
		self.locationManager = CLLocationManager()
		self.locationManager.requestAlwaysAuthorization()
		
		if CLLocationManager.locationServicesEnabled() {
			locationManager.delegate = self
			self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
			self.locationManager.distanceFilter = kCLLocationAccuracyBest
			self.locationManager.startUpdatingLocation()
		}

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
//Actions

	@IBAction func toExplorePage() {
		self.locationManager.stopUpdatingLocation()
		dismiss(animated: true, completion: nil)
	}
	
	//Gives high level details for the page
	@IBAction func InfoButton(){
		let infoAlert = UIAlertController(title: "Create Your Own Explore Item!", message: "So you want to create your own place for others to find, eh? Once you're at your desired Explore location, enter in the name for the explore item, the password the user will need to enter to prove they found your location, as well as a short hint! The system will take your details and your coordinates and create a new Explore point, visible on the Explore Listing, for others to find!\n\nRemember this is just like geocaching; when you create your Explore Item in the app, you should actually be putting something with a password on that spot in real life!", preferredStyle: .alert)
		let agreeAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
		infoAlert.addAction(agreeAction)
		self.present(infoAlert, animated: true, completion: nil)
	}
    
	//Creates a New Explore Item, it will be loaded into the database and subsequently displayed on the ViewExploreController page
	@IBAction func CreateExplore() {
		//First make sure fields aren't empty
		if self.exploreTitle.text == "" || self.explorePassword.text == "" || self.exploreHint.text == "" {
			let alertController = UIAlertController(title: "Fields Missing!", message: "Please fill in a Title, Password, and Hint for your Explore Item!", preferredStyle: .alert)
			let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
			alertController.addAction(defaultAction)
			self.present(alertController, animated: true, completion: nil)
		} else {
			//Set call to database
			self.ref?.child("ExploreItems").child("InUse").setValue(1)
			ref?.child("ExploreItemTotal").observeSingleEvent(of: .value, with: {(snapshot) in
				let tempVal = snapshot.value as? Int
				//Iterate on the cell holding the total number of Explore Items in the Database
				if let totalVal = tempVal {
					self.ref?.child("ExploreItemTotal").setValue(totalVal + 1)
				}
                
                //Setup the Explore Item values in database
				let exploreID:Int = tempVal! + 1
				let exploreItemTitle:String = self.exploreTitle.text!
				let exploreItemPassword:String = self.explorePassword.text!
				let exploreItemHint:String = self.exploreHint.text!
				
				self.ref?.child("ExploreItems").child(String(exploreID)).child("Title").setValue(exploreItemTitle)
				self.ref?.child("ExploreItems").child(String(exploreID)).child("Password").setValue(exploreItemPassword)
				self.ref?.child("ExploreItems").child(String(exploreID)).child("Hint").setValue(exploreItemHint)
				self.ref?.child("ExploreItems").child(String(exploreID)).child("Latitude").setValue(self.latitude)
				self.ref?.child("ExploreItems").child(String(exploreID)).child("Longitude").setValue(self.longitude)
			})
			self.ref?.child("ExploreItems").child("InUse").setValue(0)
            //Alert user they've created a new explore item
			let exploreCreateAlert = UIAlertController(title: "Congratulations!", message: "You created an Explore Item! It should be visible on the Explore View screen!", preferredStyle: .alert)
            let finishAction = UIAlertAction(title: "Ok", style: .default, handler: {(action) in
                self.dismiss(animated: true, completion: nil)
            })
			exploreCreateAlert.addAction(finishAction)
			self.present(exploreCreateAlert, animated: true, completion: nil)
		}
	}
}
