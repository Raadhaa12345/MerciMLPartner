//
//  SidemenuViewController.swift
//
//
//  Created by ADMIN on 10/08/18.
//

import UIKit
import AlamofireImage
import Alamofire
import MBProgressHUD

class SidemenuViewController: UIViewController {

    @IBOutlet var Headerview : UIView!
    @IBOutlet var footerView : UIView!
    @IBOutlet var table_View : UITableView!
    @IBOutlet var btn_Signout : UIButton!
    @IBOutlet var usernamelbl : UILabel!
    @IBOutlet var lbl_SavingthisYear : UILabel!
    @IBOutlet var lbl_SavingLifetime : UILabel!
    @IBOutlet var lbl_SavingthisYearamt : UILabel!
    @IBOutlet var lbl_SavingLifetimeamt : UILabel!
    @IBOutlet var profileimage : UIImageView!
    
//    @IBOutlet var emailnamelbl : UILabel!
//    @IBOutlet var phonenamelbl : UILabel!
    
    
    
 
    var html_url = ""
    var window: UIWindow?
    
    var DetailsArray:[[String:Any]] = [
        ["title":RKLocalizedString(key: "Summary", comment: ""),
         "image":"summary"],
        ["title":RKLocalizedString(key: "Reviews", comment: ""),
         "image":"review"],
        ["title":RKLocalizedString(key: "Redemptions", comment: ""),
         "image":"redemption_icon"],
        ["title":RKLocalizedString(key: "Reset Password", comment: ""),
         "image":"password"],
        ["title":RKLocalizedString(key: "Change Email", comment: ""),
         "image":"email"],
        ["title":RKLocalizedString(key: "Sign Out", comment: ""),
         "image":"signout"]
    ]
        
        override func viewDidLoad()
        {
            super.viewDidLoad()
            table_View.tableFooterView = UIView()
            table_View.alwaysBounceVertical = false
    }
    override func viewWillAppear(_ animated: Bool) {
       // setDefault()
        
       
    }
       
    func setDefault()
    {
        if let result = UserDefaults.standard.object(forKey: "signup_info") as? Dictionary<String,AnyObject>
        {
            if let usernamestr = result["first_name"] as? String
            {
                if usernamestr != ""
                {
                    self.usernamelbl.text = usernamestr
                }
            }
            if let imagedate = result["user_image"] as? String
            {
                if let image_data = Data(base64Encoded: imagedate, options: .ignoreUnknownCharacters)
                {
                    if let user_image = UIImage(data: image_data)
                    {
                        profileimage.image = user_image
                    }
                }
            }
        }
    }
    

    
}

extension SidemenuViewController : UITableViewDataSource, UITableViewDelegate
{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return DetailsArray.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table_View.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Slidemenu_Tableviewcell
        cell.lbltitle.text = DetailsArray[indexPath.row]["title"] as? String
        
        cell.titleimage.image = UIImage(named: (DetailsArray[indexPath.row]["image"] as? String)!)
        if selectedIndex == indexPath.row {
            cell.backgroundColor = UIColor(displayP3Red: 253.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, alpha:1.0)
        }else{
            cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        switch indexPath.row {
        case 0:
            selectedIndex = 0
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
        case 1:
            selectedIndex = 1
            let mainStoryBoard : UIStoryboard
            mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let Home = mainStoryBoard.instantiateViewController(withIdentifier: "ReviewsVC") as! ReviewsVC
            let slidemnuvc = mainStoryBoard.instantiateViewController(withIdentifier: "SidemenuViewController") as! SidemenuViewController
            let menu = SWRevealViewController(rearViewController: slidemnuvc, frontViewController: Home)
            menu?.bounceBackOnLeftOverdraw = true
            let mainnav = UINavigationController(rootViewController: menu!)
            mainnav.navigationBar.isHidden = true
            appDelegate.window?.rootViewController = mainnav
            appDelegate.window?.makeKeyAndVisible()
        case 2:
            selectedIndex = 2
            let mainStoryBoard : UIStoryboard
            mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let Home = mainStoryBoard.instantiateViewController(withIdentifier: "Redemption_VC") as! Redemption_VC
            let slidemnuvc = mainStoryBoard.instantiateViewController(withIdentifier: "SidemenuViewController") as! SidemenuViewController
            let menu = SWRevealViewController(rearViewController: slidemnuvc, frontViewController: Home)
            menu?.bounceBackOnLeftOverdraw = true
            let mainnav = UINavigationController(rootViewController: menu!)
            mainnav.navigationBar.isHidden = true
            appDelegate.window?.rootViewController = mainnav
            appDelegate.window?.makeKeyAndVisible()
        case 3:
            selectedIndex = 3
            let  ViewController  = self.storyboard?.instantiateViewController(withIdentifier:"Reset_PasswordVC") as! Reset_PasswordVC
            let rootNaviagtionVC = UINavigationController(rootViewController: ViewController)
            rootNaviagtionVC.navigationBar.isHidden = true
            self.revealViewController().setFront(rootNaviagtionVC, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
        case 4 :
            selectedIndex = 4
            let  ViewController  = self.storyboard?.instantiateViewController(withIdentifier:"Change_EmailVC") as! Change_EmailVC
            let rootNaviagtionVC = UINavigationController(rootViewController: ViewController)
            rootNaviagtionVC.navigationBar.isHidden = true
            self.revealViewController().setFront(rootNaviagtionVC, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
        case 5 :
            selectedIndex = 5
            let alertController = UIAlertController(title: AppName, message:RKLocalizedString(key: "Are you sure you want to sign out?", comment: "") , preferredStyle: .alert)
            let okAction = UIAlertAction(title: RKLocalizedString(key: "Yes", comment: ""), style: UIAlertActionStyle.default) {
                UIAlertAction in
                let LoginVC_obj = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                let navigationController = UINavigationController(rootViewController: LoginVC_obj)
                appDelegate.window?.rootViewController = navigationController
                appDelegate.window?.makeKeyAndVisible()
                navigationController.navigationBar.isHidden = true
                filters_category.shared.GetSummaryRedemptions.redeemed_offers.removeAll()
                filters_category.shared.GetReviews.removeAll()
                filters_category.shared.GetRedemption.removeAll()
                filters_category.shared.graphdata.removeAll()
                UserDefaults.standard.removeObject(forKey: "email")
                UserDefaults.standard.removeObject(forKey: "password")
                
            }
            let cancelAction = UIAlertAction(title: RKLocalizedString(key: "No", comment: ""), style: UIAlertActionStyle.cancel) {
                UIAlertAction in
            }
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        default:
            let alert = UIAlertController(title: AppName, message:RKLocalizedString(key: "Under Development", comment: "") , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        tableView.reloadData()
    }

}

class Slidemenu_Tableviewcell : UITableViewCell {
    @IBOutlet weak var titleimage:UIImageView!
     @IBOutlet weak var lbltitle:UILabel!
    
}


