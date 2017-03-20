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
    
	let itemTitle = ["Procession of the Electric Giants",
	                 "Grassy Tendrils",
	                 "Opposite the Rhododendron",
	                 "Entrance to the Underground",
	                 "The Eleven-Headed Hydra",
	                 "The Tree-King's Throne",
	                 "Off the Beaten Path",
	                 "Overlooking Obstacles",
	                 "The Odd Green Tree",
	                 "The Moss Spider's Den"]
    
    let itemText = ["Standing astride these metal Titans, Near their feet lies your password to write in.",
                    "Tentacles tinged green, covering your prize.",
                    "The ancient sentinel stands tall to time, overlooking what you seek to find.",
                    "Hidden by the door to a subterrean kingdom is the magic word of which you seek.",
                    "It's eleven heads strain gravity's bond, but clutched in its talons is where its treasure's spawned.",
                    "The Tree king holds court over these treacherous steppes, stashed in its throne a gift has been prepped.",
                    "You've come a distance to get here, and you're just steps to your goal.",
                    "Holding sentry over trails of wood and nail lies your goal.",
                    "This tree looks all wrong. Maybe it's hiding something.",
                    "Careful searching in the moss spider's den, it sleeps for now but stirs now and then.",]
    
    let itemLat = [49.2686422, 49.2879845, 49.2795888, 49.2865413, 49.2862572, 49.2802203, 49.2879318, 49.2760305, 49.2825603, 49.2709056]
    
    let itemLong = [-122.8967410, -122.9388289, -122.9371649, -122.9186634, -122.8993354, -122.8997471, -122.9269216, -122.8955464, -122.9463260, -122.9074156]
    
    let itemPassword = ["Fraser", "Explorer", "Democracy", "Catcher", "Council", "Rainforest", "Horseshoe", "Softly", "Extra", "Compute"]
    
    var selectedRow:Int = -1
    
    @IBOutlet weak var exploreTable: UITableView!
    
//Functions

	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return(itemTitle.count)
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let exploreCell = tableView.dequeueReusableCell(withIdentifier: "exploreCell", for: indexPath) as! ExploreTableViewCell
		exploreCell.colourLight.image = UIImage(named: "red")
		exploreCell.cellTitle.text = itemTitle[indexPath.row]
        exploreCell.layer.backgroundColor = UIColor.clear.cgColor
        exploreCell.contentView.backgroundColor = UIColor.clear

		return(exploreCell)
	}
	
	//Perform an action when a cell on the table is selected
	//Will be set up to go to the Explore Map View page, currently just prints row #
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
        selectedRow = indexPath.row
		self.performSegue(withIdentifier: "exploreDetail", sender: nil)
		
	}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "exploreDetail" {
            let detailView:ExploreViewOneController = segue.destination as! ExploreViewOneController
            detailView.exploreTitle = itemTitle[selectedRow]
            detailView.exploreText = itemText[selectedRow]
            detailView.mapLat = itemLat[selectedRow]
            detailView.mapLong = itemLong[selectedRow]
            detailView.password = itemPassword[selectedRow]
        }

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
