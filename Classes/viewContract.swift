//
//  viewContract.swift
//  BulwarkTW
//
//  Created by Kole on 6/28/22.
//

import UIKit

import WebKit

@objc class viewContract: UIViewController {

    @IBOutlet var webView : WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  @objc  var url:String?

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.

        
        
    }
    

}
