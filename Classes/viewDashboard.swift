//
//  viewDashboard.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 11/21/22.
//

import UIKit
import Toast
import WebKit

class viewDashboard: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITabBarDelegate {
    
    @IBOutlet var cvPhotos: UICollectionView!
    
  
    
    var wichUrl:Int!
    var tabUrl:String!
    
    var photoList: [ExcelentPhotos] = []
    var photoListImages:[UIImage] = []
    
    
    var officeCode:String?
    
    var useCookieInWeb:Bool!
    
    @IBOutlet var lblVin: UILabel!
    
    
    @IBOutlet var lblOdo: UILabel!
    
    @IBOutlet var lblDtcDist: UILabel!
    
    @IBOutlet var viewPhotoRatio: DesignableUIView!
    var rs:RouteStop!
    var mapStops:[MapStop] = []
    var sphome:SPHomeGps!
    var proactiveList:[ProactiveAccount] = []
    var cancelList:[ProactiveAccount] = []
    var RouteId = 0
    var ttvid = 0
    
    
    @IBOutlet var tmpview: UIView!
    
    
    
    @IBOutlet var btnFastComm: UIButton!
    
    @IBOutlet var lblClockIn: UILabel!
    
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
    @IBOutlet var txtRouteNotes: UITextView!
    @IBOutlet var lblRouteProgress: UILabel!
    
    @IBOutlet var btnClockIn: UIButton!
    
    @IBOutlet var viewOntime: DesignableUIView!
    
    @IBOutlet weak var viewFinisher: DesignableUIView!
    
    @IBOutlet weak var viewCompletin: DesignableUIView!
    
    @IBOutlet var lblLottoPot: UILabel!
    
    @IBOutlet var lblLottoRange: UILabel!
    
    @IBOutlet var lblTicketsEarned: UILabel!
    
    @IBOutlet weak var viewReviews: DesignableUIView!
    @IBOutlet weak var viewProactiveAdds: DesignableUIView!
    
    @IBOutlet weak var viewThiryOnePlus: DesignableUIView!
    
    @IBOutlet weak var viewRolling: DesignableUIView!
    
    @IBOutlet var lblTrainingType: UILabel!
    @IBOutlet var lblTrainingTitle: UILabel!
    
    @IBOutlet var lblTrainingDescription: UILabel!
    
    @IBOutlet var btnStartTraining: UIButton!
    
    
    @IBOutlet var barBtnChat: UIBarButtonItem!
    
    var invwebView: WKWebView!
    
    
    private let invhandler = "handler"
    
    
    var zip:String!
    
    
    var appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
    
    var notificationstoview:Int = 0
    
    
    var invRequest:URLRequest?
   // var routeStop: RouteStop?{
   //     didSet {
   //         refreshRouteStopSelected()
    //    }
    //}
    
    
    //@IBOutlet var cvSales: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        zip = ""
        
        //setupWebView()
        
        // Do any additional setup after loading the view.
        //cvSales.delegate = self
        //cvSales.dataSource = self
        cvPhotos.delegate = self
        cvPhotos.dataSource = self
       // tabbar.delegate = self
        
        viewToday.delegate = self
        viewTimePunch.delegate = self
        viewRoutes.delegate = self
        viewModalWeb.delegate = self
        //hrempid = appDelegate.hrEmpId ?? ""
        officeCode = appDelegate.office
        
        
        appDelegate.viewDash = self
        
