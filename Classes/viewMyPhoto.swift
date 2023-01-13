//
//  viewMyPhoto.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 1/4/23.
//

import UIKit

class viewMyPhoto: UIViewController {

    var TakenBy: String?
    var TakenOn: String?
    var Rating:Int?
    var Office1:String?
    var img:UIImage?
    var MediaUrl:String?
    
    @IBOutlet var image:UIImageView!
    
    @IBOutlet var star1:UIImageView!
    @IBOutlet var star2:UIImageView!
    @IBOutlet var star3:UIImageView!
    @IBOutlet var star4:UIImageView!
    @IBOutlet var star5:UIImageView!
    
    @IBOutlet var office:UILabel?
    @IBOutlet var ServicePro:UILabel?
    @IBOutlet var Date:UILabel?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        star1.isHidden = true
        star2.isHidden = true
        star3.isHidden = true
        star4.isHidden = true
        star5.isHidden = true
        
        
        if let rating = Rating{
            
 
        if(rating == 5){
            
            star1.isHidden = false
            star2.isHidden = false
            star3.isHidden = false
            star4.isHidden = false
            star5.isHidden = false
            
            
            
        }
        
        if(rating == 4){
            
            star1.isHidden = false
            star2.isHidden = false
            star3.isHidden = false
            star4.isHidden = false
      
        }
        if(rating == 3){
            
            star1.isHidden = false
            star2.isHidden = false
            star3.isHidden = false
     
        }
        if(rating == 2){
            
            star1.isHidden = false
            star2.isHidden = false

        }
        if(rating == 1){
            
            star1.isHidden = false

        }
            
        }
        
        //office?.text = Office1
        //ServicePro?.text = TakenBy
        Date?.text = TakenOn
        
        
        Task {
            
            do {
                
                self.view.makeToastActivity(.center)
                
                let img = try await JsonFetcher.fetchPhotoAsync(urlStr: MediaUrl!)
                
             
                image.image = img
                
               
                self.view.hideToastActivity()
                

                
                
            } catch {
                print("Request failed with error: \(error)")
            }
            
            
            
            
            
        }
        
        
     
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func bnSubmitForReview(_ sender: Any) {
        
        // Create Alert
        var dialogMessage = UIAlertController(title: "Confirm", message: "Submit this photo for review and entry into Photo Lotto?", preferredStyle: .alert)

        // Create OK button with action handler
        let ok = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
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
    
}
