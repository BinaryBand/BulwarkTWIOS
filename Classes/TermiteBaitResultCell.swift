//
//  TermiteBaitResultCell.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 7/17/23.
//

import UIKit

class TermiteBaitResultCell: UITableViewCell {


    @IBOutlet var Title: UILabel!
    
    @IBOutlet var Result: UILabel!
    
    @IBOutlet var CheckedAt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
