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
    var HUD: MBProgressHUD!
    var mapDate:String?
    
    
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
       
        HUD = MBProgressHUD(view: view)
        view.addSubview(HUD)
        HUD.hide(true)
        
        
        
 
        let h = appDelegate.hrEmpId ?? ""
        
        
       
        
        
        if let url = URL(string: "https://tools.tem-pest.com/api/authentication/user.php?key=2T4QfdNKQn4vP9qF&hr_emp_id=" + h) {
            do {
                let contents = try String(contentsOf: url)
                print(contents)
                
                
                
                let jsonData = contents.data(using: .utf8)!
                let tempKey: TempKey = try! JSONDecoder().decode(TempKey.self, from: jsonData)

                print(tempKey.token)
                
                
                
                let tempurl = URL(string: "https://pro.tem-pest.com/login.php")!
                
                var tempRequest = URLRequest( //2
                    url: tempurl
                )

                tempRequest.setValue( //3
                    "Bearer \(tempKey.token)",
                    forHTTPHeaderField: "authorization"
                )
                
                
                

                
                
                webView.load(tempRequest)
                
                
                
                
                
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
            HUD.show(true)
        } else {
            HUD.hide(true)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showActivityIndicator(show: false)
        
       // let urlStr = webView.url?.absoluteString
        /*
        if ((urlStr?.localizedCaseInsensitiveContains("lookup")) == true){
        
            //let scriptSource = "document.body.style.backgroundColor = `red`;"
            
            var script = "document.querySelector('body > div.page-content.pt-0 > div.sidebar.sidebar-light.sidebar-main.sidebar-expand-md.align-self-start').style.display = 'none'; document.querySelector('body > div.navbar.navbar-expand-md.navbar-dark').style.display = 'none';  document.querySelector('body > div.page-header').style.display = 'none';  document.querySelector('body > div.navbar.navbar-expand-lg.navbar-light').style.display = 'none';  document.getElementById('endeavorBtn').style.display = 'none';  document.getElementById('SendQuote').style.display = 'none';  document.getElementById('NearLocation').style.display = 'none';  document.getElementById('Address').removeAttribute('onfocus');"
            
            let script2 = "document.querySelector('body > div.navbar.navbar-expand-lg.navbar-light').style.display = 'none';"
            
             //script = "var opt = document.createElement('option');  opt.value = '154'; opt.innerHTML = Terry Whipple;  document.getElementById('Salesman_Id').add(opt); document.getElementById('Salesman_Id').value = '154';"
            
            script = ""
            
            
           webView.evaluateJavaScript(script, completionHandler: { (object, error) in
                
            })
            
        }
        */
            
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
        
        
        let url = navigationAction.request.url;
        
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
