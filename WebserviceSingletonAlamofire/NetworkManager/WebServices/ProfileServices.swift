//
//  ProfileServices.swift
//  WebserviceSingletonAlamofire
//
//  Created by Pankaj on 22/11/16.
//  Copyright © 2016 Pankaj. All rights reserved.
//

import Foundation


class ProfileServices {
    
    struct WebserviceName {
        static let kSignIn = "login"
    }

    static var instance: ProfileServices?
    
    static func sharedInstance() -> ProfileServices{
        if instance == nil {
            instance = ProfileServices()
            return instance!
        } else {
            return instance!
        }
    }
    
    func signInWithEmail(strEmail: String, strPassword: String, deviceToken: String, deviceType: String, success:(_ responseObject:AnyObject)->Void, failure: ( _ failureObject: AnyObject)->Void) {
       
        // create request parameter
        let requestParameters = ["email_id":strEmail, "password":strPassword, "device_token":deviceToken, "device_type":deviceType]
        
        NetworkManager.sharedInstance().POST(urlString: WebserviceName.kSignIn, paramaters: requestParameters as [String : AnyObject]?, showLoader: true, success: { (successObject) in
            
            print(successObject)
            
        }) { (failureObject) in
            
            print(failureObject)
        }
    }
    
    func downloadFile(urlString: String, progress:(_ downloadPercentage: Float?)->Void, sucess:(_ responseObject:AnyObject)->Void, failure: (_ error:String)->Void) {
        NetworkManager.sharedInstance().Download(urlString: urlString, progress: { (downloadPercentage) in
            print(downloadPercentage)
            }, success: { (completedObject) in
                print(completedObject)
            }) { (failureObject) in
                print(failureObject)
        }
    }
}
