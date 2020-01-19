//
//  YourbookTableViewCell.swift
//  RentMyThing
//
//  Created by vidit jindal on 03/08/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit

class YourbookTableViewCell: UITableViewCell {

    @IBOutlet weak var imagev: UIImageView!
    @IBOutlet weak var bookname: UILabel!
    @IBOutlet weak var bookgenre: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
