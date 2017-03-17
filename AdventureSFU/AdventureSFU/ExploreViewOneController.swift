//
//  ExploreViewOneController.swift
//  AdventureSFU
//
//  Created by Chris Norris-Jones on 3/16/17.
//  Copyright © 2017 Karan Aujla. All rights reserved.
//

import UIKit

class ExploreViewOneController: UIViewController {

//Variables
    @IBOutlet weak var exploreItemLabel: UILabel!
    @IBOutlet weak var exploreTextLabel: UILabel!

    var exploreTitle:String = ""
    var exploreText:String = ""
    
//Functions
    
//Load Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exploreItemLabel.text = exploreTitle
        exploreTextLabel.text = exploreText

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//Actions
    
    @IBAction func BackButton(){
        dismiss(animated: true, completion: nil)
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
