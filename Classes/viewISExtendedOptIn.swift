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
    
    @objc var DateFor:String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Slider2.isHidden = true
        Pay2.isHidden = true
        Miles2.isHidden = true
        
        Slider3.isHidden = true
        Pay3.isHidden = true
        Miles3.isHidden = true

       // Pay1.text = "test"
      //  btnSave.isHidden = true
        
 
        // Do any additional setup after loading the view.
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
 
        }
        
        if(val == 2){
            Slider2.isHidden = false
            Pay2.isHidden = false
            Miles2.isHidden = false
 
            Slider3.isHidden = true
            Pay3.isHidden = true
            Miles3.isHidden = true
            
        }
        if(val == 3){
            Slider2.isHidden = false
            Pay2.isHidden = false
            Miles2.isHidden = false
 
            Slider3.isHidden = false
            Pay3.isHidden = false
            Miles3.isHidden = false
            
        }
        
        
    }
    
    
    @IBAction func SavrClick(_ sender: UIButton) {
        
        print("save")
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
