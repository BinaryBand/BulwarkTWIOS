//
//  viewTermiteBaitCheckResults.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 7/17/23.
//

import UIKit


class viewTermiteBaitCheckResults: UIViewController{
    
    
    var currentIndex = 0
    //var HUD: MBProgressHUD!
    
     var HrEmpId:String!
    var routeStop:RouteStop!
    var houseimage:UIImage?
    
     var baitStations = [StationCheck]()
    
    
    var additionalConditions:[TermiteCondition]?
    
    var ttlLiquidLF:Double?
    var homeLF:Double?
    var fpPoints:[[GpsPoint]?]?
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var printIcon: UIBarButtonItem!
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var acctLabel: UILabel!
    
    var appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
    
    
    var printManager: TWBlunoManager?
    var printDev: DFBlunoDevice?
    var printDevices: [AnyHashable]?
    var dontScan:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.reloadData()

        if let img = houseimage{
            imageView.image = img
            imageView.contentMode = .scaleAspectFit
        }
        
        
        printIcon.tintColor = .clear
        printIcon.isEnabled = false
        
        
        
        printManager = TWBlunoManager.sharedInstance()
        printManager?.delegate = self
        printDevices = []
        
        Utilities.delay(bySeconds: 0.2, dispatchLevel: .main){
            
            self.printManager?.scan()
            
        }
        
        self.title = "TBS Posting: " + routeStop.account
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool){
       dontScan = true
        printManager?.stop()
        printManager?.disconnect(to: printDev)
        
        super.viewWillDisappear(animated)
        
    }
    
    func showActivityIndicator(show: Bool) {
            if show {
                //HUD.show(true)
                self.view.makeToastActivity(.center)
            } else {
                self.view.hideToastActivity()
                //HUD.hide(true)
            }
    }

    @IBAction func btnPrintPressed(_ sender: Any) {
        
        let printstring = serviceTicketPrintData()
        
        let presult = sendStringToPrint(printstring)
        
        //printQR(urlstr: "https://www.google.com")
        
        if !presult{
            
            let alertController = UIAlertController(title: "Error Printing", message: "Check that the printer is turned on and connected", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
            
            
            present(alertController, animated: true)
            
            
            
        }else {
            
            
            
            
            
            
            
            
            
            
            
        }
        
    }
    
    
    @IBAction func btnSubmitResultsPressed(_ sender: Any) {
        
        
        saveResults(fromPrint: false)
    }
    
    func saveResults(fromPrint:Bool){
        
        
        let av = appDelegate.appBuild ?? "none"
        let obdDate = appDelegate.lastObdRead.toString(format: .usDateTime24WithSec) ?? "1/1/1900"
        
        let tc = appDelegate.obdTroubleCodes ?? ""
        let h = appDelegate.hrEmpId ?? "123456"
        let hlf = homeLF ?? 0
        let liquidlf = ttlLiquidLF ?? 0
        let base64 = houseimage?.jpegData(compressionQuality: 0.75)?.base64EncodedString() ?? ""
        
        let tsd = TBSStationCheckPost(HrEmpId: h, RollingKey: "", CustomerId: routeStop.customerId!, ServiceId: routeStop.serviceId!, AccountNumber: routeStop.account, Name: routeStop.name, Address: routeStop.address, ServiceType: routeStop.serviceType, Result: "Serviced", Lat: routeStop.lat, Lon: routeStop.lon, LinnearFeet: Int(hlf), WorkOrderId: routeStop.workorder_id, WorkOrderItemId: routeStop.workorderitem_id, ServiceStart: "8/3/2023 10:22 AM", ServiceEnd: "8/3/2023 11:10 AM", footPrint: fpPoints!, stations: baitStations, additionalConditions: additionalConditions!, footprintImageBase64: base64, liquidLF: liquidlf, liquidProduct: "Termidor HE")
        
        //let saveResults = DataUtilities.SavePostingResults(UrlToStave: pres.url, Lat: appDelegate.lat, Lon: appDelegate.lon, Vin: appDelegate.vin, Odometer: appDelegate.odo, OdoLastUpdated: obdDate, Rdate: rs.rdate, appversion: av, troubleCode: tc)
        Task{
            do{
                let res = try await JsonFetcher.postTermiteService(checkData: tsd)
            }catch{
                print(error)
            }
        }
        
        
        
    }
    
    func sendResults(){
        Task {
            do {
                
                
                let fetch = try await JsonFetcher.SendPostingResultsAsync(hrEmpId: appDelegate.hrEmpId)
                
                
                performSegue(withIdentifier: "unwindToDash", sender: self)
                
                
            }catch {print(error)}
            
        }
    
    
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
         
         let destinationController = segue.destination as! viewTBSBid
         destinationController.homeImg = houseimage
         destinationController.baitStations = baitStations
         destinationController.routeStop = routeStop
         destinationController.additionalConditions = additionalConditions
         destinationController.ttlLiquidLF = ttlLiquidLF
         destinationController.homeLF = homeLF
         
     }
     
    
}
extension viewTermiteBaitCheckResults : UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return baitStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //tbsResultCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tbsResultCell", for: indexPath) as! TermiteBaitResultCell
        
        let ttl = "Station " +  baitStations[indexPath.row].stationNumber.toString()
        let res = baitStations[indexPath.row].result
        let checkedatint = baitStations[indexPath.row].timeChecked
        
        let checkedat = Date(timeIntervalSince1970: checkedatint)
        let ct = checkedat.toString(format: .custom("hh:mm a"))
        
        cell.Title.text = ttl
        cell.Result.text = "Result: " + res
        cell.CheckedAt.text = "Checked At: " + (ct ?? "")
        
        return cell
        
        
        
    }
    
    
    
    
    
    
    
}

