//
//  viewDashboard.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 11/21/22.
//

import UIKit

class viewDashboard: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITabBarDelegate {
    
    @IBOutlet var cvPhotos: UICollectionView!
    
    @IBOutlet var tabbar: UITabBar!
    
    @IBOutlet var tabBarItemChat: UITabBarItem!
    
    @IBOutlet var tabBarReports: UITabBarItem!
    
    var wichUrl:Int!
    var tabUrl:String!
    
    var photoList: [ExcelentPhotos] = []
    var photoListImages:[UIImage] = []
    
    var hrempid:String!
    
    var useCookieInWeb:Bool!
    
    @IBOutlet var lblVin: UILabel!
    
    
    @IBOutlet var lblOdo: UILabel!
    
    @IBOutlet var lblDtcDist: UILabel!
    
    @IBOutlet var viewPhotoRatio: DesignableUIView!
    var rs:RouteStop!
    var mapStops:[MapStop] = []
    var sphome:SPHomeGps!
    var proactiveList:[ProactiveAccount] = []
    
    
    
    
    @IBOutlet var lblPhotoRatio: UILabel!
    @IBOutlet var lblOntime: UILabel!
    @IBOutlet var lblFinisher: UILabel!
    @IBOutlet var lblCompletion: UILabel!
    @IBOutlet var lblProactiveAdds: UILabel!
    @IBOutlet var lblReviewsAll: UILabel!
    @IBOutlet var lblReviewsBad: UILabel!
    @IBOutlet var lblRetRolling: UILabel!
    @IBOutlet var lblRet31: UILabel!
    @IBOutlet var lblEarnedDaysOff: UILabel!
    @IBOutlet var lblIsExtOptins: UILabel!
    @IBOutlet var lblFastComm: UILabel!
    @IBOutlet var lblFastCommDue: UILabel!
    @IBOutlet var lblSalesYTD: UILabel!
    @IBOutlet var lblFastCommMTD: UILabel!
    @IBOutlet var lblSalesMTD: UILabel!
    @IBOutlet var lblSalesAK: UILabel!
    @IBOutlet var lblSalesAKCount: UILabel!
    @IBOutlet var lblSalesYTDCount: UILabel!
    @IBOutlet var lblRankYTD: UILabel!
    @IBOutlet var lblSalesMTDCount: UILabel!
    @IBOutlet var lblRankMTD: UILabel!
    
    
    var appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
    
   // var routeStop: RouteStop?{
   //     didSet {
   //         refreshRouteStopSelected()
    //    }
    //}
    
    
    //@IBOutlet var cvSales: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //cvSales.delegate = self
        //cvSales.dataSource = self
        cvPhotos.delegate = self
        cvPhotos.dataSource = self
       // tabbar.delegate = self
        
        viewToday.delegate = self
        
        
     
        hrempid = appDelegate.hrEmpId ?? ""
        
        appDelegate.viewDash = self
        
