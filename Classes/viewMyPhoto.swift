//
//  viewMyPhoto.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 1/4/23.
//

import UIKit

protocol MyPhotoDelegate: AnyObject{
    func PhotoSubmittedAsCreative(PhotoId: String)
    
    
}


class viewMyPhoto: UIViewController {

    static var delegate: MyPhotoDelegate?
    
    var TakenBy: String?
    var TakenOn: String?
    var Rating:Int?
    var Office1:String?
    var img:UIImage?
    var MediaUrl:String?
    var PhotoId:String?
    var alreadySubmitted:Bool?
    
    
    @IBOutlet var image:UIImageView!
    
    @IBOutlet var star1:UIImageView!
    @IBOutlet var star2:UIImageView!
    @IBOutlet var star3:UIImageView!
    @IBOutlet var star4:UIImageView!
    @IBOutlet var star5:UIImageView!
    
    @IBOutlet var office:UILabel?
    @IBOutlet var ServicePro:UILabel?
    @IBOutlet var Date:UILabel?
    
    @IBOutlet var btnSubmitCreative: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        star1.isHidden = true
        star2.isHidden = true
        star3.isHidden = true
        star4.isHidden = true
        star5.isHidden = true
        
        
        if let asub = alreadySubmitted{
            if asub {
                btnSubmitCreative.isHidden = true;
            }
        }
        
        if let rating = Rating{
            
 
        if(rating == 5){
            
            star1.isHidden = false
            star2.isHidden = false
            star3.isHidden = false
            star4.isHidden = false
            star5.isHidden = false
            
            btnSubmitCreative.isHidden = true;
            
        }
        
        if(rating == 4){
            
            star1.isHidden = false
            star2.isHidden = false
            star3.isHidden = false
            star4.isHidden = false
            btnSubmitCreative.isHidden = true;
        }
        if(rating == 3){
            
            star1.isHidden = false
            star2.isHidden = false
            star3.isHidden = false
            btnSubmitCreative.isHidden = true;
        }
        if(rating == 2){
            
            star1.isHidden = false
            star2.isHidden = false
            btnSubmitCreative.isHidden = true;
        }
        if(rating == 1){
            
            star1.isHidden = false
            btnSubmitCreative.isHidden = true;
        }
            
        }
        
        //office?.text = Office1
        //ServicePro?.text = TakenBy
        Date?.text = TakenOn
        
        
        if let photoImg = img{
            
            
            image.image = photoImg
            
        }else{
            Task {
                self.view.makeToastActivity(.center)
                do {
                    
                    
                    let imgn = try await JsonFetcher.fetchPhotoAsync(urlStr: MediaUrl!)
                                        
                    
                    Utilities.delay(bySeconds: 0.4, dispatchLevel: .main){
                        
                      
                        
                        self.image.image = imgn
                        
                        
                        self.view.hideToastActivity()
                    }
                    
                    
                } catch {
                    print("Request failed with error: \(error)")
                }
                
                
                
                
                
            }
            
        }
        

        
     
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func bnSubmitForReview(_ sender: Any) {
        
        // Create Alert
        let dialogMessage = UIAlertController(title: "Confirm", message: "Submit this photo for review and entry into Photo Lotto?", preferredStyle: .alert)

        // Create OK button with action handler
        let ok = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            
            
            Task{
                self.view.makeToastActivity(.center)
                do{
                    if let pid = self.PhotoId{
                        
                        _ = try await JsonFetcher.submitCreativePhoto(creativePhotoId: pid)
                        viewMyPhoto.delegate?.PhotoSubmittedAsCreative(PhotoId: pid)
                        self.view.makeToast("Submitted Successfully", duration: 3.0)
                        self.dismiss(animated: true)
                    }else{
                        self.view.makeToast("Error Submitting try again", duration: 4.0)
                    }
                    
                    
                }catch{
                    self.view.makeToast("Error Submitting try again", duration: 4.0)
                    print(error)
                }
                self.view.hideToastActivity()
            }
            
            
            
            
        })

        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "No", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }

        //Add OK and Cancel button to an Alert object
        dialogMessage.addAction(cancel)
        dialogMessage.addAction(ok)
       

        // Present alert message to user
        self.present(dialogMessage, animated: true, completion: nil)
        
        
    }
    
    @IBAction func closePage(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
