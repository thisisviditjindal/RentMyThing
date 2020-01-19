//
//  NotificationTableViewCell.swift
//  RentMyThing
//
//  Created by vidit jindal on 11/11/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet var dateofnot: UILabel!
    @IBOutlet var description1: UILabel!
    @IBOutlet var productimage: Image1!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
