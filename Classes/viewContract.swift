//
//  viewContract.swift
//  BulwarkTW
//
//  Created by Kole on 6/28/22.
//

import UIKit

import WebKit

@objc class viewContract: UIViewController ,WKNavigationDelegate,WKUIDelegate {

    @IBOutlet var webView : WKWebView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    webView.navigationDelegate = self
    //view = webView
    
    webView.uiDelegate = self
        let turl = URL(string: url)!
       webView.load(URLRequest(url: turl))
        // Do any additional setup after loading the view.
    }
    @objc  var url:String!

    @objc func openContract(contractUrl:String){
          
       //  let turl = URL(string: contractUrl)!
     //   webView.load(URLRequest(url: turl))
    }
    @objc func openContract(){
          
         //let turl = URL(string: url)!
       // webView.load(URLRequest(url: turl))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
  
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
     
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {

    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.

        
        
    }
    

}
