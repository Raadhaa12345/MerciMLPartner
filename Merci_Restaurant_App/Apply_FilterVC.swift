//
//  Apply_FilterVC.swift
//  Merci_Restaurant_App
//
//  Created by RipenApp on 25/10/18.
//  Copyright © 2018 RipenApp. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD


protocol filterProtocol {
    func Apply_filter(selected_outlets:[String],selected_offers:[String],from_date:String,To_date:String)
}

protocol Reviewfilterprotocol {
    func Apply_filter(selected_outlets:[String],selected_offers:[String],from_date:String,To_date:String)
}

protocol redemFilterProtocol {
    func Apply_filter(selected_outlets:[String],selected_offers:[String],from_date:String,To_date:String)
}

protocol clearallprotocol {
   func ClearAll()
}

protocol redemclearallprotocol {
    func ClearAll()
}

protocol reviewcleardprotocol {
    func ClearAll()
}

class Apply_FilterVC: UIViewController,outletprotocol,offerProtocol{

    var filterdelegate:filterProtocol?
    var Reviewfilterdelegate:Reviewfilterprotocol?
    var Redemfilterdelegate:redemFilterProtocol?
    var clearalldelegate:clearallprotocol?
    var remedcleardelegate:redemclearallprotocol?
    var reviewcleardelegate:reviewcleardprotocol?
    @IBOutlet weak var topview : UIView!
    @IBOutlet weak var footerview : UIView!
    @IBOutlet weak var filter_TableView:UITableView!
    
    @IBOutlet weak var lblApplyFilter: UILabel!
    
    @IBOutlet weak var btnClear: UIButton!
    
    var selected_Outlets = [String]()
    var selected_Offers = [String]()
    let unique_id = CommonUtilities.shared.getdeviceID()
    var myCheckBool1 = false
    var myCheckBool2 = false
    var arr1 = [RKLocalizedString(key: "Select Outlet", comment: ""),
                RKLocalizedString(key: "Select Offer", comment: ""),
                RKLocalizedString(key: "From", comment: ""),
                RKLocalizedString(key: "To", comment: "")]
    let picker = UIDatePicker()
    var dateofbirth : String = ""
    var date = ""
    var Email = ""
    var Password = ""
    var fromdate = ""
    var todate = ""
    var filterList = Get_filterdata()
    var Pagename = ""
    var Fromdate = Date()
    var Todate = Date()
    var HomeReviewsInfo = GetSummary_Reviews()
    var HomeRedemeedInfo = GetSummary_Redemptions()
    
    var Graph_Info = GraphData_model()
    var Reviews_Info = [Reviews_DetailsList]()
    var Redemption_Info = [Redemption_DetailsList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblApplyFilter.text = RKLocalizedString(key: "Apply Filter", comment: "")
        btnClear.setTitle(RKLocalizedString(key: "Clear All", comment: ""), for: .normal)
        setUI()
        hitservice_GetFilteData()
    }
    func setUI(){
        self.topview.layer.shadowColor = UIColor.lightGray.cgColor
        self.topview.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.topview.layer.shadowOpacity = 0.5
        self.topview.layer.shadowRadius = 5.0
        self.topview.layer.masksToBounds = false
        filter_TableView.tableFooterView = UIView()
    }

