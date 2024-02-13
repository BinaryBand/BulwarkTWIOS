//
//  viewTBSBid.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 8/1/23.
//

import UIKit
import WebKit
import PDFKit

class viewTBSBid: UIViewController, WKNavigationDelegate {

    @IBOutlet var homeImage: UIImageView!
    
   // @IBOutlet var webView: WKWebView!
    
    var homeImg:UIImage?
    
    @IBOutlet var lblName: UILabel!
    
    @IBOutlet var lblPhone1: UILabel!
    
    @IBOutlet var lblPhone2: UILabel!
    
    @IBOutlet var lblEmail: UILabel!
    
    @IBOutlet var lblAddress: UILabel!
    
    @IBOutlet var lblCity: UILabel!
    
    @IBOutlet var lblState: UILabel!
    
    @IBOutlet var lblZip: UILabel!
    
    @IBOutlet var lblLiquitProduct: UILabel!
    
    @IBOutlet var lblLiquidAmount: UILabel!
    
    @IBOutlet var lblBaitCharge: UILabel!
    
    @IBOutlet var lblTotalCharge: UILabel!
    
    @IBOutlet var lblLFtoTreat: UILabel!
    
    @IBOutlet var lblTotalLiquid: UILabel!
    
    @IBOutlet var lblTotalStations: UILabel!
    
    @IBOutlet var lblSPName: UILabel!
    
    @IBOutlet var lblLicense: UILabel!
    
    @IBOutlet var lblDate: UILabel!
    
    
    var baitStations = [StationCheck]()
    var routeStop:RouteStop!
    var additionalConditions:[TermiteCondition]?
    
    var ttlLiquidLF:Double?
    var homeLF:Double?
    
    var appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let img = homeImg{
            homeImage.image = img
            homeImage.contentMode = .scaleToFill
          //  homeImage.transform = homeImage.transform.rotated(by: .pi / 2)
        }
        
        fillForm()
       // webView.navigationDelegate = self
        
        
        /*
        let file = "termiteBid.jpg" //this is the file. we will write to and read from it

       

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file)
            
            let fm = FileManager.default
            if !fm.fileExists(atPath: fileURL.path){
               
              
              
                //webView.load(URLRequest(url: turl))
            }else{
                
                
               // let data = try! Data(contentsOf: fileURL)
              
                //webView.load(data, mimeType: "application/pdf", characterEncodingName:"", baseURL: fileURL.deletingLastPathComponent())
                
                //webView.loadFileURL(fileURL, allowingReadAccessTo: dir)
             
               // let turl =  URL(string:"https://www.google.com")!
               // webView.load(URLRequest(url: turl))
                
            }
            
        }
        */
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func fillForm(){
        
        
        lblName.text = routeStop.name
         
        lblPhone1.text = routeStop.phone1 ?? "480-745-5226"
        
         
        lblPhone2.text = routeStop.phone2 ?? "480-222-0286"
        
         
        lblEmail.text = routeStop.email ?? "terrywhipple11@gmail.com"
        
         
        lblAddress.text = routeStop.address
        
         
        lblCity.text = routeStop.city ?? "Gilbert"
        
         
        lblState.text = routeStop.state ?? "AZ"
        
         
        lblZip.text = routeStop.zip ?? "85297"
        
        let lf = ttlLiquidLF?.rounded(toPlaces: 0) ?? 0
        let la = lf * 0.4
        
        let ts = baitStations.count
        let tbc = Double(ts) * 70.0
        
        let tlc = lf * 10
        let tc = tlc + tbc
        
        
        
        if lf > 0 && ts > 0{
            lblLiquitProduct.text = "Termidor HE"
            lblLiquidAmount.text = tlc.toMoneyString()
            lblTotalLiquid.text = la.toNumberString(decimalPlaces: 1) + " gal"
            lblLFtoTreat.text = lf.toNumberString(decimalPlaces: 1)
        }else{
            lblLiquitProduct.text = ""
            lblLiquidAmount.text = ""
            lblTotalLiquid.text = ""
            lblLFtoTreat.text = ""
        }
        
        
 
        

        
        if ts > 0{
            lblLiquitProduct.text = "Trelona ATBS"
            lblBaitCharge.text = tbc.toMoneyString()
            lblTotalStations.text = ts.toString()
            
        }else{
            
            lblBaitCharge.text = ""
            lblTotalStations.text = ""
        }
            
        
        if lf > 0 && ts > 0{
            lblLiquitProduct.text = "Termidor HE / Trelona ATBS"
        }
       
         
        
        
         
        lblTotalCharge.text = tc.toNumberString()
        
         
        
        
         
        
        
         
        
        
         
        lblSPName.text = appDelegate.name ?? ""
        
         
        lblLicense.text = appDelegate.license ?? ""
        
         
        lblDate.text = Utilities.CurrentDateString()
        
        
        
        
        
    }
    
    
    
    
    func getimgtoPrint() -> UIImage{
        
        let bounds = UIScreen.main.bounds
        //let size = bounds.size
        let height = bounds.height - 90
        let width = bounds.width - 40
        let size = CGSize(width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
            self.view.drawHierarchy(in: CGRectMake(-20, -90, view.bounds.size.width, view.bounds.size.height), afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        
        
        
        return img
        
        
    }
    
    
    @IBAction func btnPrint(_ sender: Any) {
        
        
        //let webviewPrint = webView.viewPrintFormatter()
            let printInfo = UIPrintInfo(dictionary: nil)
            printInfo.jobName = "page"
            printInfo.outputType = .general
            let printController = UIPrintInteractionController.shared
            printController.printInfo = printInfo
            printController.showsNumberOfCopies = false
            //printController.printFormatter = webviewPrint
        printController.printingItem = getimgtoPrint()
            printController.present(animated: true, completionHandler: nil)
        
        
        
        
        
    }
    
    
    func printpdf(){
        if let guide_url = Bundle.main.url(forResource: "RandomPDF", withExtension: "pdf"){
                    if UIPrintInteractionController.canPrint(guide_url) {
                        let printInfo = UIPrintInfo(dictionary: nil)
                        printInfo.jobName = guide_url.lastPathComponent
                        printInfo.outputType = .photo

                        let printController = UIPrintInteractionController.shared
                        printController.printInfo = printInfo
                        printController.showsNumberOfCopies = false

                        printController.printingItem = guide_url

                        printController.present(animated: true, completionHandler: nil)
                    }
                }
    }
    
    func makePDF(){
        
        let bounds = UIScreen.main.bounds
        //let size = bounds.size
        let height = bounds.height - 170
        let width = bounds.width
        let size = CGSize(width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
            self.view.drawHierarchy(in: CGRectMake(0, -170, view.bounds.size.width, view.bounds.size.height), afterScreenUpdates: true)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        
       // let pdfPage = PDFPage(image: screenshotImage)
       // let fm = FileManager.default urls = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
       // let savedPDF = urls!.appendingPathComponent("pdfPage.pdf") pdfPage?.document?.write(toFile: "pdfPage")
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
extension UIView {
 func toImage() -> UIImage {
     UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)

     drawHierarchy(in: self.bounds, afterScreenUpdates: true)

     let image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
 }
}

