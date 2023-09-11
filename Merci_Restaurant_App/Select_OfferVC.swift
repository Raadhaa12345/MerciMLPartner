//
//  Select_OfferVC.swift
//  Merci_Restaurant_App
//
//  Created by RipenApp on 25/10/18.
//  Copyright © 2018 RipenApp. All rights reserved.
//

import UIKit

protocol offerProtocol {
     func Backto_Offer(selected_offers:[String])
}

class Select_OfferVC: UIViewController {

    @IBOutlet weak var topview : UIView!
    @IBOutlet weak var offer_TableView:UITableView!
    @IBOutlet weak var lblSelectOffer: UILabel!
    
    
    var selectedIndx = 0
    var offerdelegate:offerProtocol?
    
    var offer_Array = [[String:Any]]()
    var selected_offers = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        lblSelectOffer.text = RKLocalizedString(key: "Select Offer", comment: "")
    }

    
    func setUI(){
        self.topview.layer.shadowColor = UIColor.lightGray.cgColor
        self.topview.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.topview.layer.shadowOpacity = 0.5
        self.topview.layer.shadowRadius = 5.0
        self.topview.layer.masksToBounds = false
        offer_TableView.tableFooterView = UIView()
    }
    @IBAction func Backbtn(_ sender : UIButton){
        offerdelegate?.Backto_Offer(selected_offers: selected_offers)
        self.navigationController?.popViewController(animated: true)
        
    }

}
extension Select_OfferVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offer_Array.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "offer_Tablecell", for: indexPath) as! offer_Tablecell
        cell.innerView.layer.cornerRadius = 10
        cell.innerView.layer.shadowColor = UIColor.lightGray.cgColor
        cell.innerView.layer.shadowOpacity = 0.4
        cell.innerView.layer.shadowOffset = CGSize.zero
        cell.innerView.layer.shadowRadius = 5
        cell.lbl_offername.text = offer_Array[indexPath.row]["name"] as? String
        cell.lbl_description.text = offer_Array[indexPath.row]["description"] as? String
        if let img_Url = URL(string:offer_Array[indexPath.row]["image"] as! String)
        {
            cell.outlet_image.af_setImage(withURL: img_Url, placeholderImage: #imageLiteral(resourceName: "placeholder"), filter: nil, progress: nil, completion: { (res) in})
        }
        if (selected_offers.contains(offer_Array[indexPath.row]["id"] as! String)) {
            cell.img_selection.image = #imageLiteral(resourceName: "done_select")
        }
        else {
            cell.img_selection.image = #imageLiteral(resourceName: "done_unselect")
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.isSelected == true {
            if (selected_offers.contains(offer_Array[indexPath.row]["id"] as! String)) {
                selected_offers.remove(at: selected_offers.index(of:offer_Array[indexPath.row]["id"] as! String)!)
                print(selected_offers)
            }else {
                selected_offers.append(offer_Array[indexPath.row]["id"] as! String)
                print(selected_offers)
            }
            
        }
        offer_TableView.reloadData()
       }
    
}
    



class offer_Tablecell: UITableViewCell {
    @IBOutlet weak var innerView : UIView!
    @IBOutlet weak var img_selection : UIImageView!
    @IBOutlet weak var lbl_offername : UILabel!
    @IBOutlet weak var lbl_description : UILabel!
    @IBOutlet weak var outlet_image : UIImageView!
    
}
