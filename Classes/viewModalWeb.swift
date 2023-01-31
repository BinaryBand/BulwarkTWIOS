//
//  viewModalWeb.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 9/28/22.
//

import UIKit
import WebKit
import Toast

class viewModalWeb: UIViewController,WKNavigationDelegate,WKUIDelegate {

    @IBOutlet var webView : WKWebView!
    //var HUD: MBProgressHUD!
    @objc  var url:String!
    
    @objc var hrEmpId:String!
    
     var useCookie:Bool!
    
    
    
    var refController:UIRefreshControl = UIRefreshControl()


    override func viewDidLoad()  {
        
        super.viewDidLoad()
        
        
        //HUD = MBProgressHUD(view: view)
        //view.addSubview(HUD)
        //HUD.hide(true)
        
        
    webView.navigationDelegate = self
    //view = webView
    
    webView.uiDelegate = self
        
        
        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        
        if let hascookie = useCookie{
            
            if hascookie{
                
                
                
                Task {
                    
                    do {
                        
                        let cookie = try await JsonFetcher.postAuthCookieJson(hrEmpId: hrEmpId)
                        await webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
                        // Update collection view content
                       
                        
                        //HUD.hide(true)
                   
                        
                        let turl = URL(string: url)!
                        
 
                       webView.load(URLRequest(url: turl))
                        
                        
                    } catch {
                        print("Request failed with error: \(error)")
                    }
                    
                }
                
                
                
            }else{
                
                let turl = URL(string: url)!
            
                
               webView.load(URLRequest(url: turl))
                
                
            }
            
            
            
        }else{
            let turl = URL(string: url)!
            

           webView.load(URLRequest(url: turl))
        }
        
        
       
        // Do any additional setup after loading the view.
        
        
        refController.bounds = CGRect.init(x: 0.0, y: 50.0, width: refController.bounds.size.width, height: refController.bounds.size.height)
        refController.addTarget(self, action: #selector(self.webviewRefresh(refresh:)), for: .valueChanged)
        webView.scrollView.addSubview(refController)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == #keyPath(WKWebView.title) {
                self.title = self.webView.title
            }
        }
    
    
    
    @objc func webviewRefresh(refresh:UIRefreshControl){
        refController.endRefreshing()
        webView.reload()
    }
    
