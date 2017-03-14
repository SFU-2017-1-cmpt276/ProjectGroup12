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

class ViewExploreController: UIViewController, UITableViewDelegate, UITableViewDataSource {

//Variables
	let list = ["Explore0", "Explore1", "Explore2", "Explore3", "Explore4", "Explore5", "Explore6", "Explore7", "Explore8", "Explore9"]
//Functions

	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return(list.count)
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let exploreCell = tableView.dequeueReusableCell(withIdentifier: "exploreCell", for: indexPath) as! ExploreTableViewCell
		exploreCell.colourLight.image = UIImage(named: "red")
		exploreCell.cellTitle.text = list[indexPath.row]
		exploreCell.backgroundColor = UIColor.clear
		return(exploreCell)
	}
	
	//Perform an action when a cell on the table is selected
	//Will be set up to go to the Explore Map View page, currently just prints row #
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let row = indexPath.row
		print("Row: \(row)")
		
	}
	
	//create function that takes in the row number for the cell, and then pushes to mapview page the title for the explore, the map location, the text, the ExploreID
	
//Load Actions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
//Actions
	@IBAction func toMainControllerPage() {
		performSegue(withIdentifier: "exploreToMain", sender: self)
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
