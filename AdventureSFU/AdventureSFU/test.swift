//
//  test.swift
//
//	AdventureSFU: Make Your Path
//	Created for SFU CMPT 276, Instructor Herbert H. Tsang, P.Eng., Ph.D.
//	AdventureSFU was a project created by Group 12 of CMPT 276
//
//  Created by Group 12 on 3/2/17.
//  Copyright © 2017 . All rights reserved.
//
//	class: userProfile - defines the userProfile object used in Signup and Login.
//	Programmers: Karan Aujla, Carlos Abaffy, Eleanor Lewis, Chris Norris-Jones
//
//	Known Bugs:
//	Todo:
//

import Foundation
import UIKit

class userProfile {
    
//Variables
    var email: String
    var username: String
    var password: String
    
    
//Functions
    init(enteredPassword: String, enteredUsername: String, enteredEmail: String ) {
        if enteredEmail.isEmpty == false {
            email = enteredEmail
        } else{
            email = "email not found"
        }
        if enteredUsername.isEmpty == false {
            username = enteredUsername
        } else{
            username = "username not found"
        }
        
        if enteredPassword.isEmpty == false {
            password = enteredPassword

        } else{
            password = "password not found"
        }
        
    }
}


var testMessage = "this was defined in a different file"