extension viewTermiteBaitCheckResults: TWBlunoDelegate{
    func printDidUpdateState(_ bleSupported: Bool) {
        if bleSupported {
            if !dontScan {
               // printManager?.scan()
            }
        }
    }
    
    func didDiscoverPrinter(_ dev: DFBlunoDevice!) {
        if printDev == nil {
            printDev = dev
            printManager?.connect(to: printDev)
        } else if dev == printDev {
            
            let ready1 = printDev?.bReadyToWrite ?? false
            
            if !ready1 {
                printManager?.connect(to: printDev)
            }
        } else {
            
            let ready1 = printDev?.bReadyToWrite ?? false
            
            if ready1 {
                printManager?.disconnect(to: printDev)
                printDev = nil
            }

            printManager?.connect(to: dev)
        }




        printManager?.stop()
    }
    
    func ready(toPrint dev: DFBlunoDevice!) {
        if !dontScan {
            printDev = dev
            printIcon.tintColor = .white
        }
        
    }
    
    func didDisconnectPrinter(_ dev: DFBlunoDevice!) {
        if !dontScan {
            printManager?.scan()
            printIcon.tintColor = .clear
        }
    }
    
    func didPrintData(_ dev: DFBlunoDevice!) {
        
    }
    
    func didReceiveDataP(_ data: Data!, device dev: DFBlunoDevice!) {
        
    }
    
    //printing serviceticket
    
