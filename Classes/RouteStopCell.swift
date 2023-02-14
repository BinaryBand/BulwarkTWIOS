//
//  RouteStopCell.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 10/24/22.
//

import UIKit

class RouteStopCell: UITableViewCell {

    @IBOutlet var lblServiceType: UILabel!
    
    @IBOutlet var lblTimeBlock: UILabel!
    
    @IBOutlet var lblExtArrival: UILabel!
    
    @IBOutlet var lblAccount: UILabel!
    
    @IBOutlet var lblName: UILabel!
    
    @IBOutlet var lblContacted: UILabel!
    
    @IBOutlet var lblRedAlert: UILabel!
    
    @IBOutlet var lblBlueAlert: UILabel!
    
    @IBOutlet var lblTopBorder: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
