//
//  ViewController.swift
//  WebserviceSingletonAlamofire
//
//  Created by Pankaj on 21/11/16.
//  Copyright © 2016 Pankaj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        callSignInWS()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

//MARK: Webserice Call
extension ViewController {
    
    func callSignInWS() {
        ProfileServices.sharedInstance().signInWithEmail(strEmail: "your email", strPassword: "password", deviceToken: "your token", deviceType: "iOS", success: { (successObject) in
           
            print(successObject)
       
        }) { (failureObject) in
            print(failureObject)
        }
    }
    
}

