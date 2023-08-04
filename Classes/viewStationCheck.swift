//
//  viewStationCheck.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 7/11/23.
//

import UIKit
import MapKit

protocol StationCheckDelegate: AnyObject{
    
    func didUpdateStationCheck(stationInfo: StationCheck)
    
    
}

class viewStationCheck: UIViewController {
    
    static var delegate:StationCheckDelegate?
    
    var appDelegate:BulwarkTWAppDelegate!
    
    var resultList = ["No Activity", "Replaced 1 Bait Cartrage", "Replaced 2 Bait Cartrages","Missing Station Replaced"]
    
    var stationId:Int = 0
    
    @IBOutlet var resultDropDown: TWDropDown!
    @IBOutlet var btnAddImage: UIButton!
    
    @IBOutlet var imgView: UIImageView!
    
    @IBOutlet var txtTimeIn: UITextField!
    
    @IBOutlet var dtTimeChecked: UIDatePicker!
    @IBOutlet var lblBarcode: UILabel!
    @IBOutlet var arrowImageView: UIImageView!
    @IBOutlet var lblDistance: UILabel!
    
    var stationData:StationCheck?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        resultDropDown.optionArray = resultList
        appDelegate = UIApplication.shared.delegate as? BulwarkTWAppDelegate
        viewScanBarcode.delegate = self
        
        let sd = stationData
        let bar = sd?.barcode
        resultDropDown.text = stationData?.result
        
        if stationData?.photoBase64 != ""{
            let dataDecoded : Data = Data(base64Encoded: stationData!.photoBase64, options: .ignoreUnknownCharacters)!
            let decodedimage = UIImage(data: dataDecoded)
            imgView.image = decodedimage
            imgView.contentMode = .scaleAspectFit
        }
        
        
        
        if let isnew = stationData?.isNew {
            if isnew{
                resultList.insert("Installed New Station", at: 0)
                if stationData?.result == ""{
                    resultDropDown.text = "Installed New Station"
                    stationData?.result = "Installed New Station"
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        
        let res = resultDropDown.text ?? ""
      
            stationData?.result = res
      
        let tc = dtTimeChecked.date.timeIntervalSince1970
        
        stationData?.timeChecked = tc
        
        viewStationCheck.delegate?.didUpdateStationCheck(stationInfo: stationData!)
    }
    
    
    @IBAction func btnClickScanBarcode(_ sender: Any) {
        
        let customView = self.storyboard?.instantiateViewController(withIdentifier: "viewScanBarcode") as? viewScanBarcode
        
        customView?.modalTransitionStyle = .crossDissolve
        customView?.modalPresentationStyle = .pageSheet
        
        self.present(customView!,animated:true, completion:nil)
        
        
    }
    
    @IBAction func btnClickTakePhoto(_ sender: Any) {
        
        openCamera()
    }
    
    
    
    func didUpdateLocationOfUser(userLoc: MKUserLocation){
        
        let stationcoord = CLLocationCoordinate2D(latitude: stationData!.lat, longitude: stationData!.lon)
        
        //let rotation = userLoc.coordinate.bearing(to: stationcoord)
        
        //let newRad =  userLoc.heading!.trueHeading * Double.pi/180
        
        let degrees = calUserAngle(here: userLoc.coordinate)
        
        
        //let c = userLoc.location?.course ?? 0
        
        let c = userLoc.heading?.magneticHeading ?? 0
                let rot = CGFloat((degrees - c) * .pi/180)
        
        let accuracy = userLoc.location?.horizontalAccuracy ?? 0
        //let numsat = userLoc.location.accu
        
        let dist = Utilities.haversineFeet(lat1: stationcoord.latitude, lon1: stationcoord.longitude, lat2: userLoc.coordinate.latitude, lon2: userLoc.coordinate.longitude)
        Utilities.delay(bySeconds: 0.2,dispatchLevel: .main , closure: {
            if accuracy < 5{
                // UIView.animate(withDuration:0.3){
                self.arrowImageView.isHidden = true
                self.arrowImageView.transform = CGAffineTransform(rotationAngle: rot)
                // }
                self.lblDistance.text = dist.toNumberString(decimalPlaces: 0) + "ft-" + accuracy.toNumberString(decimalPlaces: 1)
                self.lblDistance.isHidden = false
            }else{
                self.arrowImageView.isHidden = true
                self.lblDistance.isHidden = true
            }
        })
       
        
        
    }
    

    func calUserAngle(here: CLLocationCoordinate2D) -> Double {

                    var x = 0.0
                    var y = 0.0
                    var delLon = 0.0

                    //Tokio Coords
                    let tokioLat = stationData!.lat
                    let tokioLon = stationData!.lon

                    delLon = tokioLon - here.longitude
                    y = sin(delLon) * cos(tokioLat);
                    x = cos(here.latitude) * sin(tokioLat) - sin(here.latitude) * cos(tokioLat) * cos(delLon)

                    let theAngleInRad = atan2(y, x)
                    var theAngleInDeg = theAngleInRad * (180 / .pi)

                    if(theAngleInDeg < 0){
                        theAngleInDeg = -theAngleInDeg
                    } else {
                        theAngleInDeg = 360 - theAngleInDeg
                    }

                    //degress is my Double var
                    return theAngleInDeg - 90
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
extension viewStationCheck: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
        let base64 = imgView.image?.jpegData(compressionQuality: 0.25)?.base64EncodedString() ?? ""
        //let imgData = NSData(data: (img?.jpegData(compressionQuality: 0.5)!)!)
        //var imageSize: Int = imgData.count
        //print("actual size of image in KB: %f ", Double(imageSize) / 1000.0)
        stationData?.photoBase64 = base64
        
        
        imgView.contentMode = .scaleAspectFit
        
       }
    
}
extension viewStationCheck: ScanBarcodeDelegate{
    func didScanBarcode(barcode: String) {
        lblBarcode.text = "Barcode: " + barcode
        stationData?.barcode = barcode
    }
    
    
    
}
