//
//  WishListTableViewController.swift
//  RentMyThing
//
//  Created by vidit jindal on 20/08/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class WishListTableViewController: UITableViewController {
    var data = [String]()
    var rented = true
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        if index == -3 {
            let button = UIBarButtonItem(image: #imageLiteral(resourceName: "backward-arrow"), style: UIBarButtonItem.Style.done, target: self, action: #selector(back))
            self.navigationItem.leftBarButtonItem = button
            self.navigationItem.leftBarButtonItem?.imageInsets.left = -9
        }
        if Auth.auth().currentUser != nil {
            self.index = 0
        }
        else {
            self.index = -1
        }
        Database.database().reference().child("Email").queryOrdered(byChild: "uid").queryEqual(toValue: Auth.auth().currentUser?.uid).observe(DataEventType.childAdded) { (snap) in
            if let dic = snap.value as? [String: Any] {
                if let email = dic["uid"] as? String {
                    Database.database().reference().child("WishList").child(email).observe(DataEventType.childAdded, with: { (snap1) in
                        if let dic = snap1.value as? [String: String]{
                            if let image = dic["Book Image"]  {
                                let index = self.data.firstIndex(of: image)
                                if index == nil {
                                    self.data.append(image)
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    })
                    Database.database().reference().child("WishList").child(email).observe(DataEventType.childRemoved, with: { (snap2) in
                        if let dic = snap2.value as? [String: String]{
                            if let image = dic["Book Image"]  {
                                if let index = self.data.firstIndex(of: image) {
                                    self.data.remove(at: index)
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    })
                }
            }
        }
    }
    @objc func back() {
        self.performSegue(withIdentifier: "back", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? WishListTableViewCell
        cell?.bookimage.sd_setImage(with: URL(string: self.data[indexPath.row]), completed: nil)
        Database.database().reference().child("Email").queryOrdered(byChild: "Are you seller").queryEqual(toValue: true).observe(DataEventType.childAdded) { (snap) in
            if let dic = snap.value as? [String: Any] {
                if let email = dic["uid"] as? String {
                    Database.database().reference().child("Seller Inventory").child(email).queryOrdered(byChild: "Book Image").queryEqual(toValue: self.data[indexPath.row]).observe(DataEventType.childAdded, with: { (snap1) in
                        if let dic = snap1.value as? [String: Any] {
                            if let name = dic["Book Name"] as? String {
                                if let image1 = dic["Book Image"] as? String {
                                    //if let genre = dic["Book Genre"] as? String {
                                       // if let cond = dic["Book Condition"] as? String {
                                            if let seller = dic["Book Seller"] as? String {
                                                if Auth.auth().currentUser != nil {
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
                                                cell?.bookname.text = name
                                                cell?.label.text = image1
                                                cell?.label2.text = seller
                                            }
                                        //}
                                    //}
                                }
                            }
                        }
                    })
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
        switch segue.identifier {
        case "booksforrent1":
            if let destination = segue.destination as? ContainerViewController2 {
                if let sender1 =  sender as? UITableViewCell{
                    let indexpath = tableView.indexPath(for: sender1)
                    let book = self.data[indexpath?.row ?? 0]
                    destination.bookname = book
                    destination.index1 = self.index
                }
            }
        default:
            print("done")
        }
    }
}