        //let obd =
        
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.tapPhotoRatio (_:)))
        self.viewPhotoRatio.addGestureRecognizer(gesture)
        
        let gestureot = UITapGestureRecognizer(target: self, action:  #selector (self.tapOnTime (_:)))
        self.viewOntime.addGestureRecognizer(gestureot)
        
        let gestureFinisher = UITapGestureRecognizer(target: self, action:  #selector (self.tapFinisher (_:)))
        self.viewFinisher.addGestureRecognizer(gestureFinisher)
        
        
        let gestureCompletion = UITapGestureRecognizer(target: self, action:  #selector (self.tapCompletion (_:)))
        self.viewCompletin.addGestureRecognizer(gestureCompletion)
        
        
        let gestureReviews = UITapGestureRecognizer(target: self, action:  #selector (self.tapReviews (_:)))
        self.viewReviews.addGestureRecognizer(gestureReviews)
        
        let gestureProactiveAdds = UITapGestureRecognizer(target: self, action:  #selector (self.tapProactiveAdds (_:)))
        self.viewProactiveAdds.addGestureRecognizer(gestureProactiveAdds)
       
        let gestureThiryOnePlus = UITapGestureRecognizer(target: self, action:  #selector (self.tapDailyRetention (_:)))
        self.viewThiryOnePlus.addGestureRecognizer(gestureThiryOnePlus)
        
        let gestureRolling = UITapGestureRecognizer(target: self, action:  #selector (self.tapDailyRetention (_:)))
        self.viewRolling.addGestureRecognizer(gestureRolling)
        
        
        //cvPhotos.reloadData()
        Task.detached{
            await self.loadPhotos()
            await self.loadStats()
            await self.loadHomeGPS()
            await self.loadProactiveList()
            await self.loadCancelList()
            await self.checkProducts()
        }
        splitViewController?.show(.primary)
        fastCommCheck()
        updateClockIn(punch: "", isIn: false, checklocal: true)
       // fastcommTimeCheck()
        
        sendFilesToServer()
        
        _ = Timer.scheduledTimer(timeInterval: 500.0, target: self, selector: #selector(self.sendFilesToServer), userInfo: nil, repeats: true)

        _ = Timer.scheduledTimer(timeInterval: 3600.0, target: self, selector: #selector(self.fetchStats), userInfo: nil, repeats: true)
        
        _ = Timer.scheduledTimer(timeInterval: 120.0, target: self, selector: #selector(self.fastCommCheck), userInfo: nil, repeats: true)
               
        _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.sendGpsToServer), userInfo: nil, repeats: true)
        
        
        _ = Timer.scheduledTimer(timeInterval: 1800.0, target: self, selector: #selector(self.backgroundHomeSaleCheck), userInfo: nil, repeats: true)

        
        Utilities.delay(bySeconds: 9.0, dispatchLevel: .main){
            self.setupWebView()
        }
        
        
       // updateChatNotificationBubble()
    }
    
    
    func checkProducts() async {
        
        do{
            let o = officeCode ?? "ME"
            _ = try await DataUtilities.checkAndDownloadProductsFileAsync(officeCode: o)
        }catch{
            print(error)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //tabbar.selectedItem = tabbar.items![0]
    }
    
    
    
    @objc func updateChatNotificationBubble(){
        
        notificationstoview = notificationstoview + 1
        
        
        if notificationstoview > 0{
            barBtnChat.setBadge(text: notificationstoview.toString())
        }else{
            barBtnChat.removeBadge()
        }
        
        
        
        
    }
    
    
    
    
    func loadIsTerritorySteward() async{
        
      
        
        
        
    }
    
    @objc func sendGpsToServer(){
        Task.detached{
            _ = await JsonFetcher.sendGpsDataToServer(hrEmpId: self.appDelegate.hrEmpId ?? "")
        }
    }

    
    @objc func sendFilesToServer()
    {
        Task.detached{
            do{
                
                _ = try await JsonFetcher.SendPostingResultsAsync(hrEmpId: self.appDelegate.hrEmpId ?? "")
                //_ = try await JsonFetcher.SendGPSAsync(hrEmpId: self.hrempid)
                
            } catch {
                print(error)
            }
            
        }
    }
    
    @objc func fetchRoute()
    {

    }
    @objc func fetchStats()
    {
        Task.detached{
                           
            await self.loadStats()
                
        }
    }
    @IBAction func btnMyRoutesClick(_ sender: Any) {
        performSegue(withIdentifier: "showRoutes", sender: nil)
        splitViewController?.hide(.primary)
        
    }
    
    @objc func fetchNewProactive(){
        Task.detached{
            
           
                 await self.fetchNewProactive()
            
            
            
        }
        
        
        
    }
    
    func fetchNewProactiveList() async {
        do{
            let pl = [ProactiveAccount]()
            proactiveList =  try await JsonFetcher.fetchProactiveRetentionJson(hrEmpId: appDelegate.hrEmpId ?? "") ?? pl
        } catch {
           print(error)
        }
    }
    func loadProactiveList() async{
        

            
            do{
                proactiveList = try await DataUtilities.getProactiveRetentionList(hrempid: appDelegate.hrEmpId ?? "", refreshNow: false)
            }catch{
                print(error)
            }
            
        
    }
    func loadCancelList() async{
        

            
            do{
                cancelList = try await DataUtilities.getRecentCancelList(hrempid: appDelegate.hrEmpId ?? "", refreshNow: false)
            }catch{
                print(error)
            }
            
        
    }
    
    func loadHomeGPS() async{
       
            
            do{
              
                let h = try await DataUtilities.getHomeGps(hrempid: appDelegate.hrEmpId ?? "")
                sphome = h
                
                
            } catch {
                
                print(error)
                
            }
            
            
       
    }
    
    
    func loadStats() async{
        
        
   
            
            do {
                
                let stats = try await JsonFetcher.fetchDashStatsJson(hrEmpId: appDelegate.hrEmpId ?? "")
                
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
                    lblSalesYTDCount.text = "Sales: " + stats.serviceprostats.salesYtdcount.toString()
                    lblSalesMTD.text = stats.serviceprostats.salesMtdpay.toMoneyString()
                    lblSalesMTDCount.text = "Sales: " + stats.serviceprostats.salesMtdcount.toString()
                    lblRankMTD.text = "Rank: " + stats.serviceprostats.salesMtdrank.toString()
                    lblRankYTD.text = "Rank: " + stats.serviceprostats.salesYtdrank.toString()
                    lblSalesAKCount.text = "Active Accounts: " + stats.serviceprostats.salesActiveAccount.toString()
                    
                    
                    let ak = stats.serviceprostats.salesActiveAccount
                        
                    if ak < 16{
                        lblSalesAK.text = "15 Sales = $300"
                    }else if ak < 31{
                        lblSalesAK.text = "30 Sales = $300"
                    }else if ak < 46{
                        lblSalesAK.text = "45 Sales = $600"
                    }else if ak < 61{
                        lblSalesAK.text = "60 Sales = $1000"
                    }else if ak < 76{
                        lblSalesAK.text = "75 Sales = $1500"
                    }else{
                        lblSalesAK.text = "100 Sales = Cruise"
                    }
                        
                    lblTicketsEarned.text = "Tickets Earned: " + stats.serviceprostats.photoLottoTickets.toString()
                    lblLottoPot.text = "Lotto Pot: " + stats.serviceprostats.photoLottoPot.toMoneyString()
                    lblLottoRange.text = stats.serviceprostats.photoLottoRange
                    
                    
                    
                }
                
                // Update collection view content
                //self.cvPhotos.reloadData()
                
                //HUD.hide(true)
                //self.view.hideToastActivity()
                
            } catch {
                print("Request failed with error: \(error)")
            }
            
   
        
        
        
        
        
        
    }
    
    func loadPhotos() async{
        
        
        //self.view.makeToastActivity(.center)
        
        
        
        
  
        do{
            
     
                photoList = try await JsonFetcher.fetchExcelentPhotosAsync(hrempid: "")
                
                // Update collection view content
                self.cvPhotos.reloadData()
                
                //HUD.hide(true)
                self.view.hideToastActivity()
                

        }catch{
            print(error)
            self.view.hideToastActivity()
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
            destinationController.hrEmpId = appDelegate.hrEmpId ?? ""
          
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
                destinationController.hrempid = appDelegate.hrEmpId ?? ""
   
            
        }
        
        if segue.identifier == "showMap"{
            
            
            let dc = segue.destination as! viewMap
            dc.mapStops = mapStops
            dc.homegps = sphome
            dc.proactivList = proactiveList
            dc.cancelList = cancelList
            
        }

        
        
       }
    
    
       

    @IBAction func ChatClicked(){
        notificationstoview = 0
        barBtnChat.removeBadge()
        let hrempid = appDelegate.hrEmpId ?? ""
        tabUrl = "https://kpwebapi2.bulwarkapp.com/chat?hrempid=" + hrempid
        useCookieInWeb = true
        print(tabUrl!)
        performSegue(withIdentifier: "showWeb", sender: nil)
       
    }
    
    @IBAction func btnIsExtended(_ sender: Any) {
        let hrempid = appDelegate.hrEmpId ?? ""
        tabUrl = "https://dashboard.bulwarkapp.com/mgrapp2/isextendeddaysoff2.aspx?h=" + hrempid
        useCookieInWeb = false
        performSegue(withIdentifier: "showWeb", sender: nil)
        
        
    }
    
    

    
    
    
    @IBAction func btnTabMap(_ sender: Any) {
        
        performSegue(withIdentifier: "showMap", sender: nil)
        
        
    }
    
    
    
    
    
    
    
    @IBAction func myPhotosClick(_ sender: Any) {
        
        performSegue(withIdentifier: "showMyPhotos", sender: nil)   
    }
    
    @IBAction func btnSalesClick(_ sender: Any) {
        
        //tabUrl = "https://twreportcore.bulwarkapp.com/dashboardsharedreports/salesstats?ipad=yes&h=" + hrempid
        //useCookieInWeb = false
        performSegue(withIdentifier: "showSales", sender: nil)
        
        
    }
    
    @objc func tapPhotoRatio(_ sender:UITapGestureRecognizer){
        // do other task
        let hrempid = appDelegate.hrEmpId ?? ""
        tabUrl = "https://servicesnapshot.bulwarkapp.com?&hrempid=" + hrempid
        useCookieInWeb = false
        performSegue(withIdentifier: "showWeb", sender: nil)
        
    }
    @objc func tapOnTime(_ sender:UITapGestureRecognizer){
        // do other task
        let hrempid = appDelegate.hrEmpId ?? ""
        tabUrl = "https://twreportcore.bulwarkapp.com/dashboardsharedreports/ontime?ipad=yes&h=" + hrempid
        useCookieInWeb = true
        performSegue(withIdentifier: "showWeb", sender: nil)
        
    }
    @objc func tapFinisher(_ sender:UITapGestureRecognizer){
        // do other task
        let hrempid = appDelegate.hrEmpId ?? ""
        tabUrl = "https://twreportcore.bulwarkapp.com/dashboardsharedreports/finisherRatio?ipad=yes&h=" + hrempid
        useCookieInWeb = false
        performSegue(withIdentifier: "showWeb", sender: nil)
        
    }
    
    @IBAction func btnFastCommDetails(_ sender: Any) {
        let hrempid = appDelegate.hrEmpId ?? ""
        tabUrl = "https://twreportcore.bulwarkapp.com/dashboardsharedreports/fastcommuse?ipad=yes&h=" + hrempid
        useCookieInWeb = false
        performSegue(withIdentifier: "showWeb", sender: nil)
           
    }
    
    @objc func tapCompletion(_ sender:UITapGestureRecognizer){
        // do other task
        let hrempid = appDelegate.hrEmpId ?? ""
        tabUrl = "https://twreportcore.bulwarkapp.com/dashboardsharedreports/completionrate?ipad=yes&h=" + hrempid
        useCookieInWeb = false
        performSegue(withIdentifier: "showWeb", sender: nil)
        
    }
    
    @objc func tapReviews(_ sender:UITapGestureRecognizer){
        // do other task
        let hrempid = appDelegate.hrEmpId ?? ""
        tabUrl = "https://twreportcore.bulwarkapp.com/dashboardsharedreports/TechReviews?ipad=yes&hideComp=yes&h=" + hrempid
        useCookieInWeb = false
        performSegue(withIdentifier: "showWeb", sender: nil)
        
    }
    
    
    @objc func tapProactiveAdds(_ sender:UITapGestureRecognizer){
        // do other task
        let hrempid = appDelegate.hrEmpId ?? ""
        tabUrl = "https://twreportcore.bulwarkapp.com/dashboardsharedreports/proactiveusage?ipad=yes&h=" + hrempid
        useCookieInWeb = false
        performSegue(withIdentifier: "showWeb", sender: nil)
        
    }
    
    /****/
    
    
    @objc func tapDailyRetention(_ sender:UITapGestureRecognizer){
        // do other task
        let hrempid = appDelegate.hrEmpId ?? ""
        tabUrl = "https://twreportcore.bulwarkapp.com/dashboardsharedreports/DailyRetention?ipad=yes&h=" + hrempid
        useCookieInWeb = false
        performSegue(withIdentifier: "showWeb", sender: nil)
        
    }
    
    
    @IBAction func btnReports(_ sender: Any) {
        
        //showRetentionList
        
        
        let customView = self.storyboard?.instantiateViewController(withIdentifier: "viewRetentionLists") as? viewRetentionList
        
        customView?.hrempid = appDelegate.hrEmpId ?? "";
        customView?.plist = proactiveList
        
        //customView.istoday = 1;

        
        customView?.modalTransitionStyle = .coverVertical
        customView?.modalPresentationStyle = .pageSheet
        

        
        self.present(customView!,animated:true, completion:nil)
        
        
        
      //  performSegue(withIdentifier: "showRetentionList", sender: nil)
        
        
        
    }
    
    @IBAction func btnMyPay(_ sender: Any) {
        
        
        
        
        let alert = UIAlertController(title: "My Pay", message: "Please Select an Option", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Pay Details", style: .default, handler: { (_) in
                    self.tabUrl = "https://kpwebapi.bulwarkapp.com/payrollreports/employee?apikey=aeb9ce4f-f8af-4ced-a4b3-683b6d29864d&hrempid=" + self.appDelegate.hrEmpId
                    self.useCookieInWeb = true
                    print(self.tabUrl!)
                    self.performSegue(withIdentifier: "showWeb", sender: nil)
                }))

        alert.addAction(UIAlertAction(title: "24 Month Compare", style: .default, handler: { [self] (_) in
            tabUrl = "https://twreportcore.bulwarkapp.com/dashboardsharedreports/TwentyFourMonth?ipad=yes&h=" + appDelegate.hrEmpId
                    useCookieInWeb = false
                    performSegue(withIdentifier: "showWeb", sender: nil)
                }))

                
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
                    print("User click Dismiss button")
                }))

        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view //to set the source of your alert
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // you can set this as per your requirement.
            popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
        }
        
        
                self.present(alert, animated: true, completion: {
                    print("completion block")
                })
        
        
        
        
        
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
        
        let hrempid = appDelegate.hrEmpId ?? ""
        tabUrl = "https://servicesnapshot.bulwarkapp.com?&hrempid=" + hrempid
        useCookieInWeb = false
        performSegue(withIdentifier: "showWeb", sender: nil)
        
        
        
        
        //fbf test
        
        
        //viewFBFSearch* customView = [[self storyboard] instantiateViewControllerWithIdentifier:@"viewFBFSearch"];
       /*
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
        
        */
        
        
        
    }
    
    @IBAction func btnClockIn(_ sender: Any) {
        
        //viewFBFSearch* customView = [[self storyboard] instantiateViewControllerWithIdentifier:@"viewFBFSearch"];
       /*
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
        
        */
        let hrempid = appDelegate.hrEmpId ?? ""
        let modalViewController = storyboard?.instantiateViewController(withIdentifier: "viewTimePunch") as! viewTimePunch
        
        modalViewController.hrempid = hrempid
        
           modalViewController.modalPresentationStyle = .formSheet
           modalViewController.modalTransitionStyle = .crossDissolve // this will look more natural for this situation
           self.present(modalViewController, animated: true, completion: nil)
        
        
    }
    

    func updateClockIn(punch:String, isIn: Bool, checklocal:Bool){
        
        var isInT = isIn
        var pt = punch
        if checklocal == true{
            
            let t = DataUtilities.getLastTimePunch()
            let st = Calendar.current.startOfDay(in: 0) ?? Date(timeIntervalSince1970: 0)
            isInT = t.isIn
            
            if t.isIn && t.punchTime > st{
              let dateFormatter = DateFormatter()
                
                dateFormatter.dateFormat = "h:mm a"
                 
                pt = dateFormatter.string(from: t.punchTime)
                
                
            }else if t.isIn{
                //didnt clock out
                isInT = false
            }else{
                //is out
                
            }
            
            
        }
            
        
        if isInT {
            
            let l = "In: " + pt
            //btnClockIn.titleLabel?.text = "Clock Out"
            btnClockIn.setTitle("Clock Out", for: .focused)
            btnClockIn.setTitle("Clock Out", for: .selected)
            btnClockIn.setTitle("Clock Out", for: .normal)
            btnClockIn.setTitle("Clock Out", for: .disabled)
            
            lblClockIn.text = l
            
        }else{
            
            btnClockIn.setTitle("Clock In", for: .focused)
            btnClockIn.setTitle("Clock In", for: .selected)
            btnClockIn.setTitle("Clock In", for: .normal)
            btnClockIn.setTitle("Clock In", for: .disabled)
            
            lblClockIn.text = ""
            //btnClockIn.tintColor = .red
            
            
        }
        
        
        
    }
    
    
    @IBAction func btnNewSale(_ sender: Any) {
        
        performSegue(withIdentifier: "showAddSales", sender: nil)
        
        
        
    }
    
    
    @IBAction func btnFastCommSubmit(_ sender: Any) {
        
        Task{
            let hrempid = appDelegate.hrEmpId ?? ""
           await fastCommSubmit(hrempid:hrempid)
        }
    }
    
     func fastCommSubmit(hrempid: String) async{
      
         let type = FastComm.checkFastCommTime()
       
         if FastComm.checkFcPressedAlready() {
           if type == 1 || type == 2{
               let dialogMessage =  UIAlertController(title: "Attention", message: "Fast Comm already pressed for today you cam opt in for fast comm tommorrow after 3pm", preferredStyle: .alert)

               self.present(dialogMessage, animated: true, completion: nil)
               return
           }else if type == 3{
               let dialogMessage =  UIAlertController(title: "Attention", message: "Fast Comm already pressed for tomorrow", preferredStyle: .alert)

               self.present(dialogMessage, animated: true, completion: nil)
               return
           }
           return
       }
       
        let ists = await DataUtilities.GetIsTS(hrempid: hrempid)
         let message = FastComm.getfastCommMessage(ists: ists)
       
       
        // Create Alert
         let fcalert =  UIAlertController(title: "Confirm", message: message, preferredStyle: .alert)

        // Create OK button with action handler
        let ok =  UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            self.btnFastComm.isEnabled = false;
            Task{
                
                do{
                    
                    var fctime = Date()
                    let t = Calendar.current.startOfDay(in: 1)
                    
                    let tomorrow4am = t?.addingTimeInterval(14400) ?? Date()
                    if type == 3{
                        fctime = tomorrow4am
                    }
                    let result = try await JsonFetcher.submitFastComm(hrempid: hrempid, fctime: fctime)
                    FastComm.SaveFCTime()
                    self.view.makeToast("Fast Comm Submitted", duration: 2.2, position: .top, title: "Success", image: UIImage(named: "GreenCheckmark.png"), style: Utilities.toastStyleCheckmark())
                    
                    Utilities.delay(bySeconds: 0.2,dispatchLevel: .main){
                        self.lblFastCommMTD.text = result.mtdPay.toMoneyString()
                        self.lblFastCommDue.text = result.ppPay.toMoneyString()
                    }
                   
                }catch{
                    print(error)
                    let dialogMessage2 =  UIAlertController(title: "Error", message: "Error Submitting Fast Comm try again in a few minutes", preferredStyle: .alert)

                    self.present(dialogMessage2, animated: true, completion: nil)
                }
            }
         
            
        })

        // Create Cancel button with action handlder
        let cancel =  UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }

        //Add OK and Cancel button to an Alert object
         fcalert.addAction(ok)
         fcalert.addAction(cancel)

        // Present alert message to user
         self.present(fcalert, animated: true, completion: nil)
        
        
        
        
        
    }
    
    
    @objc func fastCommCheck(){
        Utilities.delay(bySeconds: 0.1, dispatchLevel: .background){
            let fcClicked = FastComm.checkFcPressedAlready()
            Utilities.delay(bySeconds: 0.1,dispatchLevel: .main){
                
            if !fcClicked {
                    
                self.btnFastComm.isEnabled = true
            }else{
                self.btnFastComm.isEnabled = false
            }
                    
                Task{
                    let hrempid = self.appDelegate.hrEmpId ?? ""
                    let lbl = await FastComm.fastcommBtnLabel(hrempid: hrempid)
                    self.btnFastComm.setTitle(lbl, for: .disabled)
                    self.btnFastComm.setTitle(lbl, for: .normal)
                    self.btnFastComm.setTitle(lbl, for: .selected)
                    self.btnFastComm.setTitle(lbl, for: .focused)
                }
                
                
                
                }
            }
        }
    
    
    
    
    @IBAction func btnTrainingClick(_ sender: Any) {
        let hrempid = appDelegate.hrEmpId ?? ""
        tabUrl = "https://fbf.bulwarkapp.com/gopro/VideoPlayQuestions.aspx?ipad=yes&h=" + hrempid + "&vid=" + ttvid.toString()
        if ttvid == 0{
            tabUrl = "https://twreportcore.bulwarkapp.com/dashboardsharedreports/SalesTrainingFiles?ipad=yes&h=" + hrempid
        }
        
        
        useCookieInWeb = false
        performSegue(withIdentifier: "showWeb", sender: nil)
        
    }
    
    
    
    @IBAction func showMorwActionSheet(_ sender: UIBarButtonItem) {
      let alertController = UIAlertController(title: nil, message: "Alert message.", preferredStyle: .actionSheet)

      let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { (alert: UIAlertAction!) -> Void in
        //  Do some action here.
          self.performSegue(withIdentifier: "showSettings", sender: nil)
      })

        settingsAction.setValue(UIImage(systemName: "gearshape"), forKey: "image")
        
        let gateAction = UIAlertAction(title: "Gate Codes", style: .default, handler: { [self] (alert: UIAlertAction!) -> Void in
            
            
        //  Do some destructive action here.
            
            
            showGateCodes()
            

            
            
            
      })

        gateAction.setValue(UIImage(systemName: "lock"), forKey: "image")
        
        
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
        //  Do something here upon cancellation.
      })

      alertController.addAction(settingsAction)
      alertController.addAction(gateAction)
      alertController.addAction(cancelAction)
      
      if let popoverController = alertController.popoverPresentationController {
        popoverController.barButtonItem = sender
      }

      self.present(alertController, animated: true, completion: nil)
    }
    
    func showGateCodes(){
        let h = appDelegate.hrEmpId ?? ""
        let lat = appDelegate.lat ?? ""
        let lon = appDelegate.lon ?? ""
        
       tabUrl = "https://ipadapp.bulwarkapp.com/hh/retention/rptgatecodes.aspx?hr_emp_id=" + h + "&lat=" + lat + "&lon=" + lon
        
        useCookieInWeb = false
        performSegue(withIdentifier: "showWeb", sender: nil)
    }
    
   
    

    
    
    func reverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: latitude, longitude: longitude)
            geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    print("Failed to retrieve address")
                    return
                }
                
                if let placemarks = placemarks, let placemark = placemarks.first {
                    print(placemark.postalCode ?? "")
                    self.zip = placemark.postalCode ?? ""
                    
                    let zc = placemark.postalCode ?? ""
                    
                    Task.detached {
                        if zc.count > 3{
                            var check = false
                            let h = await self.appDelegate.hrEmpId ?? ""
                            if h.count > 3{
                                
                            
                            do{
                                
                                let zipresp = try await JsonFetcher.checkLastZipHomeSales(zipCode: zc, hrEmpId: h)
                                
                                check = zipresp.check
                                
                                
                                
                                
                                
                            }catch{
                                print(error)
                            }
                            
                            if check {
                                
                                await self.checkForHomeSales(zipCode: zc)
                                
                            }
                        }
                        }
                    }
                
                    
                    
                    
                }
                else
                {
                    print("No Matching Address Found")
                }
            })
        }
    
    
    
    func injectjs()-> String{
        
        
        if let filepath = Bundle.main.path(forResource: "ajaxHandler", ofType: "js") {
            do {
                let contents = try String(contentsOfFile: filepath)
                print(contents)
                return contents
            } catch {
                // contents could not be loaded
            }
        } else {
            // example.txt not found!
        }
        
        
        let str = "var open = XMLHttpRequest.prototype.open; XMLHttpRequest.prototype.open = function() { this.addEventListener(\"load\", function() {\n var message = {\"status\" : this.status, \"responseURL\" : this.responseURL };\n webkit.messageHandlers.test.postMessage(message); }); \n open.apply(this, arguments); \n};"
        
        return str
        
        
    }
    
    
    func checkForHomeSales(zipCode:String){
        
        
        //var lat1
        //var bbox1 =
        
        //let urlstr = "https://www.trulia.com/sold/85297_zip/33.25069,33.33843,-111.77237,-111.7183_xy/14_zm/"
        
        let urlstr = "https://www.trulia.com/sold/" + zipCode + "_zip/"
        let url = URL(string: urlstr)!
        self.invwebView.load(URLRequest(url: url))
        

        
        
    }
    
    @objc func backgroundHomeSaleCheck(){
        
        
        Utilities.delay(bySeconds: 1.2, dispatchLevel: .background){
            let clat = Double(self.appDelegate.lat) ?? 0
            let clon = Double(self.appDelegate.lon) ?? 0
            
            self.reverseGeocoding(latitude: clat, longitude: clon)
        }
        
    }
    
    func setupWebView(){
        

        
        
        
        
        let config = WKWebViewConfiguration()
        let js = injectjs()
        
        
        
        
        let userScript = WKUserScript(source: js, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        
        let userController:WKUserContentController = WKUserContentController()
        userController.addUserScript(userScript)
        userController.add(self, name:"truliaHandler")
        config.userContentController = userController;
        
        let frm:CGRect = CGRect(x: 0, y: 0, width: 1920, height: 1080)

        invwebView = WKWebView(frame:  frm, configuration: config)
        
                invwebView.navigationDelegate = self
        invwebView.uiDelegate = self
        //tmpview.addSubview(invwebView)
       
        let clat = Double(appDelegate.lat) ?? 0
        let clon = Double(appDelegate.lon) ?? 0
        
       reverseGeocoding(latitude: clat, longitude: clon)
        
    }
    
    
}

