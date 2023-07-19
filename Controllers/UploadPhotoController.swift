//
//  UploadPhotoController.swift
//  BulwarkTW
//
//  Created by Shane Davenport on 7/19/23.
//

import UIKit

class UploadPhotoController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var uploadImageButton: UIImageView!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UploadPhotoController.tappedMe))
        uploadImageButton.addGestureRecognizer(tap)
        uploadImageButton.isUserInteractionEnabled = true
    }
    
    @objc func tappedMe() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }

        uploadImageButton.isHidden = true
        imagePreview.image = image
        nextButton.isEnabled = true
    }
    
    

}
