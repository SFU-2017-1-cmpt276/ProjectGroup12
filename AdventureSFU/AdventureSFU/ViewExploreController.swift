//
//  ViewExploreController.swift
//
//	AdventureSFU: Make Your Path
//	Created for SFU CMPT 276, Instructor Herbert H. Tsang, P.Eng., Ph.D.
//	AdventureSFU was a project created by Group 12 of CMPT 276
//
//  Created by Group 12 on 3/12/17.
//  Copyright © 2017 . All rights reserved.
//
//	ViewExploreController - The Table Selection page to allow users to select the explore item they would like to find
//	Programmers: Karan Aujla, Carlos Abaffy, Eleanor Lewis, Chris Norris-Jones
//
//	Known Bugs: None Currently
//	Todo:
//

import UIKit
import Firebase

class ViewExploreController: UIViewController, UITableViewDelegate, UITableViewDataSource {

//Variables
    
    var ref: FIRDatabaseReference?
    
    //Used to take in info needed on the Explore One Page. Page makes structs for each table cell, then when cell is selected that specific instance is pushed to view_one page
    struct ExploreItem {
        var title : String?
        var hint : String?
        var lat : Double?
        var long : Double?
        var pass : String?
    }
    
    var done:Int = 0
    var exploreItemArray = [ExploreItem]()
    var selectedRow:Int = -1
    var databaseHandle:FIRDatabaseHandle?
    var numberRows:Int = 5
    var check:Int = 0
    @IBOutlet weak var exploreTable: UITableView!
    
//Functions
    
	//Setting up the Explore Table
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
		//return(itemTitle.count)
        return(numberRows)
	}
	//Further work setting up the specific cells for the table. 
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let exploreCell = tableView.dequeueReusableCell(withIdentifier: "exploreCell", for: indexPath) as! ExploreTableViewCell
        
        ref?.child("ExploreItems").child(String(indexPath.row + 1)).child("Title").observeSingleEvent(of: .value, with: { (snapshot) in
                let tempTitle = snapshot.value as? String
                
                if let actualTitle = tempTitle {
                    exploreCell.cellTitle.text = actualTitle
                }
                
            })

        //Checking database if explore item has been found by user. If it hasn't, show red image, if it has, show green
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref?.child("Users").child(userID!).child("ExploreItems").child(String(indexPath.row)).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? Int
            if (value == 1) {
                exploreCell.colourLight.image = UIImage(named: "green")
            } else {
                exploreCell.colourLight.image = UIImage(named: "red")
            }
        })
        
		return(exploreCell)
	}
	
	//Move to the Explore One page for the selected item when the cell on the table is selected
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
        selectedRow = indexPath.row
        self.performSegue(withIdentifier: "exploreDetail", sender: nil)
		
	}
    //When segueing into the Explore View One page, setting up required variables for the view-one page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "exploreDetail" {
            let detailView:ExploreViewOneController = segue.destination as! ExploreViewOneController
            
            detailView.exploreTitle = exploreItemArray[selectedRow].title!
            detailView.exploreText = exploreItemArray[selectedRow].hint!
            detailView.mapLat = exploreItemArray[selectedRow].lat!
            detailView.mapLong = exploreItemArray[selectedRow].long!
            detailView.password = exploreItemArray[selectedRow].pass!
            detailView.row = selectedRow
        }

    }
	
	//create function that takes in the row number for the cell, and then pushes to mapview page the title for the explore, the map location, the text, the ExploreID
	
//Load Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        //Call the database to reset the number of rows in the table to proper amount in database
        
        ref?.child("ExploreItemTotal").observeSingleEvent(of: .value, with: {(snapshot) in
        
            let tempVal = snapshot.value as? Int
            
            if let actualVal = tempVal {
                self.numberRows = actualVal
            }
            self.exploreTable.reloadData()

        })
        
        done = 1
 

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ref?.child("ExploreItemTotal").observeSingleEvent(of: .value, with: {(snapshot) in
            
            let tempVal = snapshot.value as? Int
            
            if let actualVal = tempVal {
                self.numberRows = actualVal
            }
            self.exploreTable.reloadData()
            
            var count:Int = 0
            self.exploreItemArray = []
            while (count < tempVal!) {
                self.ref?.child("ExploreItems").child(String(count+1)).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    
                    let tempTitle = value?["Title"] as! String
                    let tempLat = value?["Latitude"] as! Double
                    let tempLong = value?["Longitude"] as! Double
                    let tempHint = value?["Hint"] as! String
                    let tempPass = value?["Password"] as! String
                    
                    let eItem = ExploreItem(title: tempTitle, hint: tempHint, lat: tempLat, long: tempLong, pass: tempPass)
                    self.exploreItemArray.append(eItem)
                })
                count += 1
            }
        })
    }
	
//Actions
	@IBAction func toMainControllerPage() {
        dismiss(animated: true, completion: nil)
	}
	
	@IBAction func toCreateExplorePage() {
		performSegue(withIdentifier: "createNewExplore", sender: self)
	}
	
    //Gives high level details for the page
    @IBAction func InfoButton(){
        let infoAlert = UIAlertController(title: "Explore Listing Details", message: "Welcome to the Explore Module! There are numerous treasures and artifacts hidden throughout the forests and trails of the Burnaby Mountains, and on this page you can begin your journey to find them!\n\n Select one of the possible items above to begin the exploration, though if the light next to it is green that means you've already found it!", preferredStyle: .alert)
        let agreeAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        infoAlert.addAction(agreeAction)
        self.present(infoAlert, animated: true, completion: nil)
    }
}
