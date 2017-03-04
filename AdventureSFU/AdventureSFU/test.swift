//
//  test.swift
//  asd
//
//  Created by Karan Aujla on 3/2/17.
//  Copyright © 2017 Karan Aujla. All rights reserved.
//

import Foundation

class userProfile {
    var email: String
    var username: String
    var password: String
    // add more things later
    
    init(enteredPassword: String, enteredUsername: String, enteredEmail: String ) {
        //create validations later, right now it is just assuming you entered valid stuff
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
