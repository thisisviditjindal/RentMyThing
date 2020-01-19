//
//  WishListTableViewCell.swift
//  RentMyThing
//
//  Created by vidit jindal on 20/08/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class WishListTableViewCell: UITableViewCell {
    var wished = true
    @IBOutlet var Availablity: UILabel!
    @IBOutlet var bookname: UILabel!
    @IBOutlet var bookimage: UIImageView!
    @IBOutlet var wishbutton: UIButton!
    @IBOutlet var label: UILabel!
    @IBOutlet var label2: UILabel!
    
    @IBAction func wishit(_ sender: Any) {
        if Auth.auth().currentUser != nil{
            wishbutton.isHidden = false
            if wished{
                wishbutton.setImage(#imageLiteral(resourceName: "wishlist-2"), for: UIControl.State.normal)
                let value = ["Book Image": self.label.text, "Book Seller": self.label2.text]
                Database.database().reference().child("WishList").child((Auth.auth().currentUser?.uid)!).childByAutoId().setValue(value)
                self.wished = false
            }
            else {
                wishbutton.setImage(#imageLiteral(resourceName: "wishlist copy"), for: UIControl.State.normal)
                Database.database().reference().child("WishList").child((Auth.auth().currentUser?.uid)!).queryOrdered(byChild: "Book Image").queryEqual(toValue: self.label.text).observe(DataEventType.childAdded) { (snap) in
                    snap.ref.removeValue()
                    Database.database().reference().child("WishList").child((Auth.auth().currentUser?.uid)!).queryOrdered(byChild: "Book Image").queryEqual(toValue: self.label.text).removeAllObservers()
                }
                wished = true
            }
        }
        else {
            wishbutton.isHidden = true
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
