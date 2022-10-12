//
//  viewISExtendedOptIn.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 7/8/22.
//

import UIKit


class viewISExtendedOptIn: UIViewController {

    @IBOutlet weak var Slider1: UISlider!
    @IBOutlet weak var Slider2: UISlider!
    @IBOutlet weak var Slider3: UISlider!
    @IBOutlet weak var Pay1: UILabel!
    @IBOutlet weak var Pay2: UILabel!
    @IBOutlet weak var Pay3: UILabel!
    @IBOutlet weak var Stepper: UIStepper!
    @IBOutlet weak var HowMany: UILabel!
    @IBOutlet weak var TotalPay: UILabel!
    
    @IBOutlet weak var Miles1: UILabel!
    @IBOutlet weak var Miles2: UILabel!
    @IBOutlet weak var Miles3: UILabel!
    
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var lblDateFor: UILabel!
    
    @objc var DateFor:String!
    
    @objc var isEarly:Int = 0
    @objc var routeDate:String!
    @objc var istoday:Int = 2
    @objc var fromVR:Int = 0
    var Slider1Value:Int!
    var Slider2Value:Int!
    var Slider3Value:Int!
    
    var hm:Int!
    var ttlPossiblePay:Decimal!
    
    @objc var viewRoute:viewRoutes!
    
    @IBOutlet var viewCenter: UIView!
    @IBOutlet var viewBkGnd: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //fatalError("Crash Triggered hhhhhh")
        
        viewCenter.layer.borderColor = UIColor.black.cgColor
        viewCenter.layer.borderWidth = 2
        
        viewCenter.layer.cornerRadius = 10.0
        
        viewCenter.layer.shadowColor = UIColor.black.cgColor
        viewCenter.layer.shadowOpacity = 0.2
        viewCenter.layer.shadowOffset = CGSize(width: 6, height: 6)
        viewCenter.layer.shadowRadius = 10.0

        // Set masksToBounds to false, otherwise the shadow
        // will be clipped and will not appear outside of
        // the view’s frame
        viewCenter.layer.masksToBounds = false
        
        
        //viewBkGnd.layer.opacity = 0.2
        
        //viewCenter.layer.opacity = 1.0
        
        
        
        
        
        if(isEarly == 0){
        Slider2.isHidden = true
        Pay2.isHidden = true
        Miles2.isHidden = true
        
        Slider3.isHidden = true
        Pay3.isHidden = true
        Miles3.isHidden = true
            
        
        Slider2Value = 20
        Slider3Value = 20
            
        }
        Slider1Value = 20
        
       // Pay1.text = "test"
      //  btnSave.isHidden = true
        
            hm = 1
        
        
        
        // Do any additional setup after loading the view.
        