    func sendStringToPrint(_ printStr: String) -> Bool{
        
        let escChar = String(UnicodeScalar(27)) //27 dec or 1B hex
        
        
        let lfChar = String(UnicodeScalar(10)) //linefeed 10 dec or 0A hex
        
        let s = printStr.replacingOccurrences(of: "<ESC>", with: escChar).replacingOccurrences(of: "<LF>", with: lfChar).replacingOccurrences(of: "&comma;", with: ",").trimmingCharacters(in: .whitespaces)
        
        let isReady = printDev?.bReadyToWrite ?? false
        
        if isReady {
            
            let wsp = escChar + "\n\n\r\n\r"
            let dw = wsp.data(using: .utf8)
            printManager?.writeData(toDevice: dw, device: printDev)
            Utilities.delay(bySeconds: 0.3){
                
                var i = 0
                while i < (s.count ) {
                    var er = 50


                    let ss = s.count

                    if (i + 50) >= ss {
                        er = s.count  - i
                    }

                    let start = s.index(s.startIndex, offsetBy: i)
                    let end = s.index(s.startIndex, offsetBy: i + er - 1)
                    let range = start...end
                    let cup = String(s[range])

                    let data = cup.data(using: .utf8)

                    self.printManager?.writeData(toDevice: data, device: self.printDev)


                    Thread.sleep(forTimeInterval: 0.1)

                    //[characters addObject:ichar];
                    i = i + 50
                }
                
                
                
                
            }
            
            
            return true
        }else{
            return false
        }
        
        
    }
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage! {
        let context = CIContext(options: nil)
        
            return context.createCGImage(inputImage, from: inputImage.extent)
       
    }
    
