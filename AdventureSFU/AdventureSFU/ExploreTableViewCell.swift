//
//  ExploreTableViewCell.swift
//
//	AdventureSFU: Make Your Path
//	Created for SFU CMPT 276, Instructor Herbert H. Tsang, P.Eng., Ph.D.
//	AdventureSFU was a project created by Group 12 of CMPT 276
//
//  Created by Group 12 on 3/12/17.
//  Copyright © 2017 . All rights reserved.
//
//	ExploreTableViewCell - Sets up the custom cells to be used in the table on the ViewExploreController page
//	Programmers: Karan Aujla, Carlos Abaffy, Eleanor Lewis, Chris Norris-Jones
//
//	Known Bugs: None Currently
//	Todo:
//

import UIKit

class ExploreTableViewCell: UITableViewCell {

//Variables
	@IBOutlet weak var colourLight: UIImageView!
	@IBOutlet weak var exploreText: UITextView!
	@IBOutlet weak var cellTitle: UILabel!
	
//Load Actions
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }

}
