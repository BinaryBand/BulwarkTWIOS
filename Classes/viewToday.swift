//
//  viewToday.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 10/24/22.
//

import UIKit



protocol StopSelectionDelegate: AnyObject{
func stopSelected(selectedRouteStop: RouteStop)
func routeSelected()
    func routeLoaded(ms: [MapStop], routeNotes: String, routeprogress: String)
}


class viewToday: UIViewController, UITableViewDelegate,UITableViewDataSource, UITableViewDragDelegate  {
    
    
    @IBOutlet var btnNavigationLeft: UIBarButtonItem!
    var activityIndicator = UIActivityIndicatorView()

    var routeStopList: [RouteStop] = []
    var mapStops : [MapStop] = []
    var currentIndex = 0
    //var HUD: MBProgressHUD!
    var tabUrl:String!

    @IBOutlet var lblRouteTotal: UIBarButtonItem!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var btnAddToRoute: UIBarButtonItem!
    var refreshControl = UIRefreshControl()
    var isRefreshing:Bool = false
    
    var lastWid:Int = 0
    
    static var delegate: StopSelectionDelegate?
    
    

    @IBAction func btnEditPress(_ sender: Any) {
        
        
        tableView.dragInteractionEnabled = true
        
        
        
    }
    
    
    @IBAction func btnSelectRoute(_ sender: Any) {
        viewToday.delegate?.routeSelected()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


        //DataUtilities.saveCurrentRouteDate(dateStr: "2/1/2023")
        // lblRouteTotal.isEnabled = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.dragDelegate = self
        
        tableView.dragInteractionEnabled = false
        
//loadData()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        

     }

    
    override func viewWillAppear(_ animated: Bool) {
       
        super.viewWillAppear(animated)
        let ttl = DataUtilities.getRouteTitle()
        
        
        
        self.title = ttl
        //Utilities.delay(bySeconds: 2.0, dispatchLevel: .main){
           
        //}
        //tableView.setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.size.height), animated: true)
        //refreshControl.activityIn
        //refreshControl.beginRefreshing()
        startBarButtonIndicator()
        loadData()
            
        }
        
