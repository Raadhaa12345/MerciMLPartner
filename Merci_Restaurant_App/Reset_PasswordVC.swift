//
//  Reset_PasswordVC.swift
//  Merci_Restaurant_App
//
//  Created by RipenApp on 26/10/18.
//  Copyright © 2018 RipenApp. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class Reset_PasswordVC: UIViewController {

     @IBOutlet var topview:UIView!
    @IBOutlet var txtoldpassword:UITextField!
    @IBOutlet var txtNewpassword:UITextField!
    @IBOutlet var txtconfirmpassword:UITextField!
    
    @IBOutlet weak var lblOLdPass: UILabel!
    @IBOutlet weak var lnlNewPass: UILabel!
    @IBOutlet weak var lblConPass: UILabel!
    
    @IBOutlet weak var lblResetPass: UILabel!
    
    @IBOutlet weak var btnSave: MyButton!
    
    
    let unique_id = CommonUtilities.shared.getdeviceID()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let placeHoldrFonts = UIFont(name: "Montserrat-Light", size: 15)
               let oldPassword = NSAttributedString(
                   string: RKLocalizedString(key: "Enter Old Password", comment: ""),attributes:[ NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.431372549, green: 0.431372549, blue: 0.431372549, alpha: 1), NSAttributedString.Key.font: placeHoldrFonts as Any] )
        txtoldpassword.attributedPlaceholder = oldPassword
        
              
               let newPassword = NSAttributedString(
                   string: RKLocalizedString(key: "Enter New Password", comment: ""),attributes:[ NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.431372549, green: 0.431372549, blue: 0.431372549, alpha: 1),  NSAttributedString.Key.font: placeHoldrFonts as Any] )
        txtNewpassword.attributedPlaceholder = newPassword
               
               let confirmPassword = NSAttributedString(
                   string: RKLocalizedString(key: "Enter Confirm Password", comment: "") ,attributes:[ NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.431372549, green: 0.431372549, blue: 0.431372549, alpha: 1),  NSAttributedString.Key.font: placeHoldrFonts as Any] )
        txtconfirmpassword.attributedPlaceholder = confirmPassword
        
        lblResetPass.text = RKLocalizedString(key: "Reset Password", comment: "")
        btnSave.setTitle(RKLocalizedString(key: "Save", comment: ""), for: .normal)
        lblOLdPass.text = RKLocalizedString(key: "OLD PASSWORD", comment: "")
        lblConPass.text = RKLocalizedString(key: "NEW PASSWORD", comment: "")
        lnlNewPass.text = RKLocalizedString(key: "CONFIRM PASSWORD", comment: "")
        self.topview.layer.shadowColor = UIColor.lightGray.cgColor
        self.topview.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.topview.layer.shadowOpacity = 0.5
        self.topview.layer.shadowRadius = 5.0
        self.topview.layer.masksToBounds = false
        
    }
    @IBAction func Backbtn(_ sender : UIButton){
        CommonUtilities.shared.SetSlidemenuhome()
    }
    @IBAction func ChangePassowrd (_ sender:UIButton){
        
        if (txtoldpassword?.text?.isEmpty)!
        {
            let alert = UIAlertController(title: AppName, message: RKLocalizedString(key: "Please enter old password.", comment: "") , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else if (txtoldpassword.text?.count)! < 6 {
            let alert = UIAlertController(title: AppName, message: RKLocalizedString(key: "Old password should be minimum 6 characters", comment: "") , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if (txtNewpassword?.text?.isEmpty)!{
            let alert = UIAlertController(title: AppName, message: RKLocalizedString(key: "Please enter new password.", comment: "") , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if (txtNewpassword.text?.count)! < 6
        {
            let alert = UIAlertController(title: AppName, message: RKLocalizedString(key: "New password should be minimum 6 characters.", comment: "") , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else if (txtconfirmpassword?.text?.isEmpty)! {
            let alert = UIAlertController(title: AppName, message: RKLocalizedString(key: "Please enter confirm password.", comment: "") , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if (txtconfirmpassword.text?.count)! < 6
        {
            let alert = UIAlertController(title: AppName, message: RKLocalizedString(key: "Confirm password should be minimum 6 characters.", comment: "") , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else if (txtconfirmpassword?.text?.isEmpty)! || txtconfirmpassword.text != txtNewpassword.text
        {
            let alert = UIAlertController(title: AppName, message: RKLocalizedString(key: "New password and Confirm password does not match", comment: "") , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else{
            Hitservicereset_password()
        }
    }


    var Email = ""
    func Hitservicereset_password(){
        if let email = UserDefaults.standard.object(forKey: "email") as? String {
            Email = email
        }
        MBProgressHUD.showAdded(to: self.view.window!, animated: true)
     var headers: HTTPHeaders = ["Content-Type":"application/json"]
        headers["lang"] = Constants.lang
        let Dict = [
            "app_key": "merci@#$123",
            "method": "changePassword",
            "email":Email,
            "old_password":txtoldpassword.text!,
            "new_password": txtNewpassword.text!,
            "uniqueId":unique_id
            ] as [String : Any]
        
        print(Dict)
        ServiceManager.instance.request(method: .post, URLString: "restaurent", parameters: Dict as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
            MBProgressHUD.hide(for: self.view.window!, animated: true)
            if(error == nil)
            {
                
                if let dict = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    if let statuscode = dict["code"] as? NSNumber
                    {
                        if statuscode == 3
                        {
                            if let msgstr = dict["message"] as? String
                            {
                                let alertController = UIAlertController(title: AppName, message:msgstr, preferredStyle: .alert)
                                let saveAction = UIAlertAction(title: "Ok", style: .default, handler: {
                                    alert -> Void in
                                    let signup = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                                    self.navigationController?.pushViewController(signup, animated: true)
                                    UserDefaults.standard.removeObject(forKey: "signup_info")
                                })
                                alertController.addAction(saveAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                            
                        }
                        else if statuscode == 1
                        {
                            
                            
                                let alertController = UIAlertController(title: AppName, message:RKLocalizedString(key: "Password updated successfully", comment: "") , preferredStyle: .alert)
                                let saveAction = UIAlertAction(title: "Ok", style: .default, handler: {
                                    alert -> Void in
                                    
                                    CommonUtilities.shared.SetSlidemenuhome()
                                 
                                })
                                alertController.addAction(saveAction)
                                self.present(alertController, animated: true, completion: nil)
                            
                            UserDefaults.standard.removeObject(forKey: "password")
                            UserDefaults.standard.set(self.txtconfirmpassword.text!, forKey: "password")
                        }
                        else
                        {
    
                                let alert = UIAlertController(title: AppName, message:RKLocalizedString(key: "Your old password is incorrect", comment: "") , preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            
                            
                        }
                    }
                    
                }
            }
        }
    }
}
