//
//  RKLocalization.swift
//  Merci_Restaurant_App
//
//  Created by Arpit_Jain_Mac on 16/06/23.
//  Copyright © 2023 RipenApp. All rights reserved.
//

import Foundation
import UIKit

class RKLocalization: NSObject {
    static let sharedInstance = RKLocalization()
    var bundle: Bundle? = nil
   
    //get localizedString from bundle of selected language
    
    func localizedString(forKey key: String, value comment: String) -> String {
        let localized = bundle!.localizedString(forKey: key, value: comment, table: nil)
        return localized
    }
    
  
    
    func setLanguage(language: String) -> Void {
        let path: String? = Bundle.main.path(forResource: language, ofType: "lproj")
        if path == nil {
            bundle = Bundle.main
        }
        else {
            bundle = Bundle(path: path!)
        }
    }
}


func RKLocalizedString(key: Any, comment: Any) -> String {
    return RKLocalization.sharedInstance.localizedString(forKey: (key as! String), value: (comment as! String))
}



