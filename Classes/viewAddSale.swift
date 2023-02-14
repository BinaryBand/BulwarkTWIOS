//
//  viewAddSale.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 5/23/22.
//

import UIKit
import WebKit


class viewAddSale: UIViewController,WKNavigationDelegate,WKUIDelegate {

    @IBOutlet var webView : WKWebView!
    //var HUD: MBProgressHUD!
    var mapDate:String?
    var appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if #available(iOS 15, *){
          //  print("Create the collection view!")
        }else{
            
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.view.backgroundColor = .clear
        }

        
        //let contentController = WKUserContentController()
        //      let scriptSource = "document.body.style.backgroundColor = `red`;"
        //      let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        //      contentController.addUserScript(script)
              
        //      let config = WKWebViewConfiguration()
      //        config.userContentController = contentController
       
        
       // webView = WKWebView(frame: self.view.bounds, configuration: config)
              
            
        webView.navigationDelegate = self
        //view = webView
        
        webView.uiDelegate = self
        
       // webView.scrollView.isScrollEnabled = false
        

        
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        //appDelegate.viewSched = self
       
        //HUD = MBProgressHUD(view: view)
        //view.addSubview(HUD)
        //HUD.hide(true)
        
        
        
 
        let h = appDelegate.hrEmpId ?? ""
        
        
       
        
        
        if let url = URL(string: "https://tools.tem-pest.com/api/authentication/user.php?key=2T4QfdNKQn4vP9qF&hr_emp_id=" + h) {
            do {
                let contents = try String(contentsOf: url)
                print(contents)
                
                
                
                let jsonData = contents.data(using: .utf8)!
                let tempKey: TempKey = try! JSONDecoder().decode(TempKey.self, from: jsonData)

                print(tempKey.token)
                
                
                
                let tempurl = URL(string: "https://pro.tem-pest.com/login.php")!
                
                //https://pro.tem-pest.com/lookup/?sm=7220&cid=new
                
               // let tempurl = URL(string: "https://pro.tem-pest.com/lookup/?sm=7220&cid=564552")!
                
                var tempRequest = URLRequest( //2
                    url: tempurl
                )

                tempRequest.setValue( //3
                    "Bearer \(tempKey.token)",
                    forHTTPHeaderField: "authorization"
                )
                
                
                

                
                
                webView.load(tempRequest)
                
                
                Utilities.delay(bySeconds: 25){
                   // let tempurl1 = URL(string: "https://pro.tem-pest.com/lookup/?sm=7220&cid=564552")!
                    //self.webView.load(URLRequest(url: tempurl1))
                }
                Utilities.delay(bySeconds: 45){
                   // self.displayAlert()
                }
                
                
            } catch {
                 print("contents could not be loaded")
            }
        } else {
             print("the URL was bad!")
        }
        

        
        
        
     

        // Do any additional setup after loading the view.
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
        
        let urlStr = webView.url?.absoluteString
        
        if ((urlStr?.localizedCaseInsensitiveContains("lookup")) == true){
        
            
            
            webView.evaluateJavaScript("document.getElementById('VG_NewCustId').value") {(result, error) in
                   guard error == nil else {
                      // print(error!)
                       return
                   }
                   
                if let cid = result as? String {
                       
                    print(cid)
                    
                    
                    if cid != "" {
                        self.displayScheduleContractAlert(customerId: cid, serviceType: "IS")
                    }
                    
                    }
                
               }
            
            
            Utilities.delay(bySeconds: 0.3)
            {
                
                        webView.evaluateJavaScript("$('#serviceAgreementIpad').modal('hide');") {(result, error) in
                   guard error == nil else {
                      // print(error!)
                       return
                   }
                   
               
                
               }
            }
            //
            
            
            
            //let scriptSource = "document.body.style.backgroundColor = `red`;"
            /*
            var script = "document.querySelector('body > div.page-content.pt-0 > div.sidebar.sidebar-light.sidebar-main.sidebar-expand-md.align-self-start').style.display = 'none'; document.querySelector('body > div.navbar.navbar-expand-md.navbar-dark').style.display = 'none';  document.querySelector('body > div.page-header').style.display = 'none';  document.querySelector('body > div.navbar.navbar-expand-lg.navbar-light').style.display = 'none';  document.getElementById('endeavorBtn').style.display = 'none';  document.getElementById('SendQuote').style.display = 'none';  document.getElementById('NearLocation').style.display = 'none';  document.getElementById('Address').removeAttribute('onfocus');"
            
            let script2 = "document.querySelector('body > div.navbar.navbar-expand-lg.navbar-light').style.display = 'none';"
            
             //script = "var opt = document.createElement('option');  opt.value = '154'; opt.innerHTML = Terry Whipple;  document.getElementById('Salesman_Id').add(opt); document.getElementById('Salesman_Id').value = '154';"
            
            script = ""
            
            
           webView.evaluateJavaScript(script, completionHandler: { (object, error) in
                
            })
            */
        }
        
            
            //urlStr is what you want
        
        
        
       
        
        //let js = "const sb = document.getElementsByClassName('.sidebar')[0]; sb.style.display = 'none';"
        
       // webView.evaluateJavaScript("document.getElementById('someElement').innerText") { (result, error) in
           // if error == nil {
               // print(result)
           // }
       // }
        
        //webView.evaluateJavaScript(js, completionHandler: nil)
        
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showActivityIndicator(show: true)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
    }

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {

        if !message.starts(with: "schedule="){
            
        
        
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let title = NSLocalizedString("OK", comment: "OK Button")
            let ok = UIAlertAction(title: title, style: .default) { (action: UIAlertAction) -> Void in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(ok)
            present(alert, animated: true)
        }
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
        

        //let headers = navigationAction.request.allHTTPHeaderFields
        
       // print(headers)
        
        if let postbody = navigationAction.request.httpBody {
            print(String(data: postbody, encoding: .utf8) ?? "")
        }
        
        
        let url = navigationAction.request.url
        
        //print(url)
        
        if(url?.scheme == "bulwarktw"){
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
            return
        }
        if(url?.scheme == "bulwarktwmap"){
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
            return
        }
        
        
        decisionHandler(.allow)
        

    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
       
        
        decisionHandler(.allow)
    }
    
    
    func displayAlert() {
         // Declare Alert message
         let dialogMessage = UIAlertController(title: "Schedule?", message: "Do you want to add this account to a route?", preferredStyle: .alert)
         
         // Create OK button with action handler
         let ok = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
             print("Ok button tapped")
         
             
             
             let customView = self.storyboard?.instantiateViewController(withIdentifier: "viewFBFSearch") as? viewFBFSearch
             
             customView?.HrEmpId = "215734";
             customView?.FromPage = "AddSale"
             customView?.CustomerId = 376665;
             customView?.ServiceId = 0;
             customView?.isNC = true;
             customView?.accountNumber = "NC-376665";
             customView?.ServiceType = "IS";
             //customView.istoday = 1;

             
             customView?.modalTransitionStyle = .coverVertical
             customView?.modalPresentationStyle = .pageSheet
             

             
             self.present(customView!,animated:true, completion:nil)
             
             
             
             
         })
         
         // Create Cancel button with action handlder
         let cancel = UIAlertAction(title: "No", style: .cancel) { (action) -> Void in
             print("Cancel button tapped")
         }
         
         //Add OK and Cancel button to dialog message
         dialogMessage.addAction(ok)
         dialogMessage.addAction(cancel)
         
         // Present dialog message to user
         self.present(dialogMessage, animated: true, completion: nil)
         
     }
    
    
    func displayScheduleContractAlert(customerId: String, serviceType: String){
        
        
        webView.evaluateJavaScript("document.getElementById('ServiceAgreementSigned').value") {(result, error) in
               guard error == nil else {
                  // print(error!)
                   return
               }
               
            if let sig = result as? String {
                   
                print(sig)
                
                
                if sig != "" {
                    
                }
                
                
            
           
        
        
        let alert = UIAlertController(title: "Sale Saved", message: "", preferredStyle: .actionSheet)
               
            
            
            if sig != "1" {
                
            
            alert.addAction(UIAlertAction(title: "Sign Contract on Ipad", style: .default, handler: { (_) in
                    //document.getElementsByTagName('button')[0].click();
                    
                    Utilities.delay(bySeconds: 0.1)
                    { [self] in
                        
                                webView.evaluateJavaScript("document.getElementById('OnIpad').click();") {(result, error) in
                           guard error == nil else {
                              // print(error!)
                               return
                           }
                           
                       
                        
                       }
                    }
                   
                    
                    
                }))

        alert.addAction(UIAlertAction(title: "Text/Email Contract", style: .default, handler: { [self] (_) in
                    
            Utilities.delay(bySeconds: 0.1)
            { [self] in
                
                        webView.evaluateJavaScript("document.getElementById('SendNormalAgreement').click();") {(result, error) in
                   guard error == nil else {
                      // print(error!)
                       return
                   }
                   
               
                
               }
            }
            
            
                }))
                
            }
                alert.addAction(UIAlertAction(title: "Schedule Service", style: .default, handler: { [self] (_) in
                    
                    let customView = self.storyboard?.instantiateViewController(withIdentifier: "viewFBFSearch") as? viewFBFSearch
                    
                    customView?.HrEmpId = appDelegate.hrEmpId;
                    customView?.FromPage = "AddSale"
                    customView?.CustomerId = Int(customerId) ?? 0;
                    customView?.ServiceId = 0;
                    customView?.isNC = true;
                    customView?.accountNumber = "NC-" + customerId;
                    customView?.ServiceType = "IS";
                    //customView.istoday = 1;

                    
                    customView?.modalTransitionStyle = .coverVertical
                    customView?.modalPresentationStyle = .pageSheet
                    

                    
                    self.present(customView!,animated:true, completion:nil)
                    
            
            
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
        }
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
       // if(segue.identifier == "OpenMapsSegue"){
            
          //      let displayVC = segue.destination as! viewRouteMap
           // displayVC.rurl = mapDate
      //  }
    }
    

    struct TempKey: Decodable {
        enum Category: String, Decodable {
            case swift, combine, debugging, xcode
        }

        let status: Bool
        let token: String
        let message: String
    }
    
}
