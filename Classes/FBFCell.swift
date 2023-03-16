//
//  FBFCell.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 11/7/22.
//

import UIKit
import Toast






class FBFCell: UITableViewCell {

    weak var viewController: UIViewController? = nil
    
    @IBOutlet var lblDate: UILabel!
    
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var lblTimeBlock: UILabel!
    
    @IBOutlet var lblDistance: UILabel!
    @IBOutlet var lblWeekDay: UILabel!
    
    @IBOutlet var btnAddToRoute: UIButton!
    
    
    var route_id: Int!
    var stTb: String!
    var fromHrEMPId: String!
    var fromPage: String!
    var customer_id: Int!
    var service_id: Int!
    var isNC: Bool!
    var isMyRoute:Bool!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnPressAddToRoute(_ sender: Any) {
        
        var message = ""
        
        if isMyRoute{
            message = "Add to my route for today?"
        }else{
            message = "Add to Route " + (lblTitle.text ?? "") + " between " + (lblTimeBlock.text ?? "")
        }
        
        
        let alertController = UIAlertController(title: "Confirm", message: message, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] (action) in
            
            self.viewController?.view.makeToastActivity(.center)
            
            
            
        
            let atrp = AddToRouteParams(RouteId: self.route_id, StartAt: self.stTb, FromHrEmpId: self.fromHrEMPId, RollingKey: "", FromPage: self.fromPage, CustomerId: self.customer_id, ServiceId: self.service_id, isNC: self.isNC, isTransfer: false, workOrderId: 0)
        
        
            print(atrp)
            
            //let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
            //appDelegate.viewSched = self
           

            
            
            
     
         //   let h = appDelegate.hrEmpId ?? ""
            
            //let fbfSamp = FBFSearch.sampleData
           
            
            let urlStr = "https://twapiweb.bulwarkapp.com/AddToRoute"
            
            //let urlStr = "http://10.211.55.4:5095/AddToRoute"
            
            
            Task {
                
                do {
                    
                    let auResult = try await JsonFetcher.postAddToRouteJson(urlStr: urlStr, addToRouteParam: atrp)
                    
                    // Update collection view content
                    //self.tableView.reloadData()
                    
                    //HUD.hide(true)
                    if(auResult.success == false){
                        print(auResult.error)
                        
                        self.viewController?.view.hideToastActivity()
                        
                        let msg = "Error adding with reason " + auResult.error + " Contact the support center to add this service to route"
                        
                        let alertController2 = UIAlertController(title: "Error Adding To Route", message: msg, preferredStyle: .alert)
                        alertController2.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                            self.viewController?.dismiss(animated: true, completion: nil)
                            
                            
                        }))
                        
                        viewController?.present(alertController2, animated: true)
                        
                        
                    }else{
                        
                        self.viewController?.view.hideToastActivity()
                        
                        var style = ToastStyle()
                        style.titleFont = UIFont(name: "Arial-BoldMT", size: 14)!
                        style.messageFont = UIFont(name: "ArialMT", size: 12)!
                        //style.messageColor = UIColor.yellow
                        style.messageAlignment = .center
                        style.imageSize = CGSize(width: 50, height: 45)
                        style.backgroundColor = UIColor(red: 62.0 / 255.0, green: 128.0 / 255.0, blue: 180.0 / 255.0, alpha: 0.9)
                        
                        self.viewController?.view.makeToast("Account added to route", duration: 2.2, position: .center, title: "Success", image: UIImage(named: "GreenCheckmark.png"), style: style)
                        
                        self.viewController?.dismiss(animated: true, completion: nil)
                        
                        }
                    
                    
                    
                } catch {
                    print("Request failed with error: \(error)")
                }
                
            }



            
            
            
        
        }))

        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
          
            

            
        }))


        viewController?.present(alertController, animated: true)
        
        
        
        
        
        
        
        
    }
}