        updateTotals()
        lblDateFor.text = DateFor
        
    }


    @IBAction func stepperCbange(_ sender: UIStepper) {
        
        StepperChange(val: Int(sender.value))
        updateTotals()
    }
    
    func StepperChange(val:Int) {
        
        HowMany.text = val.description
        
        if(val == 1){
            Slider2.isHidden = true
            Pay2.isHidden = true
            Miles2.isHidden = true
            
            Slider3.isHidden = true
            Pay3.isHidden = true
            Miles3.isHidden = true
            hm = 1
        }
        
        if(val == 2){
            Slider2.isHidden = false
            Pay2.isHidden = false
            Miles2.isHidden = false
 
            Slider3.isHidden = true
            Pay3.isHidden = true
            Miles3.isHidden = true
            hm = 2
        }
        if(val == 3){
            Slider2.isHidden = false
            Pay2.isHidden = false
            Miles2.isHidden = false
 
            Slider3.isHidden = false
            Pay3.isHidden = false
            Miles3.isHidden = false
            hm = 3
        }
        
        
    }
    
    
    @IBAction func SavrClick(_ sender: UIButton) {
        
        
        let msgStr = "This will open your schedule for " + String(hm) + " IS Extended Availability Time Slots"
        // Create Alert
        let dialogMessage = UIAlertController(title: "Confirm", message: msgStr, preferredStyle: .alert)

        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            
            //need to add save to server web call
            let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
            let h = appDelegate.hrEmpId ?? ""
            
            var isLate = "1"
            var amt = "1"
            var m2 = "15"
            var m3 = "15"
            
            if(self.isEarly == 1){
                isLate = "0"
            }else{
                amt = self.HowMany.text ?? "1"
                 m2 = String(self.Slider2Value)
                 m3 = String(self.Slider3Value)
            }
            
             
            let istdy = String(self.istoday)
            let rtDate = self.routeDate ?? ""
            let m1 = String(self.Slider1Value)
            
            
            
            
            var buildtheurl = "https://fbf2.bulwarkapp.com/fastcomm/SubmitEarlyLate.aspx?islate=" + isLate
            
            buildtheurl += "&amt=" + amt
            buildtheurl += "&istoday=" + istdy
            buildtheurl +=  "&hrempid=" + h
            buildtheurl += "&rdate=" + rtDate
            buildtheurl += "&m1=" + m1
            buildtheurl += "&m2=" + m2
            buildtheurl += "&m3=" + m3
            
            if let url = URL(string: buildtheurl) {
                do {
                    let contents = try String(contentsOf: url)
                    print(contents)
                    
                    self.view.makeToast(contents, duration: 3.0, position: CSToastPositionTop)
                    
                    
                    
                } catch {
                    // contents could not be loaded
                }
            } else {
                // the URL was bad!
            }
            
            
            
            self.dismissThis()
        })

        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            //print("Cancel button tapped")
        }

        //Add OK and Cancel button to an Alert object
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)

        // Present alert message to user
        self.present(dialogMessage, animated: true, completion: nil)
        
        
        
        
        
        
        
        

    }
    
    func dismissThis(){
        
        //if let pdfVC : viewRoutes = self.parent as? viewRoutes {
        if(fromVR == 1){
            viewRoute.webView.reload()
        }
            
            //self.removeFromParentViewController()
            //self.view.removeFromSuperview()
            self.dismiss(animated: true, completion: nil)
       // }
        
        
    }
    
    @IBAction func CancelClick(_ sender: UIButton) {
        
        print("cancel")
        dismissThis()
        
    }
    
    @IBAction func slider1Change(_ sender: UISlider) {
        
        Slider1Value = Int(sender.value)
        
        if(isEarly == 0){
        Slider2Value = Int(sender.value)
        Slider3Value = Int(sender.value)
        
        Slider2.value = Float(Int(sender.value))
        Slider3.value = Float(Int(sender.value))
        }
        
        updateTotals()
    }
    
    @IBAction func slider2Change(_ sender: UISlider) {
        
        Slider2Value = Int(sender.value)
        
        updateTotals()
    }
    
    
    
    @IBAction func Slider3Change(_ sender: UISlider) {
        
        Slider3Value = Int(sender.value)
        
        updateTotals()
    }
    
    func updateTotals(){
        
        let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                formatter.currencyCode = "usd"
                formatter.maximumFractionDigits = 2
        
        
        
        var tp:Decimal = 0
        if(hm > 0){
            var p1:Decimal = 50.0
            p1 += (Decimal(Slider1Value) - 15.0) * 0.5
            
            tp += p1
            if(isEarly == 0){
            Pay1.text = formatter.string(from: p1 as NSNumber)!
            }
            
            Miles1.text = String(Slider1Value) + " Miles"
            
        }
        if(hm > 1){
            var p2:Decimal = 50.0
            p2 += (Decimal(Slider2Value) - 15.0) * 0.5
            
            tp += p2
           
            
            Pay2.text = formatter.string(from: p2 as NSNumber)!
            Miles2.text = String(Slider2Value) + " Miles"
            
        }
        if(hm > 2){
            var p3:Decimal = 50.0
            p3 += (Decimal(Slider3Value) - 15.0) * 0.5
            
            tp += p3
           
            
            Pay3.text = formatter.string(from: p3 as NSNumber)!
            Miles3.text = String(Slider3Value) + " Miles"
            
        }
        
        
        
        
        
 
       let formatedTp =  formatter.string(from: tp as NSNumber)!
        
        
        
        TotalPay.text = "Make Up To " + formatedTp
        
        
        
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