extension viewDashboard: WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
      if message.name == "truliaHandler", let messageBody = message.body as? String {
      //print(message.name)
          
          let mb = messageBody
          
          print(mb.count)
          
          
          do{
              let hs = try HomeSalesList(mb)
              
              print("hscount: " + (hs.data?.searchResultMap?.homes?.count.toString() ?? "0"))
              
              let count = hs.data?.searchResultMap?.homes?.count ?? 0
              
              if count > 1 {
                  
                  var recenthomesales = [RecentHomeSold]()
                  
                  if let homes = hs.data?.searchResultMap?.homes {
                      
                      for h in homes {
                          
                          var zid = ""
                          var salePrice = ""
                          var address = ""
                          var city = ""
                          var state = ""
                          var fulladdress = ""
                          
                          var zip = ""
                          var soldon = ""
                          var lat = 0.0
                          var lon = 0.0
                          var sqft = ""
                          var lotsize = ""
                          
                          if let loc = h.location {
                              if let z = loc.zipCode{
                                  zip = z
                              }
                              if let coord = loc.coordinates{
                                  if let latitude = coord.latitude{
                                      lat = latitude
                                  }
                                  if let longitude = coord.longitude{
                                      lon = longitude
                                  }
                                  
                              }
                              
                              if let addr = loc.partialLocation {
                                  address = addr
                              }
                              if let cty = loc.city{
                                  city = cty
                              }
                              if let fa = loc.fullLocation{
                                  fulladdress = fa
                              }
                              
                              if let st = loc.stateCode{
                                  state = st
                              }
                              
                          }
                          
                          if let track = h.tracking{
                              
                              for t in track {
                                  
                                  if let k = t.key {
                                      
                                      if k == "zPID" {
                                              if let v = t.value{
                                                  zid = v
                                              }
                                          }
                                      
                                      
                                      
                                      
                                            
                                  }
                                  
                              }
                               
                              
                          }
                          
                          
                          if let tag = h.tags{
                              
                              for t in tag {
                                  if let l = t.level{
                                      if l == "NORMAL"{
                                          soldon = t.formattedName ?? "1/1/1970"
                                      }
                                      
                                      
                                      
                                  }
                                  
                                  
                              }
                              
                              
                              
                          }
                          
                          
                          if let price = h.price{
                              if let fp = price.formattedPrice{
                                  salePrice = fp
                              }
                              
                              
                          }
                          
                          
                          if let fs = h.floorSpace{
                              if let fd = fs.formattedDimension{
                                  sqft = fd
                              }
                              
                          }
                          
                          
                          if let ls = h.lotSize{
                              if let fd = ls.formattedDimension{
                                  lotsize = fd
                                  
                              }
                                    
                          }
                          
                          
                          
                          
                          
                          
                          
                         print(zid, fulladdress, soldon, salePrice, zip)
                          
                          let hsv = RecentHomeSold(zid: zid, salePrice: salePrice, address: address, city: city, state: state, zip: zip, soldon: soldon, lat: lat, lon: lon, sqft: sqft, lotsize: lotsize, fullAddress: fulladdress)
                          recenthomesales.append(hsv)
                          
                          
                          
                          
                          
                      }
                  }
                  
                  
                  if recenthomesales.count > 0{
                      
                      Task{
                          
                          do{
                              
                              let hrem = self.appDelegate.hrEmpId ?? ""
                              if hrem.count > 3{
                                  _ = try await JsonFetcher.postHomeSales(hrEmpId: hrem, homeData: recenthomesales)
                              }
                              
                              
                          }catch{
                              print(error)
                          }
                          
                      }
                      
                      
                  }
                  
                  
              }
              
            
              
              
          }catch{
              print(error)
          }
          
      }
  }
}

