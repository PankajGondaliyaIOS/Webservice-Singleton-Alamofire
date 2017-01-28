//
//  NetworkManager.swift
//  WebserviceSingletonAlamofire
//
//  Created by Pankaj on 21/11/16.
//  Copyright © 2016 Pankaj. All rights reserved.
//

import Foundation
import Alamofire


public class NetworkManager {
    
    let baseUrlDev:String        = "Set base your url here"

    static var instance: NetworkManager?
    
    static func sharedInstance() -> NetworkManager {
        if self.instance == nil {
            self.instance = NetworkManager()
        }
        return self.instance!
    }
    
    let headers: HTTPHeaders = [
        //"Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
        //"Accept": "application/json"
    :]
    
    //MARK:
    //MARK: Post
     func POST(urlString: String, paramaters: [String: AnyObject]? = nil, showLoader: Bool? = nil, success:@escaping (_ responseObject:AnyObject?) -> Void, failure: @escaping (_ error: String?) -> Void) {
        
        switch checkInternetConnection() {
        case .Available:
            //ActivityIndicator.sharedInstance().showIndicatorFromClass()
            Alamofire.request(baseUrlDev.add(urlString: urlString), method: .post, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler: { (responseData) in
                print(responseData.result)
                
                if (responseData.result.error == nil && responseData.result.isSuccess == true) {
                    
                    if BaseService.sharedInstance().isResponseSuccess((responseData.result.value! as AnyObject?)!) {
                        success (responseData.result.value! as AnyObject?)
                    } else {
                        print(responseData.result.value)
                        failure (StaticString.SomeError)
                    }
                } else {
                    //ActivityIndicator.sharedInstance().hideIndicatorFromClass()
                    showToastWithMessage(message: StaticString.ServerError)
                    failure (StaticString.ServerError)
                }
            })
        case .NotAvailable:
            //ActivityIndicator.sharedInstance().hideIndicatorFromClass()
            showToastWithMessage(message: StaticString.InternetConnectionAlert)
            failure(StaticString.InternetConnectionAlert)
        }
    }
    
    //MARK:
    //MARK: Get
    func GET(urlString: String, showLoader: Bool? = nil, success:@escaping (_ responseObject:AnyObject?) -> Void, failure: @escaping (_ error: String?) -> Void) {
        
        switch checkInternetConnection() {
        case .Available:
            
            Alamofire.request(baseUrlDev.add(urlString: urlString) , method: .get, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler: { (responseData) in
                print(responseData.result)
                
                if (responseData.result.error == nil && responseData.result.isSuccess == true) {
                    
                    if BaseService.sharedInstance().isResponseSuccess((responseData.result.value! as AnyObject?)!) {
                        success (responseData.result.value! as AnyObject?)
                    } else {
                        print(responseData.result.value)
                        failure (StaticString.SomeError)
                    }
                } else {
                    // ActivityIndicator.sharedInstance().hideIndicatorFromClass()
                    showToastWithMessage(message: StaticString.ServerError)
                    failure (StaticString.ServerError)
                }
            })
        case .NotAvailable:
            //ActivityIndicator.sharedInstance().hideIndicatorFromClass()
            showToastWithMessage(message: StaticString.InternetConnectionAlert)
            failure(StaticString.InternetConnectionAlert)
        }
    }

    //MARK:
    //MARK: Download
    func Download(urlString: String, progress:(_ downloadPercentage: Float?)->Void, success:@escaping (_ responseObject:AnyObject?) -> Void, failure: @escaping (_ error: String?) -> Void) {
        
        switch checkInternetConnection() {
        case .Available:
            let utilityQueue = DispatchQueue.global(qos: .utility)
            Alamofire.download(baseUrlDev.add(urlString: urlString))
                .downloadProgress(queue: utilityQueue) { progress in
                    print("Download Progress: \(progress.fractionCompleted)")
                }
                .responseData { response in
                    if let data = response.result.value  {
                        print(data)
                        success ("Download has been completed" as AnyObject?)
                        print("Download has been completed")
                    } else {
                        failure ("Error occured in downloading")
                    }
            }
        case .NotAvailable:
            //ActivityIndicator.sharedInstance().hideIndicatorFromClass()
            showToastWithMessage(message: StaticString.InternetConnectionAlert)
            failure(StaticString.InternetConnectionAlert)
        }
    }
    
    //MARK:
    //MARK: Upload
    func POSTWithUploads(urlString:String, paramaters: [String: AnyObject]? = nil, dictImages:Dictionary<String, AnyObject>? = nil,showLoader: Bool? = nil, success:@escaping (_ responseObject:AnyObject?) -> Void, failure: @escaping (_ error: String?) -> Void) {
        switch checkInternetConnection() {
        case .Available:
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    
                    if (dictImages != nil) {
                        let arrKey = Array(dictImages!.keys)
                        let arrValue = Array(dictImages!.values)
                        
                        for index in 0 ..< dictImages!.count {
                            if let imageData = UIImageJPEGRepresentation(arrValue[index] as! UIImage, 0.5) {
                                multipartFormData.append(imageData, withName: arrKey[index], fileName: "file.png", mimeType: "image/png")
                            }
                        }
                    }
                    
                    for (key, value) in paramaters!  {
//                        let data = (value as! String).data(using: .utf8)
                        multipartFormData.append((value as! String).data(using: .utf8)!, withName: key )
                    }
                },
                to: baseUrlDev.add(urlString: urlString),
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { responseData in
                            
                            if (responseData.result.error == nil && responseData.result.isSuccess == true) {
                               
                                if BaseService.sharedInstance().isResponseSuccess((responseData.result.value! as AnyObject?)!) {
                                    success (responseData.result.value! as AnyObject?)
                                } else {
                                    print(responseData.result.value)
                                    failure (StaticString.SomeError)
                                }
                            } else {
                                showToastWithMessage(message: StaticString.ServerError)
                                failure (StaticString.ServerError)
                            }
                            //debugPrint(responseData)
                        }
                    case .failure( _):
                        showToastWithMessage(message: StaticString.ServerError)
                        failure (StaticString.ServerError)
                    }
                }
            )
        case .NotAvailable:
            //ActivityIndicator.sharedInstance().hideIndicatorFromClass()
            showToastWithMessage(message: StaticString.InternetConnectionAlert)
            failure(StaticString.InternetConnectionAlert)
        }
    }

}

extension NetworkManager {
    func checkInternetConnection() -> NetworkConnection {
        if Config.isNetworkAvailable() {
            return .Available
        }
        return .NotAvailable
    }
}


//MARK: - Internet Connection
enum NetworkConnection {
    case Available
    case NotAvailable
}

class BaseService {
   
    static var instance: BaseService?
    
    static func sharedInstance() -> BaseService {
        if self.instance == nil {
            self.instance = BaseService()
        }
        return self.instance!
    }
    
    public func isResponseSuccess(_ responseObject:AnyObject) -> Bool {
        //let response = responseObject as! NSDictionary
        //let name = response["key"]
        var status : String!
        status = responseObject["STATUS"] as! String
        
        if Int(status) == 1 { // Success
            return true
        }
        else {
            let message: String = responseObject["MESSAGE"] as! String
            print(message)
            showToastWithMessage(message: message)
            return false
        }
    }

}

