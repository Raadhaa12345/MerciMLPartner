//
//  ServiceManager.swift
//  kestone
//
//  Created by Prankur on 04/07/17.
//  Copyright © 2017 Com.ripenApps. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage


class ServiceManager: NSObject
{
    var reachability : NetworkReachabilityManager?
    static let instance = ServiceManager()
    var alertShowing = false

    enum Method: String
    {
        case GET_REQUEST = "GET"
        case POST_REQUEST = "POST"
        case PUT_REQUEST = "PUT"
        case DELETE_REQUEST = "DELETE"
    }
    
    func request(method: HTTPMethod, URLString: String, parameters: [String : AnyObject]?, encoding: ParameterEncoding, headers:  [String: String]? ,completionHandler: @escaping (_ success:Bool?,[String : AnyObject]?, NSError?) -> ())
    {
        if Reachability.isConnectedToNetwork() == true
        {
                let kApiURL = baseApiUrl + URLString;
                print(kApiURL)
                Alamofire.request(kApiURL, method: method, parameters: parameters, encoding: encoding, headers: headers).response(completionHandler: { (response) in
                    do
                        
                    {
                        if (response.error == nil)
                        {
                            print(response.data ?? "")
                            let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String : AnyObject]
                           // print(jsonResult)
                            completionHandler(true, jsonResult, nil)
                        }
                        else
                        {
                            print(response.error!)
                            completionHandler(false, nil, response.error! as NSError)
                        }
                    }
                    catch let error as NSError
                    {
                        print(error)
                        completionHandler(false, nil, nil)
                    }
                })
            }
            else
        {
                if(!self.alertShowing)
                {
                    
                    self.alertShowing = true
                    
                    let alert = UIAlertController(title: RKLocalizedString(key: "Network Problem", comment: ""), message: RKLocalizedString(key: "kAlertNoNetworkMessage", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (act) in
                            self.alertShowing = false
                        }))
                        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
                    }
                completionHandler(false ,nil, NSError(domain:"somedomain", code:9002))

            }
        }
    }
 
extension UIApplication
{
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController?
    {
        if let nav = base as? UINavigationController
        {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController
        {
            if let selected = tab.selectedViewController
            {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController
        {
            return topViewController(base: presented)
        }
        return base
    }
}
