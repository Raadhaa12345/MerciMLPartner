//
//  design.swift
//  MerciApp
//
//  Created by ADMIN on 01/08/18.
//  Copyright © 2018 ADMIN. All rights reserved.
//
import UIKit
import Foundation

class MyButton: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.backgroundColor = UIColor(red: 229.0/255.0, green: 24.0/255.0, blue: 43.0/255.0, alpha: 1.0)
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor(red: 229.0/255.0, green: 24.0/255.0, blue: 43.0/255.0, alpha: 1.0).cgColor
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowOpacity = 0.5
        self.tintColor = UIColor.white
        self.titleLabel?.font = UIFont(name:"Montserrat-Light", size: 14)!
    }

}
class LblDesign: UILabel {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.font = UIFont(name:"Montserrat-Light", size: 14)!
    }
}