extension viewDashboard:StopSelectionDelegate{
    func loadTraining(source: Int, title: String, tid: Int, description: String, trainingProgram: String) {
        btnStartTraining.isHidden = false
        lblTrainingType.text = trainingProgram
        lblTrainingTitle.text = title
        lblTrainingDescription.text = description
        ttvid = tid
        
        if tid == 0{
            btnStartTraining.setTitle("View Sales Training", for: .focused)
            btnStartTraining.setTitle("View Sales Training", for: .disabled)
            btnStartTraining.setTitle("View Sales Training", for: .normal)
            btnStartTraining.setTitle("View Sales Training", for: .selected)
            btnStartTraining.tintColor = .purple
        }else{
            btnStartTraining.setTitle("Start Training", for: .focused)
            btnStartTraining.setTitle("Start Training", for: .disabled)
            btnStartTraining.setTitle("Start Training", for: .normal)
            btnStartTraining.setTitle("Start Training", for: .selected)
            btnStartTraining.tintColor = .purple
        }
            
        
        
    }
    
    
    func routeLoaded(ms: [MapStop], routeNotes: String, routeprogress: String) {
        mapStops = ms
        txtRouteNotes.text = routeNotes
        lblRouteProgress.text = routeprogress
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




extension viewDashboard:TimePunchDelegate{
    func TimePunchSaved(timePunch: String, isIn: Bool) {
        updateClockIn(punch: timePunch, isIn: isIn, checklocal: false)
    }
    
    
}

extension viewDashboard:RouteChangedDelegate{
    func trainingCompleted() {
        lblTrainingTitle.text = "Training Complete"
        lblTrainingDescription.text = ""
        btnStartTraining.isHidden = true
    }
    
    func routeChanged() {
        splitViewController?.show(.primary)
    }
}

extension viewDashboard:ModalWebDelegate{
    func routeChangedMW() {
        splitViewController?.show(.primary)
    }
    
        func trainingCompletedMW() {
            lblTrainingTitle.text = "Training Complete"
            lblTrainingDescription.text = ""
            btnStartTraining.isHidden = true
        }
        
        
        
    }

extension viewDashboard:WKNavigationDelegate, WKUIDelegate,  WKDownloadDelegate {
    func download(_ download: WKDownload, decideDestinationUsing response: URLResponse, suggestedFilename: String, completionHandler: @escaping (URL?) -> Void) {
        
      //  let urlstr = response.url?.absoluteString ?? ""
        
        
      //  if urlstr.contains("graph"){
            
            
      //      let c = ""
            
            
      //  }
        
        
        
    }
    

    

    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    
        
       
        
        /*
        
        invwebView.evaluateJavaScript("document.getElementById('__NEXT_DATA__').innerHTML") {(result, error) in
            guard error == nil else {
                // print(error!)
                return
            }
            
            if let json = result as? String {
                
                let newjson = json.replacingOccurrences(of: "\"", with: "'").replacingOccurrences(of: "\\", with: "").replacingOccurrences(of: "\",\"", with: "").replacingOccurrences(of: "'control',", with: "")
                
                print(newjson)
                
                
                
                
            }
            
            */
            // if let ir = invRequest{
            //     invwebView.load(ir)
            //     invRequest = nil
            
            // }
            
            
        //}
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
       
    }
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {

            
            
            completionHandler()
        
        }
    
    
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {

        
                completionHandler(nil)

    }
    
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {

            completionHandler(false)
            
        
        }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        
       // var urlstr = navigationAction.request.url?.absoluteString ?? ""
        
      //  if urlstr.contains("graph"){
            
            
       //     invRequest = navigationAction.request
            
     //   }
        
        
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
      //  var urlstr = navigationResponse.response.url?.absoluteString ?? ""
        
    //    if urlstr.contains("graph"){
            
            
     //       let c = ""
            
            
     //   }
        
        

        decisionHandler(.allow)
    }
}


