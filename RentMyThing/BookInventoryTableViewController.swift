//
//  BookInventoryTableViewController.swift
//  RentMyThing
//
//  Created by vidit jindal on 01/07/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import SDWebImage

class BookInventoryTableViewController: UITableViewController {
    var inventory = [DataSnapshot]()
    @IBOutlet weak var sidebutton: UIBarButtonItem!
    var index1 = 3
    var sideopen = false
    override func viewDidLoad() {
        super.viewDidLoad()
        addnotifiction()
        self.inventory.removeAll()
        if let email = Auth.auth().currentUser?.uid{
            Database.database().reference().child("Seller Inventory").child(email).observe(DataEventType.childAdded) { (snap) in
                self.inventory.append(snap)
                self.tableView.reloadData()
            }
            Database.database().reference().child("Seller Inventory").child(email).observe(DataEventType.childChanged) { (snap) in
                self.tableView.reloadData()
            }
        }
    }
    func addnotifiction() {
        NotificationCenter.default.addObserver(self, selector: #selector(showProfile),name: NSNotification.Name("profile"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(showSettings),name: NSNotification.Name("setting"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(yourbook),name: NSNotification.Name("books"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(renting),name: NSNotification.Name("renting"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(wish),name: NSNotification.Name("wish"),object: nil)
    }
    @objc func showProfile() {
        performSegue(withIdentifier: "profile", sender: nil)
    }
    @objc func wish() {
        performSegue(withIdentifier: "listofwish", sender: nil)
    }
    @objc func showSettings() {
        performSegue(withIdentifier: "setting", sender: nil)
    }
    @objc func yourbook(){
        performSegue(withIdentifier: "books", sender: nil)
    }
    @objc func renting(){
        performSegue(withIdentifier: "backhome", sender: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventory.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? InventoryTableViewCell
        if let  dic = inventory[indexPath.row].value as? [String: Any] {
            if let bookname = dic["Book Name"] as? String {
                if let bookimage = dic["Book Image"] as? String {
                    if let imagedata = URL(string: bookimage) {
                        if let copies = dic["Book Copies"] as? Int {
                            if let rented = dic["Books Rented"] as? Int {
                                if let sold = dic["Books Sold"] as? Int {
                                    if let isbookrented = dic["IsBookRented"] as? Bool {
                                        if let isbooksold = dic["IsBookSold"] as? Bool {
                                            if isbooksold == true {
                                                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
                                            }
                                            else {
                                                cell?.imageView?.sd_setImage(with: imagedata, completed: nil)
                                                cell?.booklabel.text = bookname
                                                if isbookrented == true {
                                                    if (rented + sold) == copies {
                                                        cell?.isUserInteractionEnabled = false
                                                        cell?.alpha = 0.1
                                                        cell?.backgroundColor = UIColor.clear
                                                        cell?.bookbuy.alpha = 0.2
                                                        cell?.bookimage.alpha = 0.2
                                                        cell?.booklabel.alpha = 0.2
                                                        cell?.booksel.alpha = 0.2
                                                        cell?.norented.text = String(rented)
                                                        cell?.norented.alpha = 0.2
                                                    }
                                                    else {
                                                        cell?.norented.text = String(rented)
                                                    }
                                                }
                                                else if rented == 0 {
                                                    cell?.norented.text = "0"
                                                }
                                                if isbooksold == true {
                                                    if (rented + sold) == copies {
                                                        cell?.isUserInteractionEnabled = false
                                                        cell?.alpha = 0.1
                                                        cell?.backgroundColor = UIColor.clear
                                                        cell?.bookbuy.alpha = 0.2
                                                        cell?.bookimage.alpha = 0.2
                                                        cell?.booklabel.alpha = 0.2
                                                        cell?.booksel.alpha = 0.2
                                                        cell?.noofbooksold.text = String(sold)
                                                    }
                                                    else {
                                                        cell?.noofbooksold.text = String(sold)
                                                    }
                                                }
                                                else if sold == 0 {
                                                    cell?.noofbooksold.text = "0"
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return cell!
    }
    @IBAction func side(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu1"), object: self)
    }
    
    @IBAction func add(_ sender: Any) {
        self.performSegue(withIdentifier: "addmybook", sender: self)
    }
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
        if segue.identifier == "addmybook" {
            print("Done")
        }
        else if segue.identifier == "showmybook"{
            if let destintion = segue.destination as? BookViewController{
                if let sender1 = sender as? InventoryTableViewCell {
                    let indexpath = tableView.indexPath(for: sender1)
                    if let dic = inventory[(indexpath?.row)!].value as? [String: Any] {
                        if let name = dic["Book Name"] as? String {
                            if let genre = dic["Book Genre"] as? String {
                                if let image = dic["Book Image"] as? String {
                                    if let condition1 = dic["Book Condition"] as? String {
                                        if let sell = dic["Book Sell"] as? Bool {
                                            if let copy = dic["Book Copies"] as? Int{
                                                if let price = dic["Book O Price"] as? Int {
                                                    destintion.condition = condition1
                                                    destintion.name = name
                                                    destintion.genre = genre
                                                    destintion.download = image
                                                    destintion.sell = sell
                                                    destintion.index = 1
                                                    destintion.price = price
                                                    destintion.copies = copy
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
