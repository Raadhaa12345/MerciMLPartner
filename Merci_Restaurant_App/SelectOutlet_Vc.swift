//
//  SelectOutlet_Vc.swift
//  Merci_Restaurant_App
//
//  Created by RipenApp on 22/10/18.
//  Copyright © 2018 RipenApp. All rights reserved.
//

import UIKit

protocol outletprotocol {
    func Backto_Outlet(selected_outlets:[String])
}

class SelectOutlet_Vc: UIViewController {

     @IBOutlet weak var topview : UIView!
     @IBOutlet weak var outlet_TableView:UITableView!
    
    @IBOutlet weak var lblSelectOutlet: UILabel!
    
    
    var outlet_Array = [[String:Any]]()
     var outletdelegate:outletprotocol?
    var selected_Outlets = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        lblSelectOutlet.text = RKLocalizedString(key: "Select Outlet", comment: "")
        setUI()
//        for id in outlet_Array {
//            selected_Outlets.append(id["id"] as! String)
//        }
       print(selected_Outlets)
    }

    func setUI(){
        self.topview.layer.shadowColor = UIColor.lightGray.cgColor
        self.topview.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.topview.layer.shadowOpacity = 0.5
        self.topview.layer.shadowRadius = 5.0
        self.topview.layer.masksToBounds = false
        outlet_TableView.tableFooterView = UIView()
    }
    @IBAction func Backbtn(_ sender : UIButton){
        outletdelegate?.Backto_Outlet(selected_outlets: selected_Outlets)
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

extension SelectOutlet_Vc : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return outlet_Array.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "outlet_Tablecell", for: indexPath) as! outlet_Tablecell
        cell.innerView.layer.cornerRadius = 10
        cell.innerView.layer.shadowColor = UIColor.lightGray.cgColor
        cell.innerView.layer.shadowOpacity = 0.4
        cell.innerView.layer.shadowOffset = CGSize.zero
        cell.innerView.layer.shadowRadius = 5
        cell.lbl_outletname.text = outlet_Array[indexPath.row]["name"] as? String
        cell.lbl_outletaddress.text = outlet_Array[indexPath.row]["address"] as? String
        if let img_Url = URL(string:outlet_Array[indexPath.row]["image"] as! String)
        {
            cell.outlet_image.af_setImage(withURL: img_Url, placeholderImage: #imageLiteral(resourceName: "placeholder"), filter: nil, progress: nil, completion: { (res) in})
        }
        if (selected_Outlets.contains(outlet_Array[indexPath.row]["id"] as! String)) {
            cell.check_image.image = #imageLiteral(resourceName: "done_select")
        }
        else {
            cell.check_image.image = #imageLiteral(resourceName: "done_unselect")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.isSelected == true {
            if (selected_Outlets.contains(outlet_Array[indexPath.row]["id"] as! String)) {
                selected_Outlets.remove(at: selected_Outlets.index(of:outlet_Array[indexPath.row]["id"] as! String)!)
                print(selected_Outlets)
            }else {
                selected_Outlets.append(outlet_Array[indexPath.row]["id"] as! String)
                print(selected_Outlets)
            }
            
        }
        outlet_TableView.reloadData()
    }
}

class outlet_Tablecell: UITableViewCell {
    @IBOutlet weak var innerView : UIView!
    @IBOutlet weak var lbl_outletname : UILabel!
    @IBOutlet weak var lbl_outletaddress : UILabel!
    @IBOutlet weak var outlet_image : UIImageView!
    @IBOutlet weak var check_image : UIImageView!

}
