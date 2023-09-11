//
//  ReviewsVC.swift
//  Merci_Restaurant_App
//
//  Created by RipenApp on 25/10/18.
//  Copyright © 2018 RipenApp. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import AlamofireImage

class ReviewsVC: UIViewController,Reviewfilterprotocol,reviewcleardprotocol {

    let unique_id = CommonUtilities.shared.getdeviceID()
    @IBOutlet weak var topview : UIView!
    @IBOutlet weak var review_tableview:UITableView!
     @IBOutlet weak var open_Sidemenu:UIButton!
     @IBOutlet weak var calenderimg:UIImageView!
    @IBOutlet weak var lblreviews: UILabel!
    
     @IBOutlet weak var No_review:UILabel!
//    var selected_Outlets = [String]()
//    var selected_Offers = [String]()
//    var fromdate = ""
//    var Todate = ""
    var refresh = UIRefreshControl()
    
    var HomeReviewsInfo = GetSummary_Reviews()
    var HomeRedemeedInfo = GetSummary_Redemptions()
    
    
    var Graph_Info = GraphData_model()
    var Reviews_Info = [Reviews_DetailsList]()
    var Redemption_Info = [Redemption_DetailsList]()
    @IBOutlet weak var lbl_Topdate:UILabel!
    
    @IBOutlet weak var dateView_height:NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblreviews.text = RKLocalizedString(key: "Reviews", comment: "")
        self.topview.layer.shadowColor = UIColor.lightGray.cgColor
        self.topview.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.topview.layer.shadowOpacity = 0.4
        self.topview.layer.shadowRadius = 5.0
        self.topview.layer.masksToBounds = false
        review_tableview.tableFooterView = UIView()
        if revealViewController() != nil{
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            let revealViewController = self.revealViewController()
            open_Sidemenu.addTarget(revealViewController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        }
        refresh.backgroundColor = UIColor(displayP3Red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        refresh.tintColor = UIColor(displayP3Red: 42/255, green: 53/255, blue: 117/255, alpha: 1.0)
        refresh.addTarget(self, action: #selector(refrersh_action), for: .valueChanged)
        review_tableview.addSubview(refresh)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if filters_category.shared.GetReviews.count == 0 {
            No_review.isHidden = false
            review_tableview.isHidden = true
        }
        else {
            No_review.isHidden = true
            review_tableview.isHidden = false
        }
        if filters_data.shared.filterSummary.fromdate == ""  || filters_data.shared.filterSummary.todate == "" {
            dateView_height.constant = 0
            lbl_Topdate.text = ""
            calenderimg.isHidden = true
        }
        else {
            lbl_Topdate.text = filters_data.shared.filterSummary.fromdate + " to " + filters_data.shared.filterSummary.todate
            dateView_height.constant = 40
            calenderimg.isHidden = false
        }
        review_tableview.reloadData()
//        if UserDefaults.standard.object(forKey: "filteraplied") as? Bool != nil {
//            let filtercondition = UserDefaults.standard.object(forKey: "filteraplied") as! Bool
//            if filtercondition == true {
//                HitserviceForLogin()
//            }
//            else {
//                self.review_tableview.reloadData()
//            }
//        }
    }
    @objc func refrersh_action(){
        
        refresh.endRefreshing()
        HitserviceForLogin()
    }
    @IBAction func Sidemenu_Action(sender : UIButton)
    {
        let revealViewController = self.revealViewController()
        open_Sidemenu.addTarget(revealViewController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
    }

    
    @IBAction func filter_Action(sender : UIButton)
    {
        let Apply_FilterVC = self.storyboard?.instantiateViewController(withIdentifier: "Apply_FilterVC") as! Apply_FilterVC

        self.navigationController?.pushViewController(Apply_FilterVC, animated: true)
    }
    
    func Apply_filter(selected_outlets:[String],selected_offers:[String],from_date:String,To_date:String) {

    }
    
    func ClearAll() {

    }
    var Email = ""
    var Password = ""
    func HitserviceForLogin()
    {
        
        if let email = UserDefaults.standard.object(forKey: "email") as? String {
            Email = email
        }
        if let password = UserDefaults.standard.object(forKey: "password") as? String {
            Password = password
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = [
            "app_key": "merci@#$123",
            "method": "login",
            "email":Email ,
            "password": Password,
            "outlets":filters_data.shared.filterSummary.selected_Outlets,
            "offers": filters_data.shared.filterSummary.selected_Offers,
            "uniqueId": unique_id,
            "start_date": filters_data.shared.filterSummary.fromdate,
            "end_date": filters_data.shared.filterSummary.todate
            ] as [String : Any]
        print(param)
        ServiceManager.instance.request(method: .post, URLString:"restaurent", parameters: param as [String : AnyObject], encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
            MBProgressHUD.hide(for: self.view, animated: true)
            if(error == nil)
            {
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    
                    if let statuscode = dict1["code"] as? NSNumber
                    {
                        if statuscode == 1
                        {
                            
                            if let DataDic = dictionary?["data"]!["result"] as? Dictionary<String,AnyObject>{
                                
                                
                                let summaruobj = GetSummary_Redemptions()
                                let outletobj = GetSummary_Reviews()
                                
                                filters_category.shared.GetSummaryRedemptions.redeemed_offers.removeAll()
                               
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
                                
                                // Review screen data
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
                                
                                // Redemption screen data
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
                                    
                                    
                                    if let graph_data = redemptions["graph_data"] as? [[String:Any]] {
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
                                        }
                                        
                                    }
                                    
                                }
                                
                                filters_category.shared.GetSummary = outletobj
                                filters_category.shared.GetSummaryRedemptions = summaruobj
                                
                                self.HomeReviewsInfo = outletobj
                                self.HomeRedemeedInfo = summaruobj
                                print(self.HomeReviewsInfo)
                                print(self.HomeRedemeedInfo)
                                //                                if self.Pagename == "Summary"
                                //                                {
                                //                                self.filterdelegate?.Apply_filter(selected_outlets:self.selected_Outlets, selected_offers:self.selected_Offers, from_date: self.fromdate, To_date: self.todate)
                                //                                                self.navigationController?.popViewController(animated: true)
                                //                                }
                                //                                else if self.Pagename == "review" {
                                //                                self.Reviewfilterdelegate?.Apply_filter(selected_outlets:self.selected_Outlets, selected_offers:self.selected_Offers, from_date: self.fromdate, To_date: self.todate)
                                //                                self.navigationController?.popViewController(animated: true)
                                //                                }
                                //                                else {
                                //                                            self.Redemfilterdelegate?.Apply_filter(selected_outlets:self.selected_Outlets, selected_offers:self.selected_Offers, from_date: self.fromdate, To_date: self.todate)
                                //                                                self.navigationController?.popViewController(animated: true)
                                //                                            }
                                self.navigationController?.popViewController(animated: true)
                                
                            }
                        }
                        else
                        {
                            //                            if let msgstr = dict1["message"] as? String
                            //                            {
                            let alert = UIAlertController(title: AppName, message: RKLocalizedString(key: "Invalid credentials", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            // }
                        }
                    }
                    
                }
                
            }
        }
    }
}
extension ReviewsVC:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters_category.shared.GetReviews.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviews_cell", for: indexPath) as! reviews_cell
        
        cell.lblStaff.text = RKLocalizedString(key: "Staff", comment: "")
        cell.lblPrice.text = RKLocalizedString(key: "Price", comment: "")
        cell.lblAmbience.text = RKLocalizedString(key: "Ambience", comment: "")
        cell.lblQualityOffering.text = RKLocalizedString(key: "Quality of Offering", comment: "")
        cell.lblOverallrating.text = RKLocalizedString(key: "Overall Rating", comment: "")
        cell.InnerView.layer.cornerRadius = 10
        cell.InnerView.clipsToBounds = true
        cell.outerView.layer.cornerRadius = 10
        cell.outerView.layer.shadowColor = UIColor.lightGray.cgColor
        cell.outerView.layer.shadowOpacity = 0.4
        cell.outerView.layer.shadowOffset = CGSize.zero
        cell.outerView.layer.shadowRadius = 5

        if filters_category.shared.GetReviews[indexPath.row].user_email == "" {
            cell.lbl_mobnum.text = RKLocalizedString(key: "Confidential", comment: "")
            cell.lbl_Username.text = "Confidential"
            cell.lbl_UserEmail.text = "Confidential"
        }
        else {
        let cuntrcode = filters_category.shared.GetReviews[indexPath.row].country_code
        cell.lbl_mobnum.text = cuntrcode + "-" + filters_category.shared.GetReviews[indexPath.row].mobile_no
        cell.lbl_Username.text = filters_category.shared.GetReviews[indexPath.row].user_name
        cell.lbl_UserEmail.text = filters_category.shared.GetReviews[indexPath.row].user_email
       
       
        
        if let img_Url = URL(string:filters_category.shared.GetReviews[indexPath.row].user_image)
        {
            cell.user_image.af_setImage(withURL: img_Url, placeholderImage: #imageLiteral(resourceName: "placeholder"), filter: nil, progress: nil, completion: { (res) in})
        }
        }
        cell.lbl_reviewdate.text = filters_category.shared.GetReviews[indexPath.row].review_date
        cell.lbl_description.text = filters_category.shared.GetReviews[indexPath.row].description
        cell.FloatRatingambeice.rating = Double(filters_category.shared.GetReviews[indexPath.row].ambience)!
        cell.FloatRatingViewprice.rating = Double(filters_category.shared.GetReviews[indexPath.row].price)!
        cell.FloatRatingViewstaff.rating = Double(filters_category.shared.GetReviews[indexPath.row].staff)!
        cell.FloatRatingViewquality.rating = Double(filters_category.shared.GetReviews[indexPath.row].quality_of_offring)!
        cell.FloatRatingViewoverall.rating = Double(filters_category.shared.GetReviews[indexPath.row].overall_rating)!
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

class reviews_cell:UITableViewCell {
    @IBOutlet weak var lbl_sepreator:UILabel!
    @IBOutlet weak var img_mailicon:UIImageView!
    @IBOutlet weak var outerView:UIView!
    @IBOutlet weak var InnerView:UIView!
    @IBOutlet weak var Viewheight_UserDetail:NSLayoutConstraint!
    @IBOutlet weak var lbl_mobnum :UILabel!
    @IBOutlet weak var lbl_Username :UILabel!
    @IBOutlet weak var lbl_UserEmail :UILabel!
    @IBOutlet weak var lbl_description:UILabel!
    @IBOutlet weak var lbl_reviewdate:UILabel!
    @IBOutlet weak var user_image :UIImageView!
    @IBOutlet var FloatRatingViewstaff : FloatRatingView!
    @IBOutlet var FloatRatingViewprice : FloatRatingView!
    @IBOutlet var FloatRatingambeice : FloatRatingView!
    @IBOutlet var FloatRatingViewquality : FloatRatingView!
    @IBOutlet var FloatRatingViewoverall : FloatRatingView!
    
    @IBOutlet weak var lblStaff: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    
    @IBOutlet weak var lblAmbience: UILabel!
    
    @IBOutlet weak var lblOverallrating: UILabel!
    
    @IBOutlet weak var lblQualityOffering: UILabel!
    
    
    
    
    
    
}