        //let obd =
        
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.tapPhotoRatio (_:)))
        
        self.viewPhotoRatio.addGestureRecognizer(gesture)
        
        //cvPhotos.reloadData()
        loadPhotos()
        loadStats()
        loadHomeGPS()
        loadProactiveList()
        
        splitViewController?.show(.primary)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //tabbar.selectedItem = tabbar.items![0]
    }
    
    

    


    
    
    @IBAction func btnMyRoutesClick(_ sender: Any) {
        performSegue(withIdentifier: "showRoutes", sender: nil)
        splitViewController?.hide(.primary)
        
    }
    func loadProactiveList(){
        
        Task{
            
            do{
                proactiveList = try await JsonFetcher.fetchProactiveRetentionJson(hrEmpId: hrempid)
            } catch {
               print(error)
            }
            
            
            
            do{
                //proactiveList = try await DataUtilities.getProactiveRetentionList(hrempid: hrempid)
            }catch{
                print(error)
            }
            
            
        }
           
        
    }
    func loadHomeGPS(){
        Task {
            
            do{
              
                let h = try await DataUtilities.getHomeGps(hrempid: hrempid)
                sphome = h
                
                
            } catch {
                
                print(error)
                
            }
            
            
        }
    }
    
    
    func loadStats(){
        
        
        Task {
            
            do {
                
                let stats = try await JsonFetcher.fetchDashStatsJson(hrEmpId: hrempid)
                
                Utilities.delay(bySeconds: 0.5, dispatchLevel: .main){ [self] in
                    
                  
                    
                    lblOntime.text = stats.serviceprostats.onTime.toPercentString(decimalPlaces: 1)
                    lblPhotoRatio.text = stats.serviceprostats.photoRatio.toPercentString(decimalPlaces: 1)
                    lblFinisher.text = stats.serviceprostats.finisher.toPercentString(decimalPlaces: 1)
                    lblCompletion.text = stats.serviceprostats.completion.toPercentString(decimalPlaces: 1)
                    lblProactiveAdds.text = String(stats.serviceprostats.proactiveAdds)
                    lblReviewsAll.text = String(stats.serviceprostats.reviewsAll)
                    lblReviewsBad.text = String(stats.serviceprostats.reviewsBad)
                    lblRet31.text = stats.serviceprostats.retention31.toPercentString(decimalPlaces: 1)
                    lblRetRolling.text = stats.serviceprostats.retentionRolling.toPercentString(decimalPlaces: 1)
                    lblEarnedDaysOff.text = String(stats.serviceprostats.isExtDaysOff)
                    lblIsExtOptins.text = String(stats.serviceprostats.isExtOptIns)
                    lblFastComm.text = stats.serviceprostats.fastComm.toPercentString(decimalPlaces: 1)
                    lblFastCommDue.text = stats.serviceprostats.fastCommDue.toMoneyString()
                    lblFastCommMTD.text = stats.serviceprostats.fastCommMtd.toMoneyString()
                    lblSalesYTD.text = stats.serviceprostats.salesYtdpay.toMoneyString()
                    lblSalesYTDCount.text = "Rank: " + stats.serviceprostats.salesYtdcount.toString()
                    lblSalesMTD.text = stats.serviceprostats.salesMtdpay.toMoneyString()
                    lblSalesMTDCount.text = "Sales: " + stats.serviceprostats.salesMtdcount.toString()
                    lblRankMTD.text = "Rank: " + stats.serviceprostats.salesMtdrank.toString()
                    lblRankYTD.text = "Rank: " + stats.serviceprostats.salesYtdrank.toString()
                    
                    //let ak = stats.serviceprostats.
                    
                    
                    
                }
                
                // Update collection view content
                //self.cvPhotos.reloadData()
                
                //HUD.hide(true)
                //self.view.hideToastActivity()
                
            } catch {
                print("Request failed with error: \(error)")
            }
            
        }
        
        
        
        
        
        
        
        
    }
    
    func loadPhotos(){
        
        
        //self.view.makeToastActivity(.center)
        
        
        
        
        Task {
            
            do {
                
                photoList = try await JsonFetcher.fetchExcelentPhotosAsync(hrempid: "")
                
                // Update collection view content
                self.cvPhotos.reloadData()
                
                //HUD.hide(true)
                self.view.hideToastActivity()
                
            } catch {
                print("Request failed with error: \(error)")
            }
            
        }
        
        
        
        
        
        
        
        
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           performSegue(withIdentifier: "showPhoto", sender: nil)
       }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return photoList.count
        
        
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        //cell.layer.borderColor = UIColor.blue.cgColor
        //cell.layer.borderWidth = 1
        //cell.layer.cornerRadius = 4
        
        
        Task {
            
            do {
                
                if let url = photoList[indexPath.row].MediaUrl {
                    
                    let img = try await JsonFetcher.fetchPhotoAsync(urlStr: url)
                    
                    // Update collection view content
                    
                    
                    //HUD.hide(true)
                    //collectionView.hideToastActivity()
                    
                    
                    
                    
                    //let img = UIImage(named: "gbtest")
                    //print(img.size.width as Any)
                    cell.imgThumb.image = img
                }
                //photoListImages.append(img)
                
               // self.cvPhotos.reloadData()
                
                
            } catch {
                print("Request failed with error: \(error)")
            }
            
            
            
            
            
        }
        
        
        return cell
        
    }
        
    @IBAction func unwindToMain(segue: UIStoryboardSegue){
           // let temp = "temp message"
           // print(temp)
       }
        
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "showPhoto" {
               if let indexPaths = cvPhotos.indexPathsForSelectedItems{
                   let destinationController = segue.destination as! viewPhoto
                   destinationController.TakenBy = photoList[indexPaths[0].row].AccountNumber
                   destinationController.TakenOn = photoList[indexPaths[0].row].Date
                   destinationController.Rating = photoList[indexPaths[0].row].MarketingGrade
                   destinationController.TakenBy = photoList[indexPaths[0].row].ProName
                   //destinationController.image.image = photoListImages[indexPaths[0].row]
                   destinationController.MediaUrl = photoList[indexPaths[0].row].MediaUrl
                   destinationController.Office1 = photoList[indexPaths[0].row].OfficeName
                   cvPhotos.deselectItem(at: indexPaths[0], animated: false)
               }
           }
        
        
        
        if segue.identifier == "showWeb" {
            
            

            
                let destinationController = segue.destination as! viewModalWeb
                destinationController.url = tabUrl
            destinationController.hrEmpId = hrempid
          
            if let uc = useCookieInWeb{
                destinationController.useCookie = uc
            }
            
            
        }
        if segue.identifier == "showRouteStop" {
            
            

            
                let destinationController = segue.destination as! viewRouteStop
                destinationController.url = tabUrl
            destinationController.rs = self.rs
            //destinationController.hrEmpId = hrempid
          

            
        }
        if segue.identifier == "showMyPhotos" {
            
            
                   
            
                let destinationController = segue.destination as! viewMyPhotos
                destinationController.hrempid = hrempid
   
            
        }
        
        if segue.identifier == "showMap"{
            
            
            let dc = segue.destination as! viewMap
            dc.mapStops = mapStops
            dc.homegps = sphome
            dc.proactivList = proactiveList
            
            
        }

        
        
       }
    
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item == tabBarItemChat) {
            // Code for item 1

            
            
            
        }
        if(item == tabBarReports) {
            tabUrl = "https://dashboard.bulwarkapp.com/mgrapp2/techstatsipad.aspx?h=" + hrempid
            useCookieInWeb = false
            performSegue(withIdentifier: "showWeb", sender: nil)        }
    }
    

    @IBAction func ChatClicked(){
        tabUrl = "https://kpwebapi2.bulwarkapp.com/chat?hrempid=" + hrempid
        useCookieInWeb = true
        print(tabUrl!)
        performSegue(withIdentifier: "showWeb", sender: nil)
       
    }
    
    @IBAction func btnIsExtended(_ sender: Any) {
        
        tabUrl = "https://dashboard.bulwarkapp.com/mgrapp2/isextendeddaysoff2.aspx?h=" + hrempid
        useCookieInWeb = false
        performSegue(withIdentifier: "showWeb", sender: nil)
        
        
    }
    
    
    @IBAction func btnTodaysMap(_ sender: Any) {
        
        
        performSegue(withIdentifier: "showMap", sender: nil)
        
    }
    
    
    @IBAction func myPhotosClick(_ sender: Any) {
        
        performSegue(withIdentifier: "showMyPhotos", sender: nil)   
    }
    
    @IBAction func btnSalesClick(_ sender: Any) {
        
        tabUrl = "https://twreportcore.bulwarkapp.com/dashboardsharedreports/salesstats?ipad=yes&h=" + hrempid
        useCookieInWeb = false
        performSegue(withIdentifier: "showWeb", sender: nil)
        
        
    }
    
    @objc func tapPhotoRatio(_ sender:UITapGestureRecognizer){
        // do other task
        
        tabUrl = "https://servicesnapshot.bulwarkapp.com?&hrempid=" + hrempid
        useCookieInWeb = false
        performSegue(withIdentifier: "showWeb", sender: nil)
        
    }
    
    @IBAction func btnReports(_ sender: Any) {
        
        //showRetentionList
        
        
        performSegue(withIdentifier: "showRetentionList", sender: nil)
        
        
        
    }
    
    @IBAction func btnMyPay(_ sender: Any) {
        
        tabUrl = "https://kpwebapi.bulwarkapp.com/payrollreports/employee?apikey=aeb9ce4f-f8af-4ced-a4b3-683b6d29864d&hrempid=" + hrempid + "&viewedby=" + hrempid
        useCookieInWeb = true
        print(tabUrl!)
        performSegue(withIdentifier: "showWeb", sender: nil)
        
        
    }
    
    
    @IBAction func btnIsExt7am(_ sender: Any) {
        
        let customView = self.storyboard?.instantiateViewController(withIdentifier: "popIsextEarly") as? viewISExtendedOptIn
        

        let d = "For Tomorrows Route"
        
    customView?.DateFor = d
        
        customView?.istoday = 0
        customView?.isEarly = 1
        
        
        customView?.modalTransitionStyle = .crossDissolve
        customView?.modalPresentationStyle = .overCurrentContext
        
        
        
        
        
        //let nframe = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)

        self.present(customView!,animated:true, completion:nil)
        
        
    }
    
    @IBAction func btnIsExt6PmTomorrow(_ sender: Any) {
        let customView = self.storyboard?.instantiateViewController(withIdentifier: "popIsext") as? viewISExtendedOptIn
        

        let d = "For Tomorrows Route"
        
    customView?.DateFor = d
        
        customView?.istoday = 0
        customView?.isEarly = 0
        
        customView?.modalTransitionStyle = .crossDissolve
        customView?.modalPresentationStyle = .overCurrentContext

        self.present(customView!,animated:true, completion:nil)
        
    }
    
    
    
    @IBAction func btnIsExt6PmToday(_ sender: Any) {
        
        let customView = self.storyboard?.instantiateViewController(withIdentifier: "popIsext") as? viewISExtendedOptIn
        

        let d = "For Tomorrows Route"
        
    customView?.DateFor = d
        
        customView?.istoday = 1
        customView?.isEarly = 0
        
        customView?.modalTransitionStyle = .crossDissolve
        customView?.modalPresentationStyle = .overCurrentContext

        self.present(customView!,animated:true, completion:nil)
        
        
    }
    
    
    
    
    @IBAction func btnServiceSnapShot(_ sender: Any) {
        
        //fbf test
        
        
        //viewFBFSearch* customView = [[self storyboard] instantiateViewControllerWithIdentifier:@"viewFBFSearch"];
        
        let customView = self.storyboard?.instantiateViewController(withIdentifier: "viewFBFSearch") as? viewFBFSearch
        
        customView?.HrEmpId = hrempid;
        customView?.FromPage = "Account Search"
        customView?.CustomerId = 100492;
        customView?.ServiceId = 3627;
        customView?.isNC = false;
        customView?.accountNumber = "103328";
        customView?.ServiceType = "MO";
        //customView.istoday = 1;

        
        customView?.modalTransitionStyle = .coverVertical
        customView?.modalPresentationStyle = .pageSheet
        

        
        self.present(customView!,animated:true, completion:nil)
        
        
        
        
        
    }
    
    @IBAction func btnNewSale(_ sender: Any) {
        
        performSegue(withIdentifier: "showAddSales", sender: nil)
        
        
        
    }
    
}
extension viewDashboard:StopSelectionDelegate{
    func routeLoaded(ms: [MapStop]) {
        mapStops = ms
    }
    
    
    func stopSelected(selectedRouteStop: RouteStop){
        
        rs = selectedRouteStop
        
        tabUrl = selectedRouteStop.encodedurl
        useCookieInWeb = false
        performSegue(withIdentifier: "showRouteStop", sender: nil)
        splitViewController?.hide(.primary)
        
    }
    
    func routeSelected(){
        performSegue(withIdentifier: "showRoutes", sender: nil)
        splitViewController?.hide(.primary)
    }

    
}
