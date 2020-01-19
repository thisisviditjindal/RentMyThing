//
//  SellerTableViewCell.swift
//  RentMyThing
//
//  Created by vidit jindal on 14/09/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit

class SellerTableViewCell: UITableViewCell {

    @IBOutlet weak var bookname: UILabel!
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var image1: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
