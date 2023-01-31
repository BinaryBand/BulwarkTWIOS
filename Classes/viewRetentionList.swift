//
//  viewRetentionList.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 1/30/23.
//

import UIKit

class viewRetentionList: UIViewController {

    @IBOutlet var lvlReportTitle: UILabel!
    
    @IBOutlet var thtSearch: UITextField!
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnReport: UISegmentedControl!
    
    
    var plist: [ProactiveAccount] = []
    var hrempid:String?
    var pool: [ProactiveAccount] = []
    var cancels: [ProactiveAccount] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.borderWidth = 2
        self.view.layer.borderColor = UIColor.darkGray.cgColor
        self.view.layer.cornerRadius = 9
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    func loadData() async{
        
        
        if btnReport.selectedSegmentIndex == 0{
            //retention
            do{
                
                
                let pa = try await DataUtilities.getProactiveRetentionList(hrempid: hrempid ?? "0")
                plist = pa
                
                self.tableView.reloadData()
                self.view.hideToastActivity()
                
            }catch{
                print(error)
                self.view.hideToastActivity()
                
            }
            
        }
        
        if btnReport.selectedSegmentIndex == 1{
            //cancels
        }
        if btnReport.selectedSegmentIndex == 2{
            //pool
        }
        if btnReport.selectedSegmentIndex == 3{
            //pool near me
            
        }
        
        
    }
    

    @IBAction func btnSearch(_ sender: Any) {
        
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension viewRetentionList: UITableViewDelegate {
    
    
    
    
    
    
    
}
extension viewRetentionList: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProactiveCell", for: indexPath) as! ProactiveCell

        //cell.viewController = self
        
        let dist = plist[indexPath.row].distance ?? 0;
        
        cell.lblAddress.text = plist[indexPath.row].address ?? ""
        cell.lblName.text = plist[indexPath.row].name ?? ""
        cell.lblMiles.text = dist.toString() + " Miles"
        cell.lblTitle.text = plist[indexPath.row].serviceType ?? ""
        cell.lblLastService.text = plist[indexPath.row].lastService ?? "1/1/1970"
        var sub = ""
        let type = plist[indexPath.row].typeId ?? 0
        if type == 0{
            sub = "Retention"
            cell.viewTitle.backgroundColor = .purple
        }
        if type == 1{
            sub = "31 Dormant"
            cell.viewTitle.backgroundColor = .purple
        }
        if type == 2{
            sub = "31 Proactive"
            cell.viewTitle.backgroundColor = .purple
        }
        if type == 3{
            sub = "RR Extra Credit"
            cell.viewTitle.backgroundColor = .magenta
        }
        if type == 4{
            sub = "RR Proactive"
            cell.viewTitle.backgroundColor = .magenta
        }
        
        cell.lblSubTitle.text = sub
        
        
        
        
        
        
        return cell
        
    }
    
    
    
    
    
}
