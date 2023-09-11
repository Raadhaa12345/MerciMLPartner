//
//  Summary_VC.swift
//  Merci_Restaurant_App
//
//  Created by RipenApp on 22/10/18.
//  Copyright © 2018 RipenApp. All rights reserved.
//

import UIKit
import LinearProgressBar
import Alamofire
import MBProgressHUD

class Summary_VC: UIViewController,filterProtocol,clearallprotocol {
    
    let unique_id = CommonUtilities.shared.getdeviceID()
    @IBOutlet weak var view_header:UIView!
    @IBOutlet weak var view_header2:UIView!
    @IBOutlet weak var calenderimg:UIImageView!
    @IBOutlet weak var dateView:UIView!
    @IBOutlet weak var review_view:UIView!
    @IBOutlet weak var redemption_view:UIView!
    @IBOutlet weak var topview : UIView!
    @IBOutlet weak var Summary_tableview:UITableView!
    @IBOutlet weak var open_Sidemenu:UIButton!
    @IBOutlet weak var lbl_TotalRatings:UILabel!
    @IBOutlet weak var lbl_TotalRedemption:UILabel!
    @IBOutlet var FloatRatingViewstaff : FloatRatingView!
    @IBOutlet var FloatRatingViewprice : FloatRatingView!
    @IBOutlet var FloatRatingambeice : FloatRatingView!
    @IBOutlet var FloatRatingViewquality : FloatRatingView!
    @IBOutlet var FloatRatingViewoverall : FloatRatingView!
    @IBOutlet weak var lbl_Topdate:UILabel!
    
    @IBOutlet weak var lbl_staffrating:UILabel!
    @IBOutlet weak var lbl_ambiencerating:UILabel!
    @IBOutlet weak var lbl_overallrating:UILabel!
    @IBOutlet weak var lbl_qualityrating:UILabel!
    @IBOutlet weak var lbl_pricerating:UILabel!
    @IBOutlet weak var lblreviews: UILabel!
    @IBOutlet weak var dateView_height:NSLayoutConstraint!
    
    @IBOutlet weak var lblstaff: UILabel!
    @IBOutlet weak var lblAmbience: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblQualityOffering: UILabel!
    @IBOutlet weak var lblOverallRating: UILabel!
    
    @IBOutlet weak var lblSummary: UILabel!
    
    @IBOutlet weak var lblRedemdition: UILabel!
    
    var HomeReviewsInfo = GetSummary_Reviews()
    var HomeRedemeedInfo = GetSummary_Redemptions()
    
    var Graph_Info = GraphData_model()
    var Reviews_Info = [Reviews_DetailsList]()
    var Redemption_Info = [Redemption_DetailsList]()
    var refresh = UIRefreshControl()
    @IBOutlet weak var staff_view:UIView!
    @IBOutlet weak var price_view:UIView!
    @IBOutlet weak var overall_view:UIView!
    @IBOutlet weak var ambience_view:UIView!
    @IBOutlet weak var quality_view:UIView!
    var maxval = 0
    var reviewtypearr = ["Staff","Price","Ambeince","Quality Of Offering","Overall Rating"]
    
    var valare = [Int]()
    var reviewlastcell = 0
    var redemptionlastcell = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblRedemdition.text = RKLocalizedString(key: "Redemptions", comment: "")
        lblSummary.text = RKLocalizedString(key: "Summary", comment: "")
        
        lblstaff.text = RKLocalizedString(key: "Staff", comment: "")
        lblPrice.text = RKLocalizedString(key: "Price", comment: "")
        lblAmbience.text = RKLocalizedString(key: "Ambience", comment: "")
        lblQualityOffering.text = RKLocalizedString(key: "Quality of Offering", comment: "")
        lblOverallRating.text = RKLocalizedString(key: "Overall Rating", comment: "")
        lblreviews.text = RKLocalizedString(key: "Reviews", comment: "")
        lbl_TotalRedemption.text = RKLocalizedString(key: "20 Ratings", comment: "")
        
        
        setUI()
        shadow()
    
