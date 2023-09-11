//
//  Change_EmailVC.swift
//  Merci_Restaurant_App
//
//  Created by RipenApp on 26/10/18.
//  Copyright © 2018 RipenApp. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class Change_EmailVC: UIViewController {

    var Email = ""
     @IBOutlet weak var topview : UIView!
    @IBOutlet var txtemail:UITextField!
    @IBOutlet var lbl_Emailtxt:UILabel!
    
    @IBOutlet weak var lblChangeEmail: UILabel!
    
    @IBOutlet weak var btnSend: MyButton!
    
    let unique_id = CommonUtilities.shared.getdeviceID()
    override func viewDidLoad() {
        super.viewDidLoad()
        lblChangeEmail.text = RKLocalizedString(key: "Change Email", comment: "")
        btnSend.setTitle(RKLocalizedString(key: "SEND", comment: ""), for: .normal)
        lbl_Emailtxt.text = "A link will be sent to your registered email address to reset your password"
        self.topview.layer.shadowColor = UIColor.lightGray.cgColor
        self.topview.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.topview.layer.shadowOpacity = 0.5
        self.topview.layer.shadowRadius = 5.0
        self.topview.layer.masksToBounds = false
        if let email = UserDefaults.standard.object(forKey: "email") as? String {
            Email = email
        }
        lbl_Emailtxt.text = RKLocalizedString(key: "Your current email is" , comment: "") + Email + RKLocalizedString(key:"Do you want to change it?", comment: "") 
      
        
    }
    @IBAction func Backbtn(_ sender : UIButton){
        CommonUtilities.shared.SetSlidemenuhome()
    }

    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    @IBAction func SaveAction(_ sender : UIButton){
        if (txtemail?.text?.isEmpty)!
        {
            let alert = UIAlertController(title: AppName, message: RKLocalizedString(key: "Please Enter Email", comment: "") , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if isValidEmail(testStr: (txtemail?.text!)!) == false{
            let alert = UIAlertController(title: AppName, message:RKLocalizedString(key: "Please Enter a Valid Email", comment: "") , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            Hitservice_updateEmail()
        }
    }
    
    
    
    func Hitservice_updateEmail(){
        
        MBProgressHUD.showAdded(to: self.view.window!, animated: true)
        var headers: HTTPHeaders = ["Content-Type":"application/json"]
            headers["lang"] = Constants.lang
        let Dict = [
            "app_key": "merci@#$123",
            "method": "updateEmail",
            "old_email": Email,
            "new_email": txtemail.text!,
            "uniqueId": unique_id ] as [String : Any]
        
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
                            
                                let alertController = UIAlertController(title: AppName, message: RKLocalizedString(key: "Registered email successfully updated.", comment: "") , preferredStyle: .alert)
                                let saveAction = UIAlertAction(title: "Ok", style: .default, handler: {
                                    alert -> Void in
                                    
                                    CommonUtilities.shared.SetSlidemenuhome()
                                    
                                })
                                alertController.addAction(saveAction)
                                self.present(alertController, animated: true, completion: nil)
                             UserDefaults.standard.removeObject(forKey: "email")
                             UserDefaults.standard.set(self.txtemail.text!, forKey: "email")
                            
                        }
                        else
                        {
                            
                                let alert = UIAlertController(title: AppName, message: RKLocalizedString(key: "Your email is incorrect.", comment: "") , preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            
                        }
                    }
                    
                }
            }
        }
    }
}
