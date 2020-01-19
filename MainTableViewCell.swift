//
//  MainTableViewCell.swift
//  
//
//  Created by vidit jindal on 29/06/18.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    var delegate:MyCustomCellDelegator!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var see: UIButton!
    
    @IBAction func see1(_ sender: Any) {
        if delegate != nil {
            self.delegate.callSegueFromCell(myData: name.text!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
