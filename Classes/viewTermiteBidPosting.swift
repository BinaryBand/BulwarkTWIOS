//
//  viewTermiteBidPosting.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 4/18/23.
//

import UIKit


class viewTermiteBidPosting: UIViewController {
    
    
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
    
    
    
    var SelectedResult: String?
    var resultList = ["Sold", "Bid","Not Interested", "Missed Not Home", "Missed Other"]
    var bidTypeList = ["Bait Stations","Liquid"]
  
    @IBOutlet var isPrice: CurrencyTextField!
    
    @IBOutlet var recPrice: CurrencyTextField!
    
    @IBOutlet var resultDropDown: TWDropDown!
    
    @IBOutlet var bidDropDown: TWDropDown!
    @IBOutlet var arrivalTime: UIDatePicker!
    
    @IBOutlet var imgView: UIImageView!
    
    @IBOutlet var txtNotes: UITextView!
    
    
    @IBOutlet var btnSubmit: UIButton!
    
    @IBOutlet var btnAddImage: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        resultDropDown.optionArray = resultList
        //createPickerView()
        
        bidDropDown.optionArray = bidTypeList
        appDelegate = UIApplication.shared.delegate as? BulwarkTWAppDelegate
        
        
        txtNotes.layer.borderWidth = 1.0
        txtNotes.layer.borderColor = UIColor.lightGray.cgColor
        txtNotes.layer.cornerRadius = 4.0
        
        let arrive = DataUtilities.getArrivalTimeAsDate()
        
        if let arv = arrive{
            arrivalTime.date = arv
        }else{
            arrivalTime.date = Date()
        }
        
        
        
        // let gesture = UITapGestureRecognizer(target: self, action: #selector(openCamera))
       //    self.view.addGestureRecognizer(gesture)
        