        let tapreview = UITapGestureRecognizer(target : self ,action : #selector(self.reviewAction(_:)))
        review_view.isUserInteractionEnabled = true
        review_view.addGestureRecognizer(tapreview)
        
        let tapredemption = UITapGestureRecognizer(target : self ,action : #selector(self.redemptionAction(_:)))
        redemption_view.isUserInteractionEnabled = true
        redemption_view.addGestureRecognizer(tapredemption)
        
    }
    override func viewWillAppear(_ animated: Bool) {
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
        Summary_tableview.reloadData()
        lbl_TotalRatings.text = String(filters_category.shared.GetSummary.total_reviews) + RKLocalizedString(key: "20 Ratings", comment: "")
        lbl_TotalRedemption.text = String(filters_category.shared.GetSummaryRedemptions.total_redeemed_saving)
        FloatRatingambeice.rating = Double(filters_category.shared.GetSummary.ambience_avg)!
        FloatRatingViewstaff.rating = Double(filters_category.shared.GetSummary.staff_avg)!
        FloatRatingViewprice.rating = Double(filters_category.shared.GetSummary.price_avg)!
        FloatRatingViewoverall.rating = Double(filters_category.shared.GetSummary.overall_rating_avg)!
        FloatRatingViewquality.rating = Double(filters_category.shared.GetSummary.quality_of_offring_avg)!
        
        
        
        
        lbl_staffrating.text = "(" +  String(filters_category.shared.GetSummary.staff_avg.floatValue.truncateTrailingZero())  + "/" + "5)"
        lbl_pricerating.text = "(" + String(filters_category.shared.GetSummary.price_avg.floatValue.truncateTrailingZero()) + "/" + "5)"
        lbl_overallrating.text = "(" + String(filters_category.shared.GetSummary.overall_rating_avg.floatValue.truncateTrailingZero()) + "/" + "5)"
        lbl_ambiencerating.text = "(" + String(filters_category.shared.GetSummary.ambience_avg.floatValue.truncateTrailingZero()) + "/" + "5)"
        lbl_qualityrating.text = "(" + String(filters_category.shared.GetSummary.quality_of_offring_avg.floatValue.truncateTrailingZero()) + "/" + "5)"
        
        for item in filters_category.shared.GetSummaryRedemptions.redeemed_offers {
            valare.append(Int(item["savings"]!)!)
        }
        print(valare)
        if valare.count > 0 {
            maxval = valare.max()!
        }
        print(maxval)
        
    }
    @objc func refrersh_action(){
        
        refresh.endRefreshing()
        HitserviceForLogin()
    }
    
    func setUI(){
        review_view.layer.cornerRadius = 8
        review_view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.review_view.layer.shadowColor = UIColor.lightGray.cgColor
        self.review_view.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.review_view.layer.shadowOpacity = 0.4
        
        redemption_view.layer.cornerRadius = 8
        redemption_view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.redemption_view.layer.shadowColor = UIColor.lightGray.cgColor
        self.redemption_view.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.redemption_view.layer.shadowOpacity = 0.3
        
        self.topview.layer.shadowColor = UIColor.lightGray.cgColor
        self.topview.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.topview.layer.shadowOpacity = 0.4
        self.topview.layer.shadowRadius = 5.0
        self.topview.layer.masksToBounds = false
        Summary_tableview.tableFooterView = UIView()
        
        if revealViewController() != nil{
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            let revealViewController = self.revealViewController()
            open_Sidemenu.addTarget(revealViewController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        }
        refresh.backgroundColor = UIColor(displayP3Red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        refresh.tintColor = UIColor(displayP3Red: 42/255, green: 53/255, blue: 117/255, alpha: 1.0)
        refresh.addTarget(self, action: #selector(refrersh_action), for: .valueChanged)
        Summary_tableview.addSubview(refresh)
    }
    
    func shadow(){
        self.staff_view.layer.shadowColor = UIColor.lightGray.cgColor
        self.staff_view.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.staff_view.layer.shadowOpacity = 0.4
        
        self.price_view.layer.shadowColor = UIColor.lightGray.cgColor
        self.price_view.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.price_view.layer.shadowOpacity = 0.4
        
        self.quality_view.layer.shadowColor = UIColor.lightGray.cgColor
        self.quality_view.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.quality_view.layer.shadowOpacity = 0.4
        
        self.overall_view.layer.shadowColor = UIColor.lightGray.cgColor
        self.overall_view.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.overall_view.layer.shadowOpacity = 0.4
        self.overall_view.layer.cornerRadius = 8
        self.overall_view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        self.ambience_view.layer.shadowColor = UIColor.lightGray.cgColor
        self.ambience_view.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.ambience_view.layer.shadowOpacity = 0.4
        
    }
    
    @objc func reviewAction(_ sender:UITapGestureRecognizer){
        
        let mainStoryBoard : UIStoryboard
        mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let Home = mainStoryBoard.instantiateViewController(withIdentifier: "ReviewsVC") as! ReviewsVC
        let slidemnuvc = mainStoryBoard.instantiateViewController(withIdentifier: "SidemenuViewController") as! SidemenuViewController
        //        Home.selected_Offers = selected_Offers
        //        Home.selected_Outlets = selected_Outlets
        //        print(selected_Outlets)
        //        Home.fromdate = fromdate
        //        Home.Todate = Todate
        let menu = SWRevealViewController(rearViewController: slidemnuvc, frontViewController: Home)
        menu?.bounceBackOnLeftOverdraw = true
        let mainnav = UINavigationController(rootViewController: menu!)
        mainnav.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = mainnav
        appDelegate.window?.makeKeyAndVisible()
        
    }
    
    
    @objc func redemptionAction(_ sender:UITapGestureRecognizer){
        let mainStoryBoard : UIStoryboard
        mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let Home = mainStoryBoard.instantiateViewController(withIdentifier: "Redemption_VC") as! Redemption_VC
        let slidemnuvc = mainStoryBoard.instantiateViewController(withIdentifier: "SidemenuViewController") as! SidemenuViewController
        //        Home.selected_Offers = selected_Offers
        //        Home.selected_Outlets = selected_Outlets
        //        print(selected_Outlets)
        //        Home.fromdate = fromdate
        //        Home.Todate = Todate
        let menu = SWRevealViewController(rearViewController: slidemnuvc, frontViewController: Home)
        menu?.bounceBackOnLeftOverdraw = true
        let mainnav = UINavigationController(rootViewController: menu!)
        mainnav.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = mainnav
        appDelegate.window?.makeKeyAndVisible()
    }
    
    
    @IBAction func Sidemenu_Action(sender : UIButton)
    {
        let revealViewController = self.revealViewController()
        open_Sidemenu.addTarget(revealViewController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
    }
    
    @IBAction func filter_Action(sender : UIButton)
    {
        let Apply_FilterVC = self.storyboard?.instantiateViewController(withIdentifier: "Apply_FilterVC") as! Apply_FilterVC
        Apply_FilterVC.filterdelegate = self
        Apply_FilterVC.clearalldelegate = self
        Apply_FilterVC.Pagename = "Summary"
        
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
        var headers: HTTPHeaders = ["Content-Type":"application/json"]
            headers["lang"] = Constants.lang
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
                                
                                filters_category.shared.GetSummaryRedemptions.redeemed_offers.removeAll()
                                
                                
                                let summaruobj = GetSummary_Redemptions()
                                let outletobj = GetSummary_Reviews()
                                
                                // Summary screen data
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

extension Float {
    
    func truncateTrailingZero() -> String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}
extension Summary_VC:UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 0
        }
        //        else if section == 1 {
        //           return 0
        //        }
        else {
            return filters_category.shared.GetSummaryRedemptions.redeemed_offers.count
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //        if section == 0 {
        //            return dateView
        //        }
        if section == 0 {
            return view_header
        }
        else {
            
            return view_header2
            
            
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 330
        }
        //        else if section == 0 {
        //            if fromdate == ""  || Todate == "" {
        //                return 0
        //            }
        //            else {
        //                lbl_Topdate.text = fromdate + " to " + Todate
        //                return 24
        //            }
        //        }
        //        else if section ==  {
        //          return 60
        //        }
        else {
            return 60
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "redemption_tablecell", for: indexPath) as!redemption_tablecell
        cell1.Progres.layer.backgroundColor = UIColor(displayP3Red:228.0/255.0, green: 27.0/255.0, blue: 35.0/255.0, alpha: 1.0).cgColor
        cell1.Progres.layer.cornerRadius = 4
        cell1.Progres.layer.borderWidth = 0.8
        cell1.Progres.layer.borderColor = UIColor(displayP3Red: 228.0/255.0, green: 27.0/255.0, blue: 35.0/255.0, alpha: 1.0).cgColor
        cell1.innerview.layer.shadowColor = UIColor.lightGray.cgColor
        cell1.innerview.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        cell1.innerview.layer.shadowOpacity = 0.25
        
        cell1.outerview.layer.shadowColor = UIColor.lightGray.cgColor
        cell1.outerview.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        cell1.outerview.layer.shadowOpacity = 0.4
        
        if indexPath.row == filters_category.shared.GetSummaryRedemptions.redeemed_offers.count - 1 {
            cell1.outerview.layer.cornerRadius = 8
            cell1.outerview.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        cell1.lbl_offername.text = filters_category.shared.GetSummaryRedemptions.redeemed_offers[indexPath.row]["offer_name"]
        cell1.lbl_offerprice.text = filters_category.shared.GetSummaryRedemptions.redeemed_offers[indexPath.row]["savings"]
        
        
        var val = CGFloat((Int(filters_category.shared.GetSummaryRedemptions.redeemed_offers[indexPath.row]["savings"]!)! / maxval) * 100)
        val = val - ((25*val)/100)
        print(val)
        cell1.Progres.progressValue = CGFloat(val)
        return cell1
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 0
        }
        //        else if indexPath.section == 1 {
        //            return 0
        //        }
        //        else if indexPath.section == 1 {
        //            return 85
        //        }
        else {
            return 85
        }
    }
    
    
    
    
}


class review_tablecell:UITableViewCell {
    
    @IBOutlet weak var innerview:UIView!
    @IBOutlet weak var lbl_ratingtype:UILabel!
    @IBOutlet weak var lbl_rating:UILabel!
    @IBOutlet var FloatRatingView : FloatRatingView!
    
}
class redemption_tablecell:UITableViewCell {
    @IBOutlet weak var Progres:LinearProgressBar!
    @IBOutlet weak var innerview:UIView!
    @IBOutlet weak var outerview:UIView!
    @IBOutlet weak var lbl_offername:UILabel!
    @IBOutlet weak var lbl_offerprice:UILabel!
}


