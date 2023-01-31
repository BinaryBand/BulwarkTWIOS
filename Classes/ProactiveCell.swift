//
//  ProactiveCell.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 1/30/23.
//

import UIKit

class ProactiveCell: UITableViewCell {

    @IBOutlet var viewTitle: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblMiles: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblLastService: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
