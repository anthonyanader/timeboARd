//
//  LoginViewController.swift
//  timeboARd
//
//  Created by Hirday Gupta on 21/10/17.
//  Copyright © 2017 Anthony A. Nader. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class LoginViewController: UIViewController {
    private let dataURL = "https://infra-mix-183600.firebaseio.com/"
    
    @IBAction func facebookLogin(sender: AnyObject) {
        
        //Create a reference to a firebase location
        let myRootRef = Firebase(url: dataURL)
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self, handler:{(facebookResult, facebookError) -> Void in
            if facebookError != nil {
                print ("Facebook Login Failed") // indicative placeholder, to be handled
            } else if (facebookResult?.isCancelled)! {
                print ("Facebook Login Cancelled") // indicative placeholder, to be handled
            } else {
                // TODO: Firebase Auth
                // TODO: Proceed to next VC on success
                print ("Facebook Login Success")
            }
        });
    }
}
