//
//  viewPosting.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 1/20/23.
//

import UIKit

class viewPosting: UIViewController ,WKNavigationDelegate,WKUIDelegate,TWBlunoDelegate{
 
    
    var printManager: TWBlunoManager?
    var printDev: DFBlunoDevice?
    var printDevices: [AnyHashable]?
    
    @IBOutlet var printIcon: UIBarButtonItem!
    
    @IBOutlet var webView : WKWebView!
    //var HUD: MBProgressHUD!
    @objc  var urlParams:String!
    @objc var hrEmpId:String!
    @objc var name:String!
    @objc var office:String!
    @objc var license:String!
    @objc var odometer:String!
    @objc var vin:String!
    @objc var lastObdRead:Date!
    var rs:RouteStop!
    var appDelegate:BulwarkTWAppDelegate!
    var dontScan:Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? BulwarkTWAppDelegate

        //HUD = MBProgressHUD(view: view)
       // view.addSubview(HUD)
       // HUD.hide(true)
        printIcon.tintColor = .clear
        printIcon.isEnabled = false
        
        
        
        printManager = TWBlunoManager.sharedInstance()
        printManager?.delegate = self
        printDevices = []
        
        Utilities.delay(bySeconds: 0.2, dispatchLevel: .main){
            
            self.printManager?.scan()
            
        }
        
        
        
    webView.navigationDelegate = self
    //view = webView
    
    webView.uiDelegate = self
        
        webView.scrollView.isScrollEnabled = false

        webView.layer.cornerRadius = 9
        webView.layer.masksToBounds = true
        
        
        let turl = URL(string: getProductsFile())!
       webView.load(URLRequest(url: turl))
        
        self.title = "Posting: " + rs.account
        
       
        
        
        // Do any additional setup after loading the view.
        
        
        
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool){
       dontScan = true
        printManager?.stop()
        printManager?.disconnect(to: printDev)
        
        super.viewWillDisappear(animated)
        
    }

    func getProductsFile() -> String{
        


                    
                    
                    var p = ""
                     var h = ""
                     var n = ""
                     var o = ""
                     var l = ""
                     
                    if let hh = hrEmpId{
                        h = hh
                    }
                    if let nn = name{
                        n = nn
                    }
                    if let oo = office{
                        o = oo
                    }
                    if let ll = license{
                        l = ll
                    }
         
                    if let pp = urlParams{
                        p = pp
                    }
                    
        let ti = DataUtilities.getArrivalTime()
                    let paramStr = p + "&techname=" + n + "&licnum=" + l + "&office=" + o + "&h=" + h  + "&timein=" + ti
                    
                    
                    
                    
                    let resp = DataUtilities.getProductsUsedFile(paramatersToReplace: paramStr, officeCode: o)
      
        
        let encoded = resp.data(using: .utf8)?.base64EncodedString() ?? "<!DOCTYPE html><html><body><br><br><h3>Missing Products Used file download it from settings</h3></body></html>"
        
       let finalres = "data:text/html;charset=utf-8;base64," + encoded
        
        
        return finalres

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
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showActivityIndicator(show: false)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showActivityIndicator(show: true)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
    }

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {

            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let title = NSLocalizedString("OK", comment: "OK Button")
            let ok = UIAlertAction(title: title, style: .default) { (action: UIAlertAction) -> Void in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(ok)
            present(alert, animated: true)
            completionHandler()
        
        }

   
    
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {

            let alert = UIAlertController(title: nil, message: prompt, preferredStyle: .alert)

            alert.addTextField { (textField) in
                textField.text = defaultText
            }

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                if let text = alert.textFields?.first?.text {
                    completionHandler(text)
                } else {
                    completionHandler(defaultText)
                }

            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in

                completionHandler(nil)

            }))

             
        
        present(alert, animated: true)
        
    }

    
    

    
    
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {

        
        if pageAction(message){
            
            
            

            completionHandler(false)
            
            
            
            
            
        }else{
            let alertController = UIAlertController(title: "Confirm", message: message, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                completionHandler(true)
            }))

            alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
                completionHandler(false)
            }))


            present(alertController, animated: true)
        }
        

        }
    
    
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
               
        if let url = navigationAction.request.url {
            
            let urlStr = url.absoluteString
            
            if urlStr.starts(with: "bulwarktw"){
                
                
               // let urlparams = urlStr.components(separatedBy: "?")
                
               // if urlparams.count > 3{
                  //  let dpage = Double(urlparams[1])
                    
                   // let param = urlparams[2]
                    
                    
                    //pageAction(dpage!, urlParam: param)
                   // if dpage == 11 {
                       // performSegue(withIdentifier: "showPosting", sender: nil)
                        
                   // }
                        
                    
              //  }
                    
                
                
               // guard
               //     let component = URLComponents(string: url.absoluteString),
                   // let account = component.queryItems?.first(where: { $0.name == "accountnumber" })?.value,
                   // let routestopid = component.queryItems?.first(where: { $0.name == "routestopid" })?.value,
                   // let hrempid = component.queryItems?.first(where: { $0.name == "hr_emp_id" })?.value
                       // let servicetypecode = component.queryItems?.first(where: { $0.name == "hr_emp_id" })?.value
                        
               // else {
                //        return
                //    }
                
                
                
                decisionHandler(.cancel)
                return
            }
            
            
            
        }
        
        
        decisionHandler(.allow)
              
        
        

    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
       

        decisionHandler(.allow)
    }
    
    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.

        
        
    }
   */

    
    
    //MARK: - URLParamater
    
    func pageAction(_ str: String) -> Bool{
        
        
        
        if str.starts(with: "print:"){
            
            
            let messageJson = str.replacingOccurrences(of: "print:", with: "")
            
            do {
                let data = messageJson.data(using: .utf8)!
                // Parse the JSON data
                let pres = try JSONDecoder().decode(PrintSend.self, from: data)
                
                if pres.printTicket{
                    
                    let presult = sendStringToPrint(pres.printString)
                    
                    if !presult{
                        
                        let alertController = UIAlertController(title: "Error Printing", message: "Check that the printer is turned on and connected", preferredStyle: .alert)
                        
                        alertController.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                        
                        
                        present(alertController, animated: true)
                        
                        
                        
                    }
                    
                }
                
                let av = appDelegate.appBuild ?? "none"
                let obdDate = appDelegate.lastObdRead.toString(format: .usDateTime24WithSec) ?? "1/1/1900"
                
                let tc = appDelegate.obdTroubleCodes ?? ""
                
                let saveResults = DataUtilities.SavePostingResults(UrlToStave: pres.url, Lat: appDelegate.lat, Lon: appDelegate.lon, Vin: appDelegate.vin, Odometer: appDelegate.odo, OdoLastUpdated: obdDate, Rdate: rs.rdate, appversion: av, troubleCode: tc)
                
                if saveResults == true {
                    
                    Task {
                        do {
                            
                            
                            let fetch = try await JsonFetcher.SendPostingResultsAsync(hrEmpId: appDelegate.hrEmpId)
                            
                            if fetch {
                                if pres.printTicket == false{
                                    performSegue(withIdentifier: "unwindToDash", sender: self)
                                }
                               
                            }
                            
                            
                        }catch {}
 
                    }
                }
                
                
                }
                catch
                {}
                
            
            return true
            
        }
        
        
        
        
        return false
    }
    
    
    

    
    //MARK: - BLE Printer
    
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
    

    
}
