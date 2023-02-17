//
//  viewMapToggles.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 2/15/23.
//

import UIKit
protocol MapToggleDelegate: AnyObject{
    func toggleProactive(isOn: Bool)
    func toggleCancels(isOn: Bool)
    func toggleCancelRequests(isOn: Bool)
    func toggleMapType(isOn: Bool)
    
}

class viewMapToggles: UIViewController {

    @IBOutlet var tglProactive: DesignableUISwitch!
    
    static var delegate: MapToggleDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    @IBAction func didToggleProactive(_ sender: UISwitch) {
        
        viewMapToggles.delegate?.toggleProactive(isOn: sender.isOn)
        
    }
    
    
    
    @IBAction func didToggleCancels(_ sender: UISwitch) {
        
        viewMapToggles.delegate?.toggleCancels(isOn: sender.isOn)
        
        
    }
    
    
    @IBAction func didToggleCancelRequest(_ sender: UISwitch) {
        
        viewMapToggles.delegate?.toggleCancelRequests(isOn: sender.isOn)
        
    }
    
    
    @IBAction func didToggleMapType(_ sender: UISwitch) {
        
        viewMapToggles.delegate?.toggleMapType(isOn: sender.isOn)
        
    }
    
    
}
