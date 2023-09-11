//
//  InitalVC.swift
//  MerciApp
//
//  Created by ADMIN on 10/08/18.
//  Copyright © 2018 ADMIN. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class InitalVC: UIViewController
{
    let unique_id = CommonUtilities.shared.getdeviceID()
    var countryarry = [[String:Any]]()
    var HomeReviewsInfo = GetSummary_Reviews()
    var HomeRedemeedInfo = GetSummary_Redemptions()
    var Reviews_Info = [Reviews_DetailsList]()
    var Redemption_Info = [Redemption_DetailsList]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if (UserDefaults.standard.value(forKey: "email") as? String) != nil
        {
            if let email = UserDefaults.standard.object(forKey: "email") as? String {
                if let password = UserDefaults.standard.object(forKey: "password") as? String {
                    HitserviceForLogin(email: email, password: password)
                    }
                }
        }
        else {
            let mainStoryBoard : UIStoryboard!
            mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let navigationController = UINavigationController(rootViewController: vc)
            appDelegate.window?.rootViewController = navigationController
            navigationController.navigationBar.isHidden = true
        }
    }
       
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func HitserviceForLogin(email:String,password:String)
    {
        //MBProgressHUD.showAdded(to: self.view, animated: true)
        var headers: HTTPHeaders = ["Content-Type":"application/json"]
        headers["lang"] = Constants.lang
        let param = [
            "app_key": "merci@#$123",
            "method": "login",
            "email":email,
            "password":password,
            "outlets": [],
            "offers": [],
            "uniqueId": unique_id,
            "start_date": "",
            "end_date": ""
            ] as [String : Any]
        print(param)
        ServiceManager.instance.request(method: .post, URLString:"restaurent", parameters: param as [String : AnyObject], encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
            //MBProgressHUD.hide(for: self.view, animated: true)
            if(error == nil)
            {
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    
                    if let statuscode = dict1["code"] as? NSNumber
                    {
                        if statuscode == 1
                        {
                            
                            if let DataDic = dictionary?["data"]!["result"] as? Dictionary<String,AnyObject>{
                                filters_category.shared.GetSummaryRedemptions.redeemed_offers.removeAll()
                                let summaruobj = GetSummary_Redemptions()
                                let outletobj = GetSummary_Reviews()
                                if let dic = DataDic["summary"] {
                                    if let reviews = dic["reviews"] as? [String : Any] {
                                        
                                        if let staff_avg = reviews["staff_avg"] as? String {
                                            outletobj.staff_avg = staff_avg
                                        }
                                        if let total_reviews = reviews["total_reviews"] as? String {
                                            outletobj.total_reviews = total_reviews
                                        }
                                        if let ambience_avg = reviews["ambience_avg"] as? String {
                                            outletobj.ambience_avg = ambience_avg
                                        }
                                        if let price_avg = reviews["price_avg"]  as? String{
                                            outletobj.price_avg = price_avg
                                        }
                                        if let quality_of_offring_avg = reviews["quality_of_offring_avg"] as? String{
                                            outletobj.quality_of_offring_avg = quality_of_offring_avg
                                        }
                                        if let overall_rating_avg = reviews["overall_rating_avg"] as? String {
                                            outletobj.overall_rating_avg = overall_rating_avg
                                        }
                                    }
                                    if let redemptions = dic["redemptions"] as? [String : Any] {
                                        if let total_redeemed_saving = redemptions["total_redeemed_saving"] as? Int {
                                            summaruobj.total_redeemed_saving = total_redeemed_saving
                                        }
                                        if let redeemed_offers = redemptions["redeemed_offers1"] as? [[String:String]] {
                                            summaruobj.redeemed_offers = redeemed_offers
                                        }
                                    }
                                }
                                
                                filters_category.shared.GetReviews.removeAll()
                                if let reviewarray = DataDic["reviews"] as? [Dictionary<String,AnyObject>]
                                {
                                    
                                    self.Reviews_Info.removeAll()
                                    for info in reviewarray
                                    {
                                        
                                        let reviewobj = Reviews_DetailsList()
                                        if let ambience = info["ambience"] as? String {
                                            reviewobj.ambience = ambience
                                        }
                                        if let country_code = info["country_code"] as? String {
                                            reviewobj.country_code = country_code
                                        }
                                        if let description = info["description"] as? String {
                                            reviewobj.description = description
                                        }
                                        if let mobile_no = info["mobile_no"] as? String {
                                            reviewobj.mobile_no = mobile_no
                                        }
                                        if let overall_rating = info["overall_rating"] as? String {
                                            reviewobj.overall_rating = overall_rating
                                        }
                                        if let price = info["price"] as? String {
                                            reviewobj.price = price
                                        }
                                        if let quality_of_offring = info["quality_of_offring"] as? String {
                                            reviewobj.quality_of_offring = quality_of_offring
                                        }
                                        if let review_date = info["review_date"] as? String {
                                            reviewobj.review_date = review_date
                                        }
                                        if let share_name_email = info["share_name_email"] as? String {
                                            reviewobj.share_name_email = share_name_email
                                        }
                                        if let staff = info["staff"] as? String {
                                            reviewobj.staff = staff
                                        }
                                        if let user_email = info["user_email"] as? String {
                                            reviewobj.user_email = user_email
                                        }
                                        if let user_image = info["user_image"] as? String {
                                            reviewobj.user_image = user_image
                                        }
                                        if let user_name = info["user_name"] as? String {
                                            reviewobj.user_name = user_name
                                        }
                                        filters_category.shared.GetReviews.append(reviewobj)
                                    }
                                }
                                
                                filters_category.shared.GetRedemption.removeAll()
                                if let redemptionarray = DataDic["offers"] as? [Dictionary<String,AnyObject>]
                                {
                                    
                                    self.Redemption_Info.removeAll()
                                    for info in redemptionarray
                                    {
                                        
                                        let redemptionobj = Redemption_DetailsList()
                                        if let redemption_no = info["redemption_no"] as? String {
                                            redemptionobj.redemption_no = redemption_no
                                        }
                                        if let redeem_date = info["redeem_date"] as? String {
                                            redemptionobj.redeem_date = redeem_date
                                        }
                                        if let redeem_time = info["redeem_time"] as? String {
                                            redemptionobj.redeem_time = redeem_time
                                        }
                                        if let restaurent_id = info["restaurent_id"] as? String {
                                            redemptionobj.restaurent_id = restaurent_id
                                        }
                                        if let restaurent_name = info["restaurent_name"] as? String {
                                            redemptionobj.restaurent_name = restaurent_name
                                        }
                                        if let offer_id = info["offer_id"] as? String {
                                            redemptionobj.offer_id = offer_id
                                        }
                                        if let offer_name = info["offer_name"] as? String {
                                            redemptionobj.offer_name = offer_name
                                        }
                                        if let offer_image = info["offer_image"] as? String {
                                            redemptionobj.offer_image = offer_image
                                        }
                                        filters_category.shared.GetRedemption.append(redemptionobj)
                                    }
                                }
                                
                                // Graph data
                                
                                 filters_category.shared.graphdata.removeAll()
                                if let redemptions = DataDic["redemptions"] as? Dictionary<String,AnyObject> {
                                   
                                    
                                    if let graph_data = redemptions["graph_data"] as? [[String:AnyObject]] {
                                        for info in graph_data {
                                            let graphobj = GraphData_model()
                                            if let data = info["data"] as? [[String:Any]] {
                                                graphobj.graph_data = data
                                            }
                                            if let year = info["year"] as? String {
                                                graphobj.year = year
                                            }
                                            if let max_redemptions = info["max_redemptions"] as? Int {
                                                graphobj.max_redemptions = max_redemptions
                                            }
                                            
                                            filters_category.shared.graphdata.append(graphobj)
                                            print(graphobj)
                                            
                                        }
                                        
                                    }
                                   
                                    print(filters_category.shared.graphdata)
                                }
                                filters_category.shared.GetSummary = outletobj
                                filters_category.shared.GetSummaryRedemptions = summaruobj
                                
                                self.HomeReviewsInfo = outletobj
                                self.HomeRedemeedInfo = summaruobj
                                print(self.HomeReviewsInfo)
                                print(self.HomeRedemeedInfo)
                                CommonUtilities.shared.SetSlidemenuhome()
                                self.navigationController?.isNavigationBarHidden = true

//                                UserDefaults.standard.set(self.txtemail.text!, forKey: "signup_info")
//                                self.Summary_tableview.reloadData()
                            }
                        }
                        else
                        {
//                            if let msgstr = dict1["message"] as? String
//                            {
                                let alert = UIAlertController(title: AppName, message:RKLocalizedString(key: "Invalid credentials", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            //}
                        }
                    }
                    
                }
                
            }
        }
    }
    
}