    func printQR(urlstr:String){
        let isReady = printDev?.bReadyToWrite ?? false
        
        if isReady {
            
            
            let img = UIImage(named: "shovel")!
            let ciImage = CIImage(image: img)
            let context = CIContext(options: nil)
            let cgimg = context.createCGImage(ciImage!, from: ciImage!.extent)
            
            
            let receipt = Receipt(.🖨️58(.ascii))
                <<~ .style(.initialize)
            <<< Image(cgimg!)
                <<~ .page(.printAndFeed(lines: 0))
                <<~ .style(.initialize)
            let data  = Data(receipt.data)
            
            self.printManager?.writeData(toDevice: data, device: self.printDev)
            
            let ustr = urlstr
            let storlen = ustr.count + 3
            /*
            byte store_pL = (byte) (store_len % 256);
            byte store_pH = (byte) (store_len / 256);


            // QR Code: Select the model
            //              Hex     1D      28      6B      04      00      31      41      n1(x32)     n2(x00) - size of model
            // set n1 [49 x31, model 1] [50 x32, model 2] [51 x33, micro qr code]
            // https://reference.epson-biz.com/modules/ref_escpos/index.php?content_id=140
            byte[] modelQR = {(byte)0x1d, (byte)0x28, (byte)0x6b, (byte)0x04, (byte)0x00, (byte)0x31, (byte)0x41, (byte)0x32, (byte)0x00};

            // QR Code: Set the size of module
            // Hex      1D      28      6B      03      00      31      43      n
            // n depends on the printer
            // https://reference.epson-biz.com/modules/ref_escpos/index.php?content_id=141
            byte[] sizeQR = {(byte)0x1d, (byte)0x28, (byte)0x6b, (byte)0x03, (byte)0x00, (byte)0x31, (byte)0x43, (byte)0x03};


            //          Hex     1D      28      6B      03      00      31      45      n
            // Set n for error correction [48 x30 -> 7%] [49 x31-> 15%] [50 x32 -> 25%] [51 x33 -> 30%]
            // https://reference.epson-biz.com/modules/ref_escpos/index.php?content_id=142
            byte[] errorQR = {(byte)0x1d, (byte)0x28, (byte)0x6b, (byte)0x03, (byte)0x00, (byte)0x31, (byte)0x45, (byte)0x31};


            // QR Code: Store the data in the symbol storage area
            // Hex      1D      28      6B      pL      pH      31      50      30      d1...dk
            // https://reference.epson-biz.com/modules/ref_escpos/index.php?content_id=143
            //                        1D          28          6B         pL          pH  cn(49->x31) fn(80->x50) m(48->x30) d1…dk
            byte[] storeQR = {(byte)0x1d, (byte)0x28, (byte)0x6b, store_pL, store_pH, (byte)0x31, (byte)0x50, (byte)0x30};


            // QR Code: Print the symbol data in the symbol storage area
            // Hex      1D      28      6B      03      00      31      51      m
            // https://reference.epson-biz.com/modules/ref_escpos/index.php?content_id=144
            byte[] printQR = {(byte)0x1d, (byte)0x28, (byte)0x6b, (byte)0x03, (byte)0x00, (byte)0x31, (byte)0x51, (byte)0x30};

            // flush() runs the print job and clears out the print buffer
            flush();

            // write() simply appends the data to the buffer
            write(modelQR);

            write(sizeQR);
            write(errorQR);
            write(storeQR);
            write(qrdata.getBytes());
            write(printQR);
            flush();
            
            */
            
            
            
            
            // let contentData = urlstr.data(using: .utf8)
               
            // Code type for QR code
           
            // Set dot size
            
             //UnicodeScalar(27)
             
            //var data:Data = Data([29, 40, 107, 4, 0, 49, 65, 50, 0] as [UInt8])
            //self.printManager?.writeData(toDevice: data, device: self.printDev)
            //Thread.sleep(forTimeInterval: 0.1)
            //  Select the model
            /*
            data = Data([29, 40, 107, 3, 0, 49, 67, 50] as [UInt8])
            self.printManager?.writeData(toDevice: data, device: self.printDev)
            Thread.sleep(forTimeInterval: 0.1)
            
            
            
            
            data = Data([29, 40, 107, 3, 0, 49, 69, 49] as [UInt8])
            self.printManager?.writeData(toDevice: data, device: self.printDev)
            Thread.sleep(forTimeInterval: 0.1)
           
            
            let total = contentData!.count + 3
            let pl = UInt8(total % 256)
            let ph = UInt8(total / 256)
            
            
            
            
            //  Store the data in the symbol storage area
            //data += ([29, 40, 107, pl, ph, 49, 80, 48] + contentData!)
            
            
            data = Data([29, 40, 107, pl, ph, 49, 80, 48] as [UInt8])
            self.printManager?.writeData(toDevice: data, device: self.printDev)
            Thread.sleep(forTimeInterval: 0.1)
            
            self.printManager?.writeData(toDevice: contentData, device: self.printDev)
            Thread.sleep(forTimeInterval: 0.1)
            
            // Print the symbol data in the symbol storage area
            data = Data([29, 40, 107, 3, 0, 49, 81, 0] as [UInt8])
            self.printManager?.writeData(toDevice: data, device: self.printDev)
            Thread.sleep(forTimeInterval: 0.1)
            //data += [29, 40, 107, 3, 0, 49, 81, 0]
            */
            //return data
            
            
            //let qr = QRCode(content: urlstr).assemblePrintableData(.🖨️58())
            //let qdata = Data(qr)
            //let q = QRCode(content: "https://www.apple.com")
             
            
            //let ddd = Data(q.assemblePrintableData(.🖨️58()))
            
            //self.printManager?.writeData(toDevice: ddd, device: self.printDev)
        }
    }
    
    
    func serviceTicketPrintData() ->String{
        

        
       
        
        var startDate = Utilities.CurrentDateString()

     
     
        var hr_emp_id = appDelegate.hrEmpId ?? "123456"
         
        var Invoice = routeStop.workorderitem_id
        var ServiceTypeCode = routeStop.serviceType
         var Result = "Serviced"
 
         var Comments = ""
        var CustName = routeStop.name

        
        let city = routeStop.city ?? "Gilbert"
        let state = routeStop.state ?? "AZ"
        let zip = routeStop.zip ?? "85297"
        let phone = routeStop.phone1 ?? "480-222-0286"
         
         
        
         var cnt = 0;
        var TechName = appDelegate.name ?? "SP Name"
        var licNum = appDelegate.license ?? ""
        var Account = routeStop.account
        var Office = appDelegate.office
        var Customer = routeStop.name
        var Address = routeStop.address
        var CityState = city + " " + state  + " " + zip
        var Phone = routeStop.phone1 ?? "480-222-0286"
         var ServiceType = routeStop.serviceType
        
    
         var ob = "";
         var officeAddress = "1228 E Broadway Rd";
         var officeCity = "Mesa, AZ 85204";
         var officePhone = "(480) 969-7474";
         var officeLic = "LIC# 5632";
       
        


       
         ob += "<ESC>@<LF><LF><ESC>E1Bulwark Exterminating LLC<ESC>E0<LF>" + officeLic + "<LF>" + officeAddress + "<LF>" + officeCity + "<LF>" + officePhone + "<LF><LF>";
        
    
        let now = "8/12/2023 12:33 PM"
         ob += "Service Time:" + now + "<LF>";
         
         
         
         
         ob += "Serviced By: " + TechName + "<LF>";
        if (licNum.count > 2) {
             ob += "License: " + licNum + "<LF>";
         }
         //ob += "<ESC>*p0x290Y";
         ob += "<LF>Account: <ESC>E1" + Account + "<ESC>E0<LF>";
        if ( Customer.count > 26){
            Customer = Customer.substring(to: 26);
        }
         //ob += "<ESC>*p0x350Y";
         ob += Customer + "<LF>";
         //ob.Color(iColor.BLACK);
        if ( Address.count > 31){
            Address = Address.substring(to: 31);
        }
         //ob += "<ESC>*p0x400Y";
         ob += Address + "<LF>";
        if (CityState.count > 31){
            CityState = CityState.substring(to: 31);
        }
         // ob += "<ESC>*p0x450Y";
         ob += CityState + "<LF>";
         //ob += "<ESC>*p0x500Y";
         ob += "ServiceType: " + ServiceType + "<LF>";
         var Stype = "General Pest ";
         Stype = ""
    
         ob += "<LF><ESC>E1";
         //ob += "<ESC>*p0x680Y";
         ob += "<LF>"
        ob += Stype + "Products Used\n"

        let llf = ttlLiquidLF  ?? 0
        if llf > 0 {
            let ttlgal = llf * 0.2
            var topline = ""
            
            topline += "<LF><ESC>E1Termador HE<ESC>E0 fipronil 8.73%"
            topline += "<LF>EPA Reg No. 7969-329"
           
            topline += "<LF>Amount: " + ttlgal.toNumberString(decimalPlaces: 1) + " Gal."
            topline += "<LF>Application Rate:<LF>0.125% 2 gal per 10 linear ft"
            topline += "<LF><ESC>E1Site:<ESC>E0Exterior perimeter "
            topline += "<LF><ESC>E1TargetPest:<ESC>E0Subterranean Termites"
            topline += "<LF>DO NOT touch the treated area until dry"
            
            topline += "<LF>"
            
            ob += topline
            
        }
        
        
        for i in baitStations.indices {
            
            
            let stationnumber = i + 1
            let result = baitStations[i].result
            
            var topline = "<LF><ESC>E1Termite Bait Station " + stationnumber.toString() + "<ESC>E0"
            
            topline += "<LF><ESC>E1Trelona ATBS<ESC>E0 Novaluron 0.50%"
            topline += "<LF>EPA Reg No. 499-557"
            topline += "<LF><ESC>E1Result:<ESC>E0" + result
            topline += "<LF>Contains 2 124g. bait cartridges"
            topline += "<LF><ESC>E1Site:<ESC>E0Exterior perimeter # " + stationnumber.toString()
            topline += "<LF><ESC>E1TargetPest:<ESC>E0Subterranean Termites"
            topline += "<LF><ESC>E1Dont Tamper With Bait Placement<ESC>E0"
            
            topline += "<LF>"
            
            ob += topline
        }
        

       
        ob += "<LF><LF><LF>"
        ob += "WARNING PESTICIDES CAN BE       HARMFUL KEEP CHILDREN AND PETS  AWAY FROM PESTICIDE APPLICATIONSUNTIL DRY, DISSIPATED,OR AERATEDFOR MORE INFORMATION CONTACT    BULWARK EXTERMINATING LLC.      (" + officeLic + ") AT " + officePhone
        ob += "<LF><LF><LF><LF><LF>"
     
        return ob
        
    }
 

    
}





