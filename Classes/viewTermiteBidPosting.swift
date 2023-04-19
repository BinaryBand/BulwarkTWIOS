//
//  viewTermiteBidPosting.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 4/18/23.
//

import UIKit


class viewTermiteBidPosting: UIViewController {
    var SelectedResult: String?
    var resultList = ["Sold", "Bid", "Missed Not Home", "Missed Other"]
    var bidTypeList = ["Bait Stations","Liquid"]
  
    @IBOutlet var isPrice: CurrencyTextField!
    
    @IBOutlet var recPrice: CurrencyTextField!
    
    @IBOutlet var resultDropDown: TWDropDown!
    
    @IBOutlet var bidDropDown: TWDropDown!
    @IBOutlet var arrivalTime: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultDropDown.optionArray = resultList
        //createPickerView()
        
        bidDropDown.optionArray = bidTypeList
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
  /*  func result_onSelect(selectedText: String) {
        if selectedText == "" {
            print("Hello World")
        } else if selectedText == "Mr." {
            print("Hello Sir")
        } else {
            print("Hello Madame")
        }
    }}

*/
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

