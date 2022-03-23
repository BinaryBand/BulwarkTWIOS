//
//  viewChat.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 2/7/22.
//

import UIKit
import WebKit




class viewChat: UIViewController,WKNavigationDelegate,WKUIDelegate {

    
    @IBOutlet var webView : WKWebView!
    
    
    
    
    
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

        //webView = WKWebView()
        webView.navigationDelegate = self
        //view = webView
        
        //webView.uiDelegate = self
        
        webView.scrollView.isScrollEnabled = false
        
        

        
        
        
        
        
      //  let url = URL(string: "https://servicesnapshot.bulwarkapp.com/WebApp?hrempid=" + h + "&p=conversationPage&id=chatrelay&hidetoolbar=1&hidebackbtn=1")!
     //   webView.load(URLRequest(url: url))
       //webView.allowsBackForwardNavigationGestures = true
        
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        WKWebsiteDataStore.default().removeData(ofTypes: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache], modifiedSince: Date(timeIntervalSince1970: 0), completionHandler:{ })

        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        let h = appDelegate.hrEmpId ?? ""
        
        let url = URL(string: "https://servicesnapshot.bulwarkapp.com/WebApp?hrempid=" + h + "&p=conversationPage&id=chatrelay&hidetoolbar=1&hidebackbtn=1")!
        webView.load(URLRequest(url: url))
        
        
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
