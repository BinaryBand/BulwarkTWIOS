//
//  viewFBFSearch.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 9/21/22.
//

import UIKit

class viewFBFSearch: UIViewController, UITableViewDelegate,UITableViewDataSource{
   
    
    var fbfList: [FBFSearch] = []
    var currentIndex = 0
    //var HUD: MBProgressHUD!
    
    @objc var HrEmpId:String!
    @objc var ServiceType:String!
    @objc var accountNumber:String!
    @objc var FromPage:String!
    @objc var CustomerId:Int = 0
    @objc var ServiceId:Int = 0
    @objc var isNC:Bool = false
    @objc var viewOne: ViewOne!
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var acctLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        self.view.layer.borderWidth = 2
        self.view.layer.borderColor = UIColor.darkGray.cgColor
        self.view.layer.cornerRadius = 9
        //tableView.layer.cornerRadius = 15
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //HUD = MBProgressHUD(view: view)
        //view.addSubview(HUD)
        //HUD.show(true)
        loadData()
        
        
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fbfList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //FBFMyRouteCell
        
        let type = fbfList[indexPath.row].type
        
        if(type == 1){
            //normal cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "FBFCell", for: indexPath) as! FBFCell

            cell.viewController = self
            
            let stb = Date(fromString: fbfList[indexPath.row].tbStart, format: .usDateTime12WithSec)
            let etb = Date(fromString: fbfList[indexPath.row].tbEnd, format: .usDateTime12WithSec)
            cell.stTb = stb?.toString(format: .custom("MM/dd/yyyy HH:mm"))
            cell.route_id = fbfList[indexPath.row].route_id
            cell.fromHrEMPId = self.HrEmpId
            cell.fromPage = self.FromPage
            cell.customer_id = self.CustomerId
            cell.service_id = self.ServiceId
            cell.isNC = false
            
            
            
            
            let rdate = Date(fromString: fbfList[indexPath.row].rDate, format: Date.DateFormatType.usDate)
            cell.lblWeekDay.text = rdate?.toString(format: .custom("EEEE"))
            cell.lblDate.text = rdate?.toString(format: .custom("M/d/yyyy"))
            cell.lblTitle.text = fbfList[indexPath.row].title
            cell.lblTimeBlock.text = (stb?.toString(format: .custom("h:mm a")) ??  "") + " to " + (etb?.toString(format: .custom("h:mm a")) ?? "")
            cell.lblDistance.text = String(format: "%.2f", fbfList[indexPath.row].dist)
            
            

            
            
            
            
            //cell.layer.cornerRadius = 5
            return cell
            
            
        } else if(type == 10){
            //my route for today
            let cell = tableView.dequeueReusableCell(withIdentifier: "FBFMyRouteCell", for: indexPath) as! FBFCell

            cell.viewController = self
            
            let stb = Date(fromString: fbfList[indexPath.row].tbStart, format: .usDateTime12WithSec)
          
            cell.stTb = stb?.toString(format: .custom("MM/dd/yyyy+HH:mm"))
            cell.route_id = fbfList[indexPath.row].route_id
            
                      
            cell.lblWeekDay.text = "Today"
            cell.lblDate.text = "My Route"
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "FBFMyRouteCell", for: indexPath) as! FBFCell

            cell.viewController = self
            
            let stb = Date(fromString: fbfList[indexPath.row].tbStart, format: .usDateTime12WithSec)
          
            cell.stTb = stb?.toString(format: .custom("MM/dd/yyyy+HH:mm"))
            cell.route_id = fbfList[indexPath.row].route_id
            
                      
            cell.lblWeekDay.text = "err"
            cell.lblDate.text = "err"
            cell.lblTitle.text = "err"
            return cell
            
            
        }
        
        
        

        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 66
    }
    

    func loadData(){
        
        
        self.view.makeToastActivity(.center)
        
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        //appDelegate.viewSched = self
       

        
        
        
 
        let h = appDelegate.hrEmpId ?? ""
        
        //let fbfSamp = FBFSearch.sampleData
       
        
        var urlStr = "https://fbf.bulwarkapp.com/api/ScheduleIpadApp.ashx?"
        
        urlStr += "AccountNumber="
        urlStr += self.accountNumber
        urlStr += "&ServiceType="
        urlStr += self.ServiceType
        urlStr += "&user=Ipad-"
        urlStr += self.HrEmpId
        
        
        Task {
            
            do {
                
                fbfList = try await JsonFetcher.fetchFBFResultsAsync(urlStr: urlStr, hrEmpId: h)
                
                // Update collection view content
                self.tableView.reloadData()
                
                //HUD.hide(true)
                self.view.hideToastActivity()
                
            } catch {
                print("Request failed with error: \(error)")
            }
            
        }



        
        
    }
    


}