    func showActivityIndicator(show: Bool) {
        if show {
            self.view.makeToastActivity(.center)
            
            //HUD.show(true)
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

        
        
        if(message.starts(with: "CloseModal")){
            
            completionHandler()
            self.dismissThis()
            
        }else{
            
            
            
        
        
        
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let title = NSLocalizedString("OK", comment: "OK Button")
            let ok = UIAlertAction(title: title, style: .default) { (action: UIAlertAction) -> Void in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(ok)
            present(alert, animated: true)
        
            completionHandler()
        
        }
        
        }

    func dismissThis(){
        self.dismiss(animated: true, completion: nil)
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

            let alertController = UIAlertController(title: "Confirm", message: message, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                completionHandler(true)
            }))

            alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
                completionHandler(false)
            }))


            present(alertController, animated: true)
        }
    
    
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
       
        
        
        let url = navigationAction.request.url;
        
        if(url?.scheme == "bulwarktw"){
            
            let strprt = url?.absoluteString
            let arr = strprt?.split(separator: "?")
            let spage = arr?[1] ?? "0"
            let dpage = Int(spage) ?? 0
            
            if(dpage==32){
               
                
                decisionHandler(.cancel)
                self.dismissThis()
                
            }else{
                
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
            }

           
        }else if url?.scheme == "bulwarktwfbf"{
            
            let strprt = url?.absoluteString
            let arr = strprt?.split(separator: "?")
            let spage = arr?[1] ?? "0"
            let dpage = Int(spage) ?? 0
            let param = arr?[2] ?? ""
            if(dpage==1){
               //open fbfsearch to add to a reoute
                //bulwarktwfbf://?1?customerId=556330&serviceId=679795&servicetype=QT&report=DormantAccounts&hrempid=417812
                
                let urlparamarr = param.split(separator: "&")
                var customerId = 0
                var serviceId = 0
                var serviceType = ""
                var report = ""
                var account = ""
                
                for p in urlparamarr{
                    
                    
                    let ss = p.split(separator: "=")
                    if ss.count == 2{
                        let k = String(ss[0])
                        let v = String(ss[1])
                        
                        
                        if k == "customerId"{
                            customerId = Int(v) ?? 0
                        }
                        if k == "serviceId"{
                            serviceId = Int(v) ?? 0
                        }
                        if k == "servicetype" {
                            serviceType = v
                        }
                        if k == "report"{
                            report = v
                        }
                        if k == "account"{
                            account = v
                        }
                        
                    }
                    
                    
                    
                }
                        
                
                
                let customView = self.storyboard?.instantiateViewController(withIdentifier: "viewFBFSearch") as? viewFBFSearch
                
                customView?.HrEmpId = hrEmpId;
                customView?.FromPage = report
                customView?.CustomerId = customerId;
                customView?.ServiceId = serviceId;
                customView?.isNC = false;
                customView?.accountNumber = account;
                customView?.ServiceType = serviceType;
                //customView.istoday = 1;

                
                customView?.modalTransitionStyle = .coverVertical
                customView?.modalPresentationStyle = .pageSheet
                

                
                self.present(customView!,animated:true, completion:nil)
                
                
                decisionHandler(.cancel)
                //self.dismissThis()
                
            }else if dpage==2{
                //transfer soft contacted
                let urlparamarr = param.split(separator: "&")
                var customerId = 0
                var workOrderId = 0
                var serviceType = ""
                var report = ""
                var account = ""
                
                for p in urlparamarr{
                    
                    
                    let ss = p.split(separator: "=")
                    if ss.count == 2{
                        let k = String(ss[0])
                        let v = String(ss[1])
                        
                        
                        if k == "customerId"{
                            customerId = Int(v) ?? 0
                        }
                        if k == "workorderid"{
                            workOrderId = Int(v) ?? 0
                        }
                        if k == "servicetype" {
                            serviceType = v
                        }
                        if k == "report"{
                            report = v
                        }
                        if k == "account"{
                            account = v
                        }
                        
                    }
                    
                    
                    
                }
                        
                
                
               // self.transferService(routeId: routeId, workOrderId: workOrderId, fromPage: report)
                
                
                
                decisionHandler(.cancel)
                //self.dismissThis()
            }else if dpage==3{
                //transfer hard contact
                
                decisionHandler(.cancel)
                //self.dismissThis()
                
            }else{
                
                
                
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
            }

            
            
            
            
        }else{
            
            decisionHandler(.allow)
            
        }
        
        
        
        
        
        
        
                
              

    }
    
    
    
    func transferService(routeId: Int, workOrderId:Int, fromPage: String){
        let message = "Transfer the service to my route today?"
        
        
        let alertController = UIAlertController(title: "Confirm", message: message, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] (action) in
            
            self.view.makeToastActivity(.center)
        
            let atrp = AddToRouteParams(RouteId: routeId, StartAt: "8:00 AM", FromHrEmpId: hrEmpId, RollingKey: "", FromPage: fromPage, CustomerId: 0, ServiceId: 0, isNC: false, isTransfer: true, workOrderId: workOrderId)
        
        
            let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
            //appDelegate.viewSched = self
           

            
            
            
     
         //   let h = appDelegate.hrEmpId ?? ""
            
            //let fbfSamp = FBFSearch.sampleData
           
            
            var urlStr = "https://twapiweb.bulwarkapp.com/AddToRoute"
            
            //urlStr = "http://10.211.55.4:5095/AddToRoute"
            
            
            Task {
                
                do {
                    
                    let auResult = try await JsonFetcher.postAddToRouteJson(urlStr: urlStr, addToRouteParam: atrp)
                    
                    // Update collection view content
                    //self.tableView.reloadData()
                    
                    //HUD.hide(true)
                    if(auResult.Success == false){
                        print(auResult.Error)
                        
                        let msg = "Error adding with reason " + auResult.Error + " Contact the support center to add this service to route"
                        
                        let alertController2 = UIAlertController(title: "Error Adding To Route", message: msg, preferredStyle: .alert)
                        alertController2.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                            //self.viewController?.dismiss(animated: true, completion: nil)
                            
                            
                        }))
                        
                        self.present(alertController2, animated: true)
                        
                        
                    }else{
                        
                        self.view.hideToastActivity()
                        
                        var style = ToastStyle()
                        style.titleFont = UIFont(name: "Arial-BoldMT", size: 14)!
                        style.messageFont = UIFont(name: "ArialMT", size: 12)!
                        //style.messageColor = UIColor.yellow
                        style.messageAlignment = .center
                        style.imageSize = CGSize(width: 50, height: 45)
                        style.backgroundColor = UIColor(red: 62.0 / 255.0, green: 128.0 / 255.0, blue: 180.0 / 255.0, alpha: 0.9)
                        
                        self.view.makeToast("Account added to route", duration: 2.2, position: .center, title: "Success", image: UIImage(named: "GreenCheckmark.png"), style: style)
                        
                        self.dismiss(animated: true, completion: nil)
                        
                        }
                    
                    
                    
                } catch {
                    print("Request failed with error: \(error)")
                }
                
            }



            
            
            
        
        }))

        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
          
            

            
        }))


        self.present(alertController, animated: true)
        
        
        
        
        
    }
    
    
    
    
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
       

        decisionHandler(.allow)
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
