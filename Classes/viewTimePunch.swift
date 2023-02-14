//
//  viewTimePunch.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 2/3/23.
//

import UIKit

protocol TimePunchDelegate:AnyObject{
    func TimePunchSaved(timePunch: String, isIn: Bool)

}


class viewTimePunch: UIViewController {

    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var lblSubTitle: UILabel!
    
    @IBOutlet var dtPunchTime: UIDatePicker!
    var direction: Int = 1
    var hrempid:String!
    
    static var delegate : TimePunchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        let currdate = Date();
        let lastPunch = DataUtilities.getLastTimePunch()
        let isInToday = lastPunch.isIn
        
       
       
        let currcomponents = Calendar.current.dateComponents([.day,.month,.year], from: currdate)
        let lastcompinents = Calendar.current.dateComponents([.day,.month,.year], from: lastPunch.punchTime)
        
        if currcomponents.day == lastcompinents.day && currcomponents.month == lastcompinents.month && currcomponents.year == lastcompinents.year{
            
            
            var components = DateComponents()
            components.day = currcomponents.day
            components.month = currcomponents.month
            components.year = currcomponents.year
            components.hour = 0
            components.minute = 0
            components.second = 0
            let minDate = Calendar.current.date(from: components)!
            var dc = DateComponents()
            dc.day  = 1
            let maxdate = Calendar.current.date(byAdding: dc, to: minDate)
            
            
            if isInToday{
                direction = 2
                lblTitle.text = "Clock Out"
                lblSubTitle.text = "Select the time you completed working."
                lblTitle.textColor = .blue
                
                dtPunchTime.minimumDate = lastPunch.punchTime
                dtPunchTime.maximumDate = maxdate
            } else{
                direction = 1
                lblTitle.text = "Clock In"
                lblSubTitle.text = "Select the time you started working."
                lblTitle.textColor = .blue
                dtPunchTime.minimumDate = lastPunch.punchTime
                dtPunchTime.maximumDate = Date()
               
            }
 
        }else{
            if isInToday{
                //clocked in but not out
                lblSubTitle.text = "you clocked in yesterday but not out please ender a clock out time for yesterday then clock in"
                lblTitle.text = "CLOCK OUT ERROR"
                lblTitle.textColor = .red
                direction = 2
                var components = DateComponents()
                components.day = lastcompinents.day
                components.month = lastcompinents.month
                components.year = lastcompinents.year
                components.hour = 0
                components.minute = 0
                components.second = 0
                let minDate = Calendar.current.date(from: components)!
                var dc = DateComponents()
                dc.day  = 1
                let maxdate = Calendar.current.date(byAdding: dc, to: minDate)
                
                dtPunchTime.minimumDate = lastPunch.punchTime
                dtPunchTime.maximumDate = maxdate
                
                
                
                
                
                
            }else{
                lblSubTitle.text = "Select the time you started working."
                lblTitle.text = "Clock In"
                //lblTitle.textColor = .red
                direction = 1
                var components = DateComponents()
                components.day = currcomponents.day
                components.month = currcomponents.month
                components.year = currcomponents.year
                components.hour = 0
                components.minute = 0
                components.second = 0
                let minDate = Calendar.current.date(from: components)!
                var dc = DateComponents()
                dc.day  = 1
                //let maxdate = Calendar.current.date(byAdding: dc, to: minDate)
                
                dtPunchTime.minimumDate = minDate
                dtPunchTime.maximumDate = Date()
            }
        }
        
        
        
    }

    
    @IBAction func btnSaveClick(_ sender: Any) {
        
        
        let dt = dtPunchTime.date
        
        let dir = direction
        
        if dir == 1{
            let s =  DataUtilities.saveTimePunch(punch: dt, isIn: true, hrempid: hrempid)
            viewTimePunch.delegate?.TimePunchSaved(timePunch: s, isIn: true)
        }else{
            let s =  DataUtilities.saveTimePunch(punch: dt, isIn: false, hrempid: hrempid)
            viewTimePunch.delegate?.TimePunchSaved(timePunch: s, isIn: false)
        }
        
        self.dismiss(animated: true)
        
        
        
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
