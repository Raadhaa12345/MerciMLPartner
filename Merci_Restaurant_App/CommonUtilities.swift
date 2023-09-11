//
//  CommonUtilities.swift
//  MerciApp
//
//  Created by ADMIN on 03/08/18.
//  Copyright © 2018 ADMIN. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import MBProgressHUD



class CommonUtilities:NSObject 
{
    static let shared = CommonUtilities()
    
    func getdeviceID() -> String
    {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    func SetSlidemenuhome()
    {
        
                let mainStoryBoard : UIStoryboard
                mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                let Home = mainStoryBoard.instantiateViewController(withIdentifier: "Summary_VC") as! Summary_VC
                let slidemnuvc = mainStoryBoard.instantiateViewController(withIdentifier: "SidemenuViewController") as! SidemenuViewController
                let menu = SWRevealViewController(rearViewController: slidemnuvc, frontViewController: Home)
                menu?.bounceBackOnLeftOverdraw = true
                let mainnav = UINavigationController(rootViewController: menu!)
                mainnav.navigationBar.isHidden = true
                appDelegate.window?.rootViewController = mainnav
                appDelegate.window?.makeKeyAndVisible()
  
    }
    
}
