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
    
    @IBOutlet var refreshButton: LoadingUIButton!
    
    var plist: [ProactiveAccount] = []
    var hrempid:String?
    var pool: [ProactiveAccount] = []
    var cancels: [ProactiveAccount] = []
    var appDelegate:BulwarkTWAppDelegate = (UIApplication.shared.delegate as? BulwarkTWAppDelegate)!
    var acctSearch: [ProactiveAccount] = []

    @IBOutlet var btnsearch: UIButton!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.borderWidth = 2
        self.view.layer.borderColor = UIColor.darkGray.cgColor
        self.view.layer.cornerRadius = 9
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        disablebuttonswhileloading()
        Task{
            await loadData(refreshFromServer: false)
            enablebuttonswhendone()
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnRefresh(_ sender: Any) {
        disablebuttonswhileloading()
       
        Task{
            
            await self.loadData(refreshFromServer:true)
            
            self.enablebuttonswhendone()
            
          
        }
        
        
    }
    
    
    func loadData(refreshFromServer: Bool) async{
        
        
        if btnReport.selectedSegmentIndex == 0{
            //retention
            lvlReportTitle.text = "Proactive Retention"
            do{
                
                
                let pa = try await DataUtilities.getProactiveRetentionList(hrempid: hrempid ?? "0", refreshNow: refreshFromServer)
                plist = pa
                for i in plist.indices {
                    let ulat = Double(appDelegate.lat) ?? 0
                    let ulon = Double(appDelegate.lon) ?? 0
                    
                    let d = Utilities.haversine(lat1: plist[i].lat ?? 0, lon1: plist[i].lon ?? 0, lat2: ulat,lon2: ulon)
                    plist[i].distance = d
                    
                }
                plist.sort()
                
                
                
                
                
            }catch{
                print(error)
                
                
            }
            
        }
        
        if btnReport.selectedSegmentIndex == 1{
            //cancels
            lvlReportTitle.text = "Recently Canceled Accounts"
            do{
                cancels = try await JsonFetcher.fetchCancelsJson(hrEmpId: hrempid ?? "0")
                
                for i in cancels.indices{
                    let ulat = Double(appDelegate.lat) ?? 0
                    let ulon = Double(appDelegate.lon) ?? 0
                    
                    let d = Utilities.haversine(lat1: cancels[i].lat ?? 0, lon1: cancels[i].lon ?? 0, lat2: ulat,lon2: ulon)
                    cancels[i].distance = d
                    
                }
                cancels.sort()
                
            } catch {
                print(error)
            }
            
            
        }
        if btnReport.selectedSegmentIndex == 2{
            //pool
            lvlReportTitle.text = "Pool Of Customers"
            let ulat = Double(appDelegate.lat) ?? 0
            let ulon = Double(appDelegate.lon) ?? 0
            let hr = appDelegate.hrEmpId ?? ""
            do{
                pool = try await JsonFetcher.fetchPoolJson(hrEmpId: hr, lat: ulat, lon: ulon)
                
                for i in pool.indices{
                    let ulat = Double(appDelegate.lat) ?? 0
                    let ulon = Double(appDelegate.lon) ?? 0
                    
                    let d = Utilities.haversine(lat1: pool[i].lat ?? 0, lon1: pool[i].lon ?? 0, lat2: ulat,lon2: ulon)
                    pool[i].distance = d
                    
                }
                pool.sort()
                
                
                
                
            }catch{
                print(error)
            }
            
        }
        if btnReport.selectedSegmentIndex == 3{
            //pool near me
            //lvlReportTitle.text = "Account Search"
            
        }
    }
    
    @IBAction func btnReportChange(_ sender: Any) {
       disablebuttonswhileloading()
        Task{
            
            await loadData(refreshFromServer: false)
            
           
            enablebuttonswhendone()
        }
        
    }
    
    @IBAction func btnSearch(_ sender: Any) {
       disablebuttonswhileloading()
        
        lvlReportTitle.text = "Account Search"
        btnReport.selectedSegmentIndex = 3
        
        let hr = appDelegate.hrEmpId ?? ""
        let searchstr = thtSearch.text ?? ""
        
        if searchstr != "" {
          
        
            Task{
                do{
                    
                    acctSearch = try await JsonFetcher.fetchAcctSearchJson(hrEmpId: hr, searchStr: searchstr)
                    
                    for i in acctSearch.indices{
                        let ulat = Double(appDelegate.lat) ?? 0
                        let ulon = Double(appDelegate.lon) ?? 0
                        
                        let d = Utilities.haversine(lat1: acctSearch[i].lat ?? 0, lon1: acctSearch[i].lon ?? 0, lat2: ulat,lon2: ulon)
                        acctSearch[i].distance = d
                        
                    }
                    acctSearch.sort()
                    
                    
                    
                    enablebuttonswhendone()
                    
                }catch{
                    print(error)
                    enablebuttonswhendone()
                }
            }
        }
        
    }
    
    
    func disablebuttonswhileloading(){
        self.view.makeToastActivity(.center)
        self.refreshButton.showLoading()
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        btnsearch.isEnabled = false
        thtSearch.isEnabled = false
        btnReport.isEnabled = false
        
    }
    
    func enablebuttonswhendone(){
        DispatchQueue.main.async() {
            // your UI update code
            self.tableView.reloadData()
            self.refreshButton.hideLoading()
            self.view.hideToastActivity()
            self.btnsearch.isEnabled = true
            self.thtSearch.isEnabled = true
            self.btnReport.isEnabled = true
            self.tableView.allowsSelection = true
            self.tableView.isScrollEnabled = true
        }
        
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

extension viewRetentionList: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let customView = self.storyboard?.instantiateViewController(withIdentifier: "modalWeb") as? viewModalWeb
        
        
       // let d = "For Tomorrows Route"
        
        customView?.hrEmpId = appDelegate.hrEmpId
        
        var details = ""
        var acct = ""
        if btnReport.selectedSegmentIndex == 1{
            details = cancels[indexPath.row].detailsUrl ?? ""
            acct = cancels[indexPath.row].accountNumber ?? ""
            
        } else if btnReport.selectedSegmentIndex == 2 {
            details =  pool[indexPath.row].detailsUrl ?? ""
            acct = pool[indexPath.row].accountNumber ?? ""
            
        }else if btnReport.selectedSegmentIndex == 3 {
            details =  acctSearch[indexPath.row].detailsUrl ?? ""
            acct = acctSearch[indexPath.row].accountNumber ?? ""
            
        }else{
            details =  plist[indexPath.row].detailsUrl ?? ""
            acct = plist[indexPath.row].accountNumber ?? ""
            
        }
        
        
        customView?.url = details
        customView?.useCookie = false
        customView?.title = acct
        
        
        customView?.modalTransitionStyle = .crossDissolve
        customView?.modalPresentationStyle = .pageSheet
        
        
        self.present(customView!,animated:true, completion:nil)
        
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if btnReport.selectedSegmentIndex == 1{
            return cancels.count
        } else if btnReport.selectedSegmentIndex == 2 {
            return pool.count
        }else if btnReport.selectedSegmentIndex == 3 {
           return acctSearch.count
        }else{
            return plist.count
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if btnReport.selectedSegmentIndex == 0{
            return retentionCell(index: indexPath.row, indexPath: indexPath)
        } else if btnReport.selectedSegmentIndex == 1 {
            return cancelCell(index: indexPath.row, indexPath: indexPath)
        }else if btnReport.selectedSegmentIndex == 2 {
            return poolCell(index: indexPath.row, indexPath: indexPath)
        }else if btnReport.selectedSegmentIndex == 3 {
            return accountCell(index: indexPath.row, indexPath: indexPath)
        }else{
            return retentionCell(index: indexPath.row, indexPath: indexPath)
        }
    }
    
    func retentionCell(index: Int, indexPath: IndexPath) ->UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProactiveCell", for: indexPath) as! ProactiveCell

        //cell.viewController = self
        
        cell.lblAddress.text = plist[indexPath.row].address ?? ""
        cell.lblName.text = plist[indexPath.row].name ?? ""
        
        cell.lblTitle.text = plist[indexPath.row].serviceType ?? ""
        cell.lblLastService.text = plist[indexPath.row].lastService ?? "1/1/1970"
        
        let ulat = Double(appDelegate.lat) ?? 0
        let ulon = Double(appDelegate.lon) ?? 0
        
        let d = Utilities.haversine(lat1: plist[indexPath.row].lat ?? 0, lon1: plist[indexPath.row].lon ?? 0, lat2: ulat,lon2: ulon)
        
        cell.lblMiles.text = d.toNumberString(decimalPlaces: 1) + " Miles"
        
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
        if let onrt = plist[index].onRoute {
            if onrt{
                cell.viewTitle.backgroundColor = .orange
                cell.lblLastService.text = "On Route"
            }
        }
        
        
        cell.lblSubTitle.text = sub
        
        return cell
 
    }
    
    func cancelCell(index: Int, indexPath: IndexPath) ->UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProactiveCell", for: indexPath) as! ProactiveCell

        //cell.viewController = self
        
        
        cell.lblAddress.text = cancels[index].address ?? ""
        cell.lblName.text = cancels[index].name ?? ""
        
        cell.lblTitle.text = cancels[index].serviceType ?? ""
        cell.lblLastService.text = cancels[index].lastService ?? "1/1/1970"
        
        let ulat = Double(appDelegate.lat) ?? 0
        let ulon = Double(appDelegate.lon) ?? 0
        
        let d = Utilities.haversine(lat1: cancels[index].lat ?? 0, lon1: cancels[index].lon ?? 0, lat2: ulat,lon2: ulon)
        
        cell.lblMiles.text = d.toNumberString(decimalPlaces: 1) + " Miles"
        
        let sub = cancels[index].status ?? ""
        //let type = cancels[indexPath.row].typeId ?? 0
        
        
        if sub.starts(with: "Move"){
            
            cell.viewTitle.backgroundColor = .blue
        } else {
            cell.viewTitle.backgroundColor = .purple
        }
        if let onrt = cancels[index].onRoute {
            if onrt{
                cell.viewTitle.backgroundColor = .orange
                cell.lblLastService.text = "On Route"
            }
        }
        
        cell.lblSubTitle.text = sub

        return cell
    }
    
    func accountCell(index: Int, indexPath: IndexPath) ->UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProactiveCell", for: indexPath) as! ProactiveCell

        cell.lblAddress.text = acctSearch[index].address ?? ""
        cell.lblName.text = acctSearch[index].name ?? ""
        
        cell.lblTitle.text = acctSearch[index].serviceType ?? ""
        cell.lblLastService.text = acctSearch[index].lastService ?? "1/1/1970"
        
        let ulat = Double(appDelegate.lat) ?? 0
        let ulon = Double(appDelegate.lon) ?? 0
        
        let d = Utilities.haversine(lat1: acctSearch[index].lat ?? 0, lon1: acctSearch[index].lon ?? 0, lat2: ulat,lon2: ulon)
        
        cell.lblMiles.text = d.toNumberString(decimalPlaces: 1) + " Miles"
        
        cell.viewTitle.backgroundColor = .blue
        if let onrt = acctSearch[index].onRoute {
            if onrt{
                cell.viewTitle.backgroundColor = .orange
                cell.lblLastService.text = "On Route"
            }
        }
        
        cell.lblSubTitle.text = acctSearch[index].accountNumber ?? ""

        return cell
    }
    
    func poolCell(index: Int, indexPath: IndexPath) ->UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProactiveCell", for: indexPath) as! ProactiveCell

        cell.lblAddress.text = pool[index].address ?? ""
        cell.lblName.text = pool[index].name ?? ""
        
        cell.lblTitle.text = pool[index].serviceType ?? ""
        cell.lblLastService.text = pool[index].lastService ?? "1/1/1970"
        
        let ulat = Double(appDelegate.lat) ?? 0
        let ulon = Double(appDelegate.lon) ?? 0
        
        let d = Utilities.haversine(lat1: pool[index].lat ?? 0, lon1: pool[index].lon ?? 0, lat2: ulat,lon2: ulon)
        
        cell.lblMiles.text = d.toNumberString(decimalPlaces: 1) + " Miles"
        
        cell.viewTitle.backgroundColor = .blue
        
        
        cell.lblSubTitle.text = pool[index].accountNumber ?? ""
        
        if let onrt = pool[index].onRoute {
            if onrt{
                cell.viewTitle.backgroundColor = .orange
                cell.lblLastService.text = "On Route"
            }
        }
        

        return cell
    }
}
