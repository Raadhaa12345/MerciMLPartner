//
//  Redemption_VC.swift
//  Merci_Restaurant_App
//
//  Created by RipenApp on 25/10/18.
//  Copyright © 2018 RipenApp. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
class Redemption_VC: UIViewController,redemFilterProtocol,redemclearallprotocol {

    let unique_id = CommonUtilities.shared.getdeviceID()
    @IBOutlet weak var topview : UIView!
    @IBOutlet weak var redemption_TableView:UITableView!
    @IBOutlet weak var redemption_CollectionView:UICollectionView!
    @IBOutlet weak var open_Sidemenu:UIButton!
    @IBOutlet weak var calenderimg:UIImageView!
    
    @IBOutlet weak var lblRedemption: UILabel!
    

    var refresh = UIRefreshControl()
    var HomeReviewsInfo = GetSummary_Reviews()
    var HomeRedemeedInfo = GetSummary_Redemptions()
     @IBOutlet weak var No_redemption:UILabel!
    var Graph_Info = GraphData_model()
    var Reviews_Info = [Reviews_DetailsList]()
    var Redemption_Info = [Redemption_DetailsList]()
    @IBOutlet weak var lbl_Topdate:UILabel!
    
    @IBOutlet weak var dateView_height:NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

       setUI()
        lblRedemption.text = RKLocalizedString(key: "Redemptions", comment: "")
        No_redemption.text = RKLocalizedString(key: "No Redemption Found", comment: "")
    }
    

    func setUI(){
        self.topview.layer.shadowColor = UIColor.lightGray.cgColor
        self.topview.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.topview.layer.shadowOpacity = 0.5
        self.topview.layer.shadowRadius = 5.0
        self.topview.layer.masksToBounds = false
        redemption_TableView.tableFooterView = UIView()
        if revealViewController() != nil{
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            let revealViewController = self.revealViewController()
            open_Sidemenu.addTarget(revealViewController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        }
        refresh.backgroundColor = UIColor(displayP3Red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        refresh.tintColor = UIColor(displayP3Red: 42/255, green: 53/255, blue: 117/255, alpha: 1.0)
        refresh.addTarget(self, action: #selector(refrersh_action), for: .valueChanged)
        redemption_TableView.addSubview(refresh)
    }
    override func viewWillAppear(_ animated: Bool) {
        if filters_category.shared.GetRedemption.count == 0 {
            No_redemption.isHidden = false
            redemption_TableView.isHidden = true
            redemption_CollectionView.isHidden = true
        }
        else {
            No_redemption.isHidden = true
            redemption_TableView.isHidden = false
            redemption_CollectionView.isHidden = false
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
        redemption_TableView.reloadData()
        redemption_CollectionView.reloadData()
        
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
        Apply_FilterVC.Redemfilterdelegate = self
        Apply_FilterVC.remedcleardelegate = self
        Apply_FilterVC.Pagename = ""

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

extension Redemption_VC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filters_category.shared.GetRedemption.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return redemption_CollectionView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 250
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "redemption_Tablecell", for: indexPath) as! redemption_Tablecell
        cell.innerView.layer.cornerRadius = 10
        cell.innerView.layer.shadowColor = UIColor.lightGray.cgColor
        cell.innerView.layer.shadowOpacity = 0.4
        cell.innerView.layer.shadowOffset = CGSize.zero
        cell.innerView.layer.shadowRadius = 5
        
        cell.lbl_description.text = filters_category.shared.GetRedemption[indexPath.row].restaurent_name
        cell.lbl_time.text = filters_category.shared.GetRedemption[indexPath.row].redeem_time
        cell.lbl_offerdate.text = filters_category.shared.GetRedemption[indexPath.row].redeem_date
        cell.lbl_offername.text = filters_category.shared.GetRedemption[indexPath.row].offer_name
        cell.lbl_redemption_no.text = filters_category.shared.GetRedemption[indexPath.row].redemption_no
        if let img_Url = URL(string:filters_category.shared.GetRedemption[indexPath.row].offer_image)
        {
            cell.img_offer.af_setImage(withURL: img_Url, placeholderImage: #imageLiteral(resourceName: "placeholder"), filter: nil, progress: nil, completion: { (res) in})
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}


extension Redemption_VC: UICollectionViewDataSource,UICollectionViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters_category.shared.graphdata.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Collection_BarCell", for: indexPath) as! Collection_BarCell
        
        cell.barDataList.removeAll()
        for item in filters_category.shared.graphdata[indexPath.row].graph_data{
            cell.barDataList.append([CGFloat(item["total_redemptions"] as! Int)])
        }
        
        cell.titles.removeAll()
        for item in filters_category.shared.graphdata[indexPath.row].graph_data {
            cell.titles.append(item["months"] as! String)
        }
        cell.val = filters_category.shared.graphdata[indexPath.row].max_redemptions
        cell.lblyear.text = filters_category.shared.graphdata[indexPath.row].year
        print(cell.barDataList)
        print(cell.val)
        print(cell.lblyear.text!)
        cell.showchart()
        if filters_category.shared.graphdata.count <= 1 {
            cell.back_img.isHidden = true
            cell.next_img.isHidden = true
        }
        else{
            cell.back_img.isHidden = false
            cell.next_img.isHidden = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.redemption_CollectionView.frame.size.width  , height: self.redemption_CollectionView.frame.size.height)
    }
    
    
}


class redemption_Tablecell: UITableViewCell {
    @IBOutlet weak var innerView : UIView!
    @IBOutlet weak var lbl_offername : UILabel!
    @IBOutlet weak var lbl_redemption_no : UILabel!
    @IBOutlet weak var lbl_description : UILabel!
    @IBOutlet weak var lbl_time : UILabel!
    @IBOutlet weak var lbl_offerdate : UILabel!
    @IBOutlet weak var img_offer : UIImageView!
   
    
    
}

class Collection_BarCell:UICollectionViewCell,AMBarChartViewDataSource {
    @IBOutlet weak var lineChartView: AMBarChartView!
    @IBOutlet weak var lblyear:UILabel!
    @IBOutlet weak var back_img:UIImageView!
    @IBOutlet weak var next_img:UIImageView!
    var barColors = UIColor()
    var barDataList = [[CGFloat]]()
    var lineDataList = [CGFloat]()
    var lineRowNum:Int = 0;
    var barRownNum : Int = 0;
    var year = ""
   
    var titles = [String]()
    var val = 0
    func showchart(){

        val = val + ((25*val)/100)
        
        print(val)
        if val <= 6 {
           val = val + ((25*val)/100) + ((500*val)/100)
            lineChartView.yAxisMaxValue = CGFloat(val)
        }
        else {
         lineChartView.yAxisMaxValue = CGFloat(val)
        }
        print(val)
        
        lineChartView.dataSource = self
        prepareDataList()
        
        lineChartView.reloadData()
        
    }
    
    private func prepareDataList () {
        // let lineSectionNum = 1
        let barSectionNum = 1
        
        barRownNum = titles.count
        lineRowNum = titles.count
        lineDataList.removeAll()
        //barDataList.removeAll()
        
        
       // lineDataList = [20,30,40,50,10]
//        if api_type == "lifetime"{
//            for item in lifetimesavingaarray{
//                barDataList.append([CGFloat(item.Savings.map{$0.savings}.max()!)])
//            }
//            print(lineDataList)
//        }else {
//            for item in Yearlysavingaarray{
//                barDataList.append([CGFloat(item.Savings)])
//            }
//        }
        
//        barDataList = [[20],[30],[30],[40],[50],[70],[30],[10],[60],[10],[60],[80]]
        print(barDataList)
        barColors = UIColor.red
    }
    
    func numberOfSections(inBarChartView barChartView: AMBarChartView) -> Int {
        
        return barDataList.count
    }
    
    func barChartView(barChartView: AMBarChartView, numberOfRowsInSection section: Int) -> Int {
        
        return barDataList[section].count
        // return barRownNum
    }
    
    func barChartView(barChartView: AMBarChartView, valueForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        return barDataList[indexPath.section][indexPath.row]
    }
    
    func barChartView(barChartView: AMBarChartView, colorForRowAtIndexPath indexPath: IndexPath) -> UIColor {
        
        return barColors
    }
    
    func barChartView(barChartView: AMBarChartView, titleForXlabelInSection section: Int) -> String {
        
        return titles[section]
    }
}
