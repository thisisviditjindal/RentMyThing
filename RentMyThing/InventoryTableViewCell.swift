//
//  InventoryTableViewCell.swift
//  RentMyThing
//
//  Created by vidit jindal on 02/07/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit

class InventoryTableViewCell: UITableViewCell {
    @IBOutlet weak var booklabel: UILabel!
    @IBOutlet weak var bookimage: UIImageView!
    @IBOutlet weak var booksel: UILabel!
    @IBOutlet weak var bookbuy: UILabel!
    @IBOutlet weak var norented: UILabel!
    @IBOutlet weak var noofbooksold: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
