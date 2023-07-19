//
//  NewTrapController.swift
//  BulwarkTW
//
//  Created by Shane Davenport on 7/19/23.
//

import UIKit
import CoreImage

class NewTrapController: UIViewController {
    
    var code: String?
    
    @IBOutlet weak var barcodeText: UILabel!
    @IBOutlet weak var barcodeImage: UIImageView!
    @IBOutlet weak var openCameraStack: UIStackView!
    @IBOutlet weak var openCameraImage: UIImageView!
    @IBOutlet weak var continueButton: UIButton!
    
    let scannerViewController = ScannerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scannerViewController.delegate = self
        
        let cameraTap = UITapGestureRecognizer(target: self, action: #selector(NewTrapController.onButtonClick))
        openCameraImage.addGestureRecognizer(cameraTap)
        openCameraImage.isUserInteractionEnabled = true
    }
    
    @objc func onButtonClick() {
        self.present(scannerViewController, animated: true)
    }

}

extension UIImage {

    convenience init?(barcode: String?) {
        let data = (barcode ?? "None").data(using: .ascii)
        guard let filter = CIFilter(name: "CICode128BarcodeGenerator") else {
            return nil
        }
        filter.setValue(data, forKey: "inputMessage")
        guard let ciImage = filter.outputImage else {
            return nil
        }
        self.init(ciImage: ciImage)
    }

}

@objc protocol ScannerViewDelegate: AnyObject {
    @objc func didFindScannedText(text: String)
}

extension NewTrapController: ScannerViewDelegate {
    func didFindScannedText(text: String) {
        
        self.code = text
        
        let barcode = UIImage(barcode: code)
        barcodeImage.image = barcode
        barcodeText.text = code
        
        openCameraStack.isHidden = true
        continueButton.isEnabled = true
    }
}
