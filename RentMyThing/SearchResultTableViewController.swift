//
//  SearchResultTableViewController.swift
//  RentMyThing
//
//  Created by vidit jindal on 16/08/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class SearchResultTableViewController: UITableViewController {
    var name = ""
    var image = ""
    var wished = false
    var index = 0
    var bookdetails = [DataSnapshot]()
    override func viewDidLoad() {
        super.viewDidLoad()
        Database.database().reference().child("Email").queryOrdered(byChild: "Are you seller").queryEqual(toValue: true).observe(DataEventType.childAdded) { (snap) in
            if let dic = snap.value as? [String: Any] {
                if let email = dic["uid"] as? String {
                    Database.database().reference().child("Seller Inventory").child(email).queryOrdered(byChild: "Book Name").queryEqual(toValue: self.name).observe(DataEventType.childAdded, with: { (snap1) in
                        self.bookdetails.append(snap1)
                        self.tableView.reloadData()
                    })
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dic = bookdetails[indexPath.row].value as? [String: Any] {
            if let image1 = dic["Book Image"] as? String {
                self.image = image1
                print(self.image)
                print(image1)
            }
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.bookdetails.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? SearchResultTableViewCell
        if let dic = bookdetails[indexPath.row].value as? [String: Any] {
            if let image1 = dic["Book Image"] as? String {
                if let genre = dic["Book Genre"] as? String {
                    if let cond = dic["Book Condition"] as? String {
                        if let seller = dic["Book Seller"] as? String {
                            if Auth.auth().currentUser != nil {
                               self.image = image1
                                Database.database().reference().child("WishList").child((Auth.auth().currentUser?.uid)!).queryOrdered(byChild: "Book Image").queryEqual(toValue: image1).observe(DataEventType.childAdded) { (snap) in
                                    if snap.exists(){
                                        cell?.wishbutton.setImage(#imageLiteral(resourceName: "wishlist-2"), for: UIControl.State.normal)
                                        cell?.wished = false
                                    }
                                    else {
                                        cell?.wishbutton.setImage(#imageLiteral(resourceName: "wishlist copy"), for: UIControl.State.normal)
                                        cell?.wished = true
                                    }
                                }
                            }
                            else {
                                cell?.wishbutton.isHidden = true
                            }
                            cell?.bookimage?.sd_setImage(with: URL(string: self.image), completed: nil)
                            cell?.bookname.text = self.name
                            cell?.bookgenre.text = genre
                            cell?.bookcondition.text = cond
                            cell?.label.text = image1
                            cell?.label2.text = seller
                        }
                    }
                }
            }
        }
        return cell!
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searching" {
            if let dest = segue.destination as? SellerNearYouTableViewController {
                dest.name = self.image
                dest.index = self.index
                print(self.image)
            }
        }
        else if segue.identifier == "search" {
            if let nav = segue.destination as? UINavigationController {
                if let dest = nav.topViewController as? SearchTableViewController {
                    dest.index = self.index
                }
            }
        }
    }
}