    @IBAction func Backbtn(_ sender : UIButton){
        
        let alertController = UIAlertController(title: AppName, message:RKLocalizedString(key: "Are you sure you want to apply the filters?", comment: "") , preferredStyle: .alert)
        let okAction = UIAlertAction(title:RKLocalizedString(key: "Yes", comment: ""), style: UIAlertActionStyle.default) {
            UIAlertAction in
//            var from = Date()
//            var to  = Date()
//            //if self.fromdate != "" && self.todate  != "" {
//            let staetFormatter = DateFormatter()
//            staetFormatter.dateFormat = "yyyy-MM-dd"
//            staetFormatter.timeZone = NSTimeZone(abbreviation: "GMT+0:00") as TimeZone?
//            if let fromDate = staetFormatter.date(from:self.fromdate) {
//                from = fromDate
//            }
//            if let todate = staetFormatter.date(from:self.todate) {
//                to = todate
//            }
//
//            let  = staetFormatter.string()!
//            let todate = staetFormatter.string(from:self.todate)!
           // }
            
            
            if self.fromdate == "" && self.todate != "" {
                self.datevalidation()
            }
            else if self.fromdate != "" && self.todate != "" && self.Fromdate > self.Todate  {

                self.datevalidation()
            }
            else {
                
            UserDefaults.standard.set(true, forKey: "filteraplied")

                let obj = filterdata()
                 let fdate = filters_data.shared.filterSummary.fromdate
                    obj.fromdate = fdate
                
                 let tdate = filters_data.shared.filterSummary.todate
                    obj.todate = tdate
                
                let outlet = filters_data.shared.filterSummary.selected_Outlets
                    obj.selected_Outlets = outlet
                
                let offer = filters_data.shared.filterSummary.selected_Offers
                    obj.selected_Offers = offer
                
                filters_data.shared.filterSummary = obj

                self.HitserviceForLogin()
        }
            
        }
        let cancelAction = UIAlertAction(title: RKLocalizedString(key: "No", comment: ""), style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
   
    }
    func Backto_Outlet(selected_outlets:[String]){
        filters_data.shared.filterSummary.selected_Outlets = selected_outlets
    }
    func Backto_Offer(selected_offers:[String]){
        filters_data.shared.filterSummary.selected_Offers = selected_offers
    }
   
    func datevalidation (){
        let alert = UIAlertController(title: AppName, message: RKLocalizedString(key: "End date must be before Start date.", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func ClearAll_Action(_sender:UIButton){
        let alertController = UIAlertController(title: AppName, message:RKLocalizedString(key: "Are you sure you want to clear the filters ?", comment: "") , preferredStyle: .alert)
        let okAction = UIAlertAction(title: RKLocalizedString(key: "Yes", comment: ""), style: UIAlertActionStyle.default) {
            UIAlertAction in
            UserDefaults.standard.removeObject(forKey:"filteraplied")
//            if self.Pagename == "Summary"
//            {
//                self.clearalldelegate?.ClearAll()
//                self.navigationController?.popViewController(animated: true)
//            }
//            else if self.Pagename == "review" {
//                self.clearalldelegate?.ClearAll()
//                self.navigationController?.popViewController(animated: true)
//            }
//            else {
//                self.clearalldelegate?.ClearAll()
//                self.navigationController?.popViewController(animated: true)
//            }
            filters_data.shared.filterSummary.fromdate.removeAll()
            filters_data.shared.filterSummary.todate.removeAll()
            filters_data.shared.filterSummary.selected_Offers.removeAll()
            filters_data.shared.filterSummary.selected_Outlets.removeAll()
//            self.selected_Outlets.removeAll()
//            self.selected_Offers.removeAll()
//            self.fromdate = ""
//            self.todate = ""
            self.HitserviceForLogin()
        }
        let cancelAction = UIAlertAction(title: RKLocalizedString(key: "No", comment: ""), style: UIAlertActionStyle.cancel) {
            UIAlertAction in
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
extension Apply_FilterVC : UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate {
   
    @objc func from_donePressed(_ sender : UIButton)
    {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: picker.date)
        
        let indexPath = IndexPath.init(row:sender.tag, section: 0)
      
        let cell = filter_TableView.cellForRow(at: indexPath) as! filterdate_cell
//        if sender.tag == 2 {
        
             cell.lbl_date.text = "From:" + " " + "\(dateString  )"
             fromdate = String(dateString)
            filters_data.shared.filterSummary.fromdate = fromdate
             Fromdate = picker.date
      //  }
//        else {
//            cell.lbl_date.text = "To:" + " " + "\(dateString  )"
//            todate = String(dateString)
//
//        }
        formatter.dateFormat = "yyyy-MM-dd"
        dateofbirth = formatter.string(from: picker.date)
        self.view.endEditing(true)
    }
    
    
    @objc func To_donePressed(_ sender : UIButton)
    {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: picker.date)
        
        let indexPath = IndexPath.init(row:sender.tag, section: 0)
        
        let cell = filter_TableView.cellForRow(at: indexPath) as! filterdate_cell2
        //        else {
            cell.lbl_date.text = "To:" + " " + "\(dateString  )"
            todate = String(dateString)

           filters_data.shared.filterSummary.todate = todate
            Todate = picker.date
        //
        //        }
        formatter.dateFormat = "yyyy-MM-dd"
        dateofbirth = formatter.string(from: picker.date)
        self.view.endEditing(true)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerview
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 || indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"filterselect_cell", for: indexPath) as! filterselect_cell
            cell.selectinnerView.layer.shadowColor = UIColor.lightGray.cgColor
            cell.selectinnerView.layer.shadowOpacity = 0.4
            cell.selectinnerView.layer.shadowOffset = CGSize.zero
            cell.lbl_tittle.text = arr1[indexPath.row]
           
            return cell
        }
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"filterdate_cell2", for: indexPath) as! filterdate_cell2
            
           
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let done = UIBarButtonItem(barButtonSystemItem: .done , target: nil, action: #selector(To_donePressed(_:)))
            done.tag = indexPath.row
            toolbar.setItems([done], animated: true )
            picker.datePickerMode = .date
            cell.txt_date.inputView = picker
            cell.txt_date.tag = indexPath.row
            cell.txt_date.inputAccessoryView = toolbar
            cell.dateinnerView.layer.shadowColor = UIColor.lightGray.cgColor
            cell.dateinnerView.layer.shadowOpacity = 0.4
            cell.dateinnerView.layer.shadowOffset = CGSize.zero
            cell.lbl_date.text = arr1[indexPath.row]
                if filters_data.shared.filterSummary.todate != "" {
                    cell.lbl_date.text = "To:" + " " + filters_data.shared.filterSummary.todate
                }
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier:"filterdate_cell", for: indexPath) as! filterdate_cell
            
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let done = UIBarButtonItem(barButtonSystemItem: .done , target: nil, action: #selector(from_donePressed(_:)))
            done.tag = indexPath.row
            toolbar.setItems([done], animated: true )
            picker.datePickerMode = .date
            cell.txt_date.inputView = picker
            cell.txt_date.tag = indexPath.row
            cell.txt_date.inputAccessoryView = toolbar
            cell.dateinnerView.layer.shadowColor = UIColor.lightGray.cgColor
            cell.dateinnerView.layer.shadowOpacity = 0.4
            cell.dateinnerView.layer.shadowOffset = CGSize.zero
            cell.lbl_date.text = arr1[indexPath.row]
            if filters_data.shared.filterSummary.fromdate != "" {
                cell.lbl_date.text = "From:" + " " + filters_data.shared.filterSummary.fromdate
            }
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
             if filterList.outlet_array.count > 0 {
                let SelectOutlet_Vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectOutlet_Vc") as! SelectOutlet_Vc
                SelectOutlet_Vc.outlet_Array = filterList.outlet_array
                SelectOutlet_Vc.outletdelegate = self
                SelectOutlet_Vc.selected_Outlets = filters_data.shared.filterSummary.selected_Outlets
                self.navigationController?.pushViewController(SelectOutlet_Vc, animated: true)
            }
             else {
                let alert = UIAlertController(title: AppName, message: "There is no Outlets.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        default:
            
            if filterList.offer_array.count > 0 {
                let SelectOutlet_Vc = self.storyboard?.instantiateViewController(withIdentifier: "Select_OfferVC") as! Select_OfferVC
                SelectOutlet_Vc.offer_Array = filterList.offer_array
                SelectOutlet_Vc.offerdelegate = self
                SelectOutlet_Vc.selected_offers = filters_data.shared.filterSummary.selected_Offers
                self.navigationController?.pushViewController(SelectOutlet_Vc, animated: true)
            }
            else {
                let alert = UIAlertController(title: AppName, message:RKLocalizedString(key: "There is no Offers.", comment: "") , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    func hitservice_GetFilteData(){
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
            "method": "getFilterData",
            "email": Email,
            "password":Password ,
            "uniqueId": unique_id
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
                               let outletobj = Get_filterdata()
                               
                                if let outlets = DataDic["outlets"] as? [[String:Any]]
                                {
                                    outletobj.outlet_array = outlets
                                }
                                if let offers = DataDic["offers"] as? [[String:Any]]
                                {
                                    outletobj.offer_array = offers
                                }
                                self.filterList = outletobj
                                print(self.filterList)
                                
                            }
                        }
                        else
                        {
                            if let msgstr = dict1["message"] as? String
                            {
                                let alert = UIAlertController(title: AppName, message: msgstr, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                    
                }
                
            }
        }
    
    }
    
    
   
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


class filterselect_cell :UITableViewCell {
    @IBOutlet weak var selectinnerView : UIView!
    @IBOutlet weak var lbl_tittle : UILabel!
    
}
class filterdate_cell :UITableViewCell {
    @IBOutlet weak var dateinnerView : UIView!
    @IBOutlet weak var lbl_date : UILabel!
    @IBOutlet weak var img_arrow : UIImageView!
    @IBOutlet weak var txt_date : UITextField!
}

class filterdate_cell2 :UITableViewCell {
    @IBOutlet weak var dateinnerView : UIView!
    @IBOutlet weak var lbl_date : UILabel!
    @IBOutlet weak var img_arrow : UIImageView!
    @IBOutlet weak var txt_date : UITextField!
}

class Get_filterdata {
    var outlet_array = [[String:Any]]()
    var offer_array = [[String:Any]]()
}

class filterdata {
    var selected_Outlets = [String]()
    var selected_Offers = [String]()
    var fromdate = ""
    var todate = ""
}

class filters_data
{
    static var shared = filters_data()
    var filterSummary = filterdata()
    
}