    func startBarButtonIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.color = .yellow
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setLeftBarButton(barButton, animated: true)
        activityIndicator.startAnimating()
    }

    func stopBarButtonIndicator() {
        activityIndicator.stopAnimating()
        navigationItem.setLeftBarButton(btnNavigationLeft, animated: true)
    }
    
     @objc func refresh(_ sender: AnyObject) {
         refreshControl.attributedTitle = NSAttributedString(string: "Loading Route Stops")
         //isRefreshing = true
        loadData()
     }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         currentIndex = indexPath.row
         
         let selectedStop = routeStopList[indexPath.row]
         viewToday.delegate?.stopSelected(selectedRouteStop: selectedStop)
         
         
         
         //performSegue(withIdentifier: "showWeb2", sender: self)
     }
    
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
            dragItem.localObject = routeStopList[indexPath.row]
            return [ dragItem ]
    }
    
     func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update the model
        let mover = routeStopList.remove(at: sourceIndexPath.row)
        routeStopList.insert(mover, at: destinationIndexPath.row)
    }


    var jsonDatastr = """
[{
    "serviceType": "",
    "timeBlock": "",
    "estArrival": "",
    "account": "",
    "name": "",
    "contacted": "",
    "redAlert": "",
    "blueAlert": "",
    "grid": "",
    "type": 2,
    "notes": "this is some notes and maybe some more text to fill out the rest of this"
},{
    "serviceType": "",
    "timeBlock": "",
    "estArrival": "",
    "account": "",
    "name": "",
    "contacted": "",
    "redAlert": "",
    "blueAlert": "",
    "grid": "",
    "type": 4,
    "notes": ""
},{
    "serviceType": "TQT",
    "timeBlock": "12:00-3:00",
    "estArrival": "12:12 PM",
    "account": "145784",
    "name": "Test McTesterson",
    "contacted": "EML",
    "redAlert": "Call: 30 Min Prior",
    "blueAlert": "Some Notes",
    "grid": "VC 12-34",
    "type": 1,
    "notes": ""
}, {
    "serviceType": "TRNL",
    "timeBlock": "1:00-4:00",
    "estArrival": "12:43 PM",
    "account": "125663",
    "name": "jon Testingfield",
    "contacted": "TXT",
    "redAlert": "Text: 15 Min Prior",
    "blueAlert": "See Notes",
    "grid": "VC 12-36",
    "type": 1,
    "notes": ""
},{
    "serviceType": "TRNL",
    "timeBlock": "1:00-4:00",
    "estArrival": "12:43 PM",
    "account": "125663",
    "name": "mike Testingstein",
    "contacted": "Serviced",
    "redAlert": "Text: 15 Min Prior",
    "blueAlert": "See Notes",
    "grid": "VC 12-36",
    "type": 10,
    "notes": ""
},{
    "serviceType": "TRNL",
    "timeBlock": "1:00-4:00",
    "estArrival": "12:43 PM",
    "account": "124587",
    "name": "Bill Testineaux",
    "contacted": "Missed",
    "redAlert": "Text: 15 Min Prior",
    "blueAlert": "See Notes",
    "grid": "VC 11-22",
    "type": 11,
    "notes": ""
},{
    "serviceType": "MO",
    "timeBlock": "2:00-4:00",
    "estArrival": "2:33 PM",
    "account": "348745",
    "name": "Steve Testington",
    "contacted": "TT",
    "redAlert": "",
    "blueAlert": "See Notes",
    "grid": "VC 12-31",
    "type": 1,
    "notes": ""
}, {
    "serviceType": "",
    "timeBlock": "",
    "estArrival": "",
    "account": "",
    "name": "",
    "contacted": "",
    "redAlert": "",
    "blueAlert": "",
    "grid": "",
    "type": 3,
    "notes": ""
}, {
    "serviceType": "",
    "timeBlock": "",
    "estArrival": "",
    "account": "",
    "name": "",
    "contacted": "",
    "redAlert": "",
    "blueAlert": "",
    "grid": "",
    "type": 5,
    "notes": ""
},{
    "serviceType": "",
    "timeBlock": "",
    "estArrival": "",
    "account": "",
    "name": "",
    "contacted": "",
    "redAlert": "",
    "blueAlert": "",
    "grid": "",
    "type": 5,
    "notes": ""
},{
    "serviceType": "",
    "timeBlock": "",
    "estArrival": "",
    "account": "",
    "name": "",
    "contacted": "",
    "redAlert": "",
    "blueAlert": "",
    "grid": "",
    "type": 5,
    "notes": ""
},]
"""
    
    
    
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(routeStopList.count)
        
        return routeStopList.count
        
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //fastcomm border color 942193
        //is ext color 009193
         
        if(routeStopList[indexPath.row].type == 3){
            
               //fbf
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "FastCommCell", for: indexPath) as! FastCommCell

            return cell
        

        } else if(routeStopList[indexPath.row].type == 4){
           
            let cell = tableView.dequeueReusableCell(withIdentifier: "ISExtAMCell", for: indexPath) as! FastCommCell

            return cell
            
            
        } else if(routeStopList[indexPath.row].type == 5){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ISExtPMCell", for: indexPath) as! FastCommCell

            return cell
            
            
        } else if(routeStopList[indexPath.row].type == 2){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "hiddenCell", for: indexPath)
            
            //cell.txtNotes.text = routeStopList[indexPath.row].notes

            return cell
        } else if(routeStopList[indexPath.row].type == 1000){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RouteNotesCell", for: indexPath) as! RouteNotesCell
            
            cell.txtNotes.text = routeStopList[indexPath.row].notes

            return cell
        } else if(routeStopList[indexPath.row].type == 10){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RouteStopB", for: indexPath) as! RouteStopCell
            
            cell.lblName.text = routeStopList[indexPath.row].name
            cell.lblServiceType.text = routeStopList[indexPath.row].serviceType
            cell.lblTimeBlock.text = routeStopList[indexPath.row].timeBlock
            cell.lblAccount.text = routeStopList[indexPath.row].account
            cell.lblExtArrival.text = "Serviced"
            
                

            return cell
        }else if(routeStopList[indexPath.row].type == 11){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RouteStopM", for: indexPath) as! RouteStopCell
            
            cell.lblName.text = routeStopList[indexPath.row].name
            cell.lblServiceType.text = routeStopList[indexPath.row].serviceType
            cell.lblTimeBlock.text = routeStopList[indexPath.row].timeBlock
            cell.lblAccount.text = routeStopList[indexPath.row].account
            cell.lblExtArrival.text = "Missed"
            cell.lblExtArrival.textColor = UIColor.red
            
                

            return cell
        }else if(routeStopList[indexPath.row].type == 1){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RouteStopA", for: indexPath) as! RouteStopCell
            
            cell.lblName.text = routeStopList[indexPath.row].name
            cell.lblServiceType.text = routeStopList[indexPath.row].serviceType
            cell.lblTimeBlock.text = routeStopList[indexPath.row].timeBlock
            cell.lblAccount.text = routeStopList[indexPath.row].account
            cell.lblContacted.text = routeStopList[indexPath.row].contacted
            cell.lblRedAlert.text = routeStopList[indexPath.row].redAlert
            cell.lblBlueAlert.text = routeStopList[indexPath.row].blueAlert
            cell.lblExtArrival.text = routeStopList[indexPath.row].estArrival
            cell.lblTopBorder.backgroundColor = getColor(hex: routeStopList[indexPath.row].barcolor)
            
                

            return cell
        } else if routeStopList[indexPath.row].type == 20 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "hiddenCell", for: indexPath)
            return cell
        }else{
            
            //let rl = routeStopList[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RouteStopA", for: indexPath) as! RouteStopCell
            
            cell.lblName.text = routeStopList[indexPath.row].name
            cell.lblServiceType.text = routeStopList[indexPath.row].serviceType
            cell.lblTimeBlock.text = routeStopList[indexPath.row].timeBlock
            cell.lblAccount.text = routeStopList[indexPath.row].account
            cell.lblContacted.text = routeStopList[indexPath.row].contacted
            cell.lblRedAlert.text = routeStopList[indexPath.row].redAlert
            cell.lblBlueAlert.text = routeStopList[indexPath.row].blueAlert
            cell.lblExtArrival.text = routeStopList[indexPath.row].estArrival
            
            return cell
            
            
            
        }
        
        
        
        
        
    }
    


    
    func decodeData(jsonString: String){
           do{
               let jsonData = jsonString.data(using: .utf8)!
               let decoder = JSONDecoder()
               routeStopList = try decoder.decode([RouteStop].self, from: jsonData)
           } catch {
               print("Error info: \(error)")
               
           }
       }
    
    func loadData(){
        
        routeStopList = DataUtilities.getRouteStopListFromFile()
        tableView.reloadData()
        
        
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        //appDelegate.viewSched = self
       
        //HUD = MBProgressHUD(view: view)
        //view.addSubview(HUD)
        //HUD.hide(true)
        
        
        
 
        let h = appDelegate.hrEmpId ?? ""
        
        
       
        
        
        Task {
            do{
                
                let rdate = DataUtilities.getCurrentRouteDateString()
                
                
                routeStopList = try await JsonFetcher.fetchRouteStopsAsync(rdate: rdate, hrEmpId: h)
                self.tableView.reloadData()
                stopBarButtonIndicator()
                if refreshControl.isRefreshing {
                    refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
                    refreshControl.endRefreshing()
                }
                
                mapStops = [];
                
                var lastw = 0
                var cntttl = 0;
                var cntcomp = 0;
                var notes = "";
                
                for r in routeStopList {
                    if r.type == 2{
                        notes = r.notes
                    }
                    
                    if r.lat != 0{
                        let tstr = r.account + " " + r.name
                        let sstr = r.serviceType + " " + r.timeBlock
                        
                        var cid = 1
                        
                        if r.type == 10 {
                            cid = 2
                            cntcomp = cntcomp + 1;
                        }
                        if r.type == 11 {
                            cid = 3
                            cntcomp = cntcomp + 1;
                        }
                        
                        cntttl = cntttl + 1
                        
                        
                        let mp = MapStop(colorId:  cid, lat: r.lat, lon: r.lon, title: tstr, subtitle: sstr)
                        if lastw != r.workorder_id{
                            lastw = r.workorder_id
                            mapStops.append(mp)
                        }
                    }
                }
                
                let prg = cntcomp.toString() + "/" + cntttl.toString()
                viewToday.delegate?.routeLoaded(ms: mapStops, routeNotes: notes, routeprogress: prg)
                
                    
                
            }catch{
                
                self.view.makeToast("Error Loading Route", duration: 4.0, position: .top)
                
                stopBarButtonIndicator()
                if refreshControl.isRefreshing {
                    refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
                    refreshControl.endRefreshing()
                }
            }
        }
        
        /*
        if let url = URL(string: "https://ipadapp.bulwarkapp.com/getRouteByHRempidAndDate.ashx?date=6/08/2021&hr_emp_id=481217") {
            do {
                let contents = try String(contentsOf: url)
                print(contents)
                
                jsonDatastr = contents
     

                
            } catch {
                 print("contents could not be loaded")
            }
        } else {
             print("the URL was bad!")
        }
        
        
        
        
        
        
        
        decodeData(jsonString: jsonDatastr)
      //  lblRouteTotal.title = "Total: " + String(routeStopList.count)
        self.tableView.reloadData()
        
        */
        
    }
    
    //func getRouteCopy() -> [RouteStop]{
        
        
        
        
        
        
   // }
    
    
    @IBAction func btnAddAction(_ sender: Any) {
        
        
        let fcAction = UIAlertAction(title: "FastComm $5 Guaranteed",
                                          style: .default) { (action) in
         // Respond to user selection of the action
        }
        let isexttodayAction = UIAlertAction(title: "Add 6-9PM$50 Today",
                                          style: .default) { (action) in
         // Respond to user selection of the action
        }
        let isextamAction = UIAlertAction(title: "Add 7AM$50 Tomorrow",
                                          style: .default) { (action) in
         // Respond to user selection of the action
        }
        let isexttomorrowAction = UIAlertAction(title: "Add 6-9PM$50 Tomorrow",
                                          style: .default) { (action) in
         // Respond to user selection of the action
        }
        let lunchAction = UIAlertAction(title: "Add Lunch Break",
                  style: .default) { (action) in
         // Respond to user selection of the action
        }
        let breakAction = UIAlertAction(title: "Add General Break",
                  style: .default) { (action) in
         // Respond to user selection of the action
        }
        
        
        
        let alert = UIAlertController(title: "Add To Route",
                    message: "Add time for a break or pick up additional services with IS Extended Timeand Fast Comm",
                    preferredStyle: .actionSheet)
        alert.addAction(fcAction)
        
        alert.addAction(isexttodayAction)
        alert.addAction(isextamAction)
        alert.addAction(isexttomorrowAction)
        alert.addAction(lunchAction)
        alert.addAction(breakAction)
        

             
        // On iPad, action sheets must be presented from a popover.
        alert.popoverPresentationController?.barButtonItem = self.btnAddToRoute
             
        self.present(alert, animated: true) {
           // The alert was presented
        }
        
        
        
        
    }
    
    
    func getColor(hex: String) -> UIColor  {
           var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
           hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

           var rgb: UInt64 = 0

           var r: CGFloat = 0.0
           var g: CGFloat = 0.0
           var b: CGFloat = 0.0
           var a: CGFloat = 1.0

           let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return UIColor.blue }

           if length == 6 {
               r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
               g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
               b = CGFloat(rgb & 0x0000FF) / 255.0

           } else if length == 8 {
               r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
               g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
               b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
               a = CGFloat(rgb & 0x000000FF) / 255.0

           } else {
               return UIColor.blue
           }

            return UIColor(red: r, green: g, blue: b, alpha: a)
       }

    
    
    
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        
        if segue.identifier == "showWeb2" {
            if let indexPaths = self.tableView.indexPathForSelectedRow{
                let destinationController = segue.destination as! viewModalWeb
                destinationController.url = routeStopList[indexPaths.row].encodedurl

                tableView.deselectRow(at: indexPaths, animated: false)
            }
        }
        
        
    }
    */

}