        // Do any additional setup after loading the view.
    }
    
    
    func validateForm() ->Bool{
        
        recPrice.backgroundColor = .white
        isPrice.backgroundColor = .white
        bidDropDown.backgroundColor = .white
        resultDropDown.backgroundColor = .white
        txtNotes.backgroundColor = .white
        
        btnAddImage.tintColor = .link
        
        
        let result = resultDropDown.text ?? ""
        let type = bidDropDown.text ?? ""
        let isp = isPrice.amountAsDouble ?? 0
        let rp = recPrice.amountAsDouble ?? 0
        let notes = txtNotes.text ?? ""
        let imgSize = imgView.image?.size
        var isvalid = true
        
        if result == "" {
            isvalid = false
            resultDropDown.backgroundColor = .red
        }else{
           
        
            
            
            if result == "Bid" || result == "Sold" {
            
            
            
                if type == "" {
                    isvalid = false
                    bidDropDown.backgroundColor = .red
                }
                        
                if isp <= 0 {
                    isvalid = false
                    isPrice.backgroundColor = .red
                }
                
                if rp <= 0 {
                    isvalid = false
                    recPrice.backgroundColor = .red
                }
                
                if imgSize?.width == 31.5{
                    btnAddImage.tintColor = .red
                    isvalid = false
                }
                
            }
            
        if result == "Missed Other" {
            if notes == ""{
                isvalid = false
                txtNotes.backgroundColor = .red
            }
        }
            
            
        }
        
        return isvalid
    }
    
    
    @IBAction func btnAddImage(_ sender: Any) {
        
        btnAddImage.tintColor = .link
        openCamera()
        
        
    }

    
    
    @IBAction func resultediting(_ sender: Any) {
        
        resultDropDown.backgroundColor = .white
        
        
        
    }
    
    @IBAction func recdidedit(_ sender: Any) {
        
        recPrice.backgroundColor = .white
    }
    
    @IBAction func bidediting(_ sender: Any) {
        bidDropDown.backgroundColor = .white
        
    }
    
    @IBAction func ispriceediting(_ sender: Any) {
        isPrice.backgroundColor = .white
    }
    

    @IBAction func notesEditing(_ sender: Any) {
        
        txtNotes.backgroundColor = .white
    }
    
    
    @IBAction func btnSubmit(_ sender: Any) {
        
        
        if validateForm() {
            
        
        
        
        var tmpurlstr = "https://ipadapp.bulwarkapp.com?" + urlParams
        
       
        if let urlComponent = URLComponents(string: tmpurlstr) {
            // queryItems is an array of "key name" and "value"
            let queryItems = urlComponent.queryItems
            // to find "success" value, we need to find based on key name
            let wos = queryItems?.first(where: { $0.name == "routestopid" })?.value ?? "0"
            let wo = Int(wos) ?? 0
            
            let account = queryItems?.first(where: { $0.name == "accountnumber" })?.value ?? "0"
            
            
            let wois = queryItems?.first(where: { $0.name == "workorderitem_id"})?.value ?? "0"
            let woi = Int(wois) ?? 0
            
            let st = queryItems?.first(where: { $0.name == "servicetypecode" })?.value ?? ""
            
        
        
        
        //let st = "TTI"
        //let wo = 12457
        let base64 = imgView.image?.jpegData(compressionQuality: 0.2)?.base64EncodedString() ?? ""
        let result = resultDropDown.text ?? ""
        let type = bidDropDown.text ?? ""
        let isp = isPrice.amountAsDouble ?? 0
        let rp = recPrice.amountAsDouble ?? 0
        let notes = txtNotes.text ?? ""
        
            var postbiddata = false
            
        let encodednotes = notes.toBase64()
        
            let h = hrEmpId ?? "123456"
        
            var sresult = "MissedNH"
            
            if result == "Sold"{
                sresult = "Serviced"
                postbiddata = true
            }
            if result == "Bid"{
                sresult = "Serviced"
                postbiddata = true
            }
            if result == "Not Interested"{
                sresult = "Serviced"
                postbiddata = false
            }
            if result == "Missed Other"{
                sresult = "MissedO"
            }
            
            let timein = arrivalTime.date.toString(format: .custom("HH:mm")) ?? "00:00"
            let spnameA = appDelegate.name ?? ""
            let splicA = appDelegate.license ?? ""
            let spname = spnameA.replacingOccurrences(of: " ", with: "%20")
            let splic = splicA.replacingOccurrences(of: " ", with: "%20")
            
       // let bd = TermiteBid(workOrderId: wo, serviceType: st, hrempid: hrEmpId, mediaBase64: base64, status: result, address: "")
        
        let bd = TermiteBid(rollingKey: "", workOrderId: wo, serviceType: st, hrEmpId: hrEmpId, mediaBase64: base64, status: result, address: "", bidType: type, isPrice: isp, recPrice: rp, notes: notes)
        
            
            
            let bidurlA = "https://ipadapp.bulwarkapp.com/submitResults.aspx?Invoice=" + wois + "&AccountNumber=" + account + "&ResultSelect=" + sresult + "&hr_emp_id=" + h
            
            let bidurlB = bidurlA + "&Amount=0&Check=0&Comments=BaseData" + encodednotes + "&Route_id=" + wos + "&radPayment=&timein=" + timein
           
            
            let bidurl = bidurlB + "&ticketData=BaseData=&techname=" + spname + "&licnum=" + splic + "&workorderitem_id=" + wois
            
            
            let av = appDelegate.appBuild ?? "none"
            let obdDate = appDelegate.lastObdRead.toString(format: .usDateTime24WithSec) ?? "1/1/1900"
            
            let tc = appDelegate.obdTroubleCodes ?? ""
            
            let saveResults = DataUtilities.SavePostingResults(UrlToStave: bidurl, Lat: appDelegate.lat, Lon: appDelegate.lon, Vin: appDelegate.vin, Odometer: appDelegate.odo, OdoLastUpdated: obdDate, Rdate: rs.rdate, appversion: av, troubleCode: tc)
            
            if saveResults == true {
                
                
           
            
            
            
        Task{
            do {
                self.view.makeToastActivity(.center)
                
                if postbiddata{
                    _ = try await JsonFetcher.postTermiteBid(bidData: bd)
                    
                }
                
                _ = try await JsonFetcher.SendPostingResultsAsync(hrEmpId: h)
                
                performSegue(withIdentifier: "unwindToDash", sender: self)
                self.view.hideToastActivity()
            }catch{
                print(error)
                self.view.hideToastActivity()
            }
        }
        }
            
        }else{
            //error with params
        }
            
        }
        
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
extension viewTermiteBidPosting: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @objc func openCamera() {
       let imgPicker = UIImagePickerController()
       imgPicker.delegate = self
        imgPicker.sourceType = .camera
       imgPicker.allowsEditing = false
       imgPicker.showsCameraControls = true
       self.present(imgPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey :Any]) {
       //if let img = info[UIImagePickerController.InfoKey.editedImage] as?
      // UIImage {
      //       self.imgView.image = img
      //       self.dismiss(animated: true, completion: nil)
       //   }
       //   else {
       //      print("error")
       //  }
        
        self.dismiss(animated: true, completion: nil)
        let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imgView.image = img //img?.scale(newWidth: 640)
        
        //let imgData = NSData(data: (img?.jpegData(compressionQuality: 0.5)!)!)
        //var imageSize: Int = imgData.count
        //print("actual size of image in KB: %f ", Double(imageSize) / 1000.0)
        
        imgView.contentMode = .scaleAspectFit
        
       }
    
}

extension UIImage
{
    func scale(newWidth: CGFloat) -> UIImage
    {
        guard self.size.width != newWidth else{return self}
        
        print(self.size.width)
        
        let scaleFactor = newWidth / self.size.width
        
        let newHeight = self.size.height * scaleFactor
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        return newImage ?? self
    }
}
