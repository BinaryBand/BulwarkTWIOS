//
//  viewPhoto.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 1/3/23.
//

import UIKit

class viewPhoto: UIViewController {

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
        
        
        if(Rating == 5){
            
            star1.isHidden = false
            star2.isHidden = false
            star3.isHidden = false
            star4.isHidden = false
            star5.isHidden = false
            
            
            
        }
        
        if(Rating == 4){
            
            star1.isHidden = false
            star2.isHidden = false
            star3.isHidden = false
            star4.isHidden = false
      
        }
        if(Rating == 3){
            
            star1.isHidden = false
            star2.isHidden = false
            star3.isHidden = false
     
        }
        if(Rating == 2){
            
            star1.isHidden = false
            star2.isHidden = false

        }
        if(Rating == 1){
            
            star1.isHidden = false

        }
        
        
        office?.text = Office1
        ServicePro?.text = TakenBy
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
    
    
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue){
           
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
