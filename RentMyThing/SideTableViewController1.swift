//
//  SideTableViewController1.swift
//  RentMyThing
//
//  Created by vidit jindal on 01/09/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class SideTableViewController1: UITableViewController {
    var renter = false
    var user = true
    var username = ""
    var index = -1
    @IBOutlet var button1: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,selector:#selector(SideTableViewController1.menue1(_:)),name:
            NSNotification.Name("ToggleSideMenu1"),object: nil)
    }
    @objc func menue1(_ not: Notification) {
        if let userf = not.object as? BookInventoryTableViewController {
            self.index = userf.index1
            if index == 3 {
                button1.setTitle("Hello \(Auth.auth().currentUser?.displayName ?? "")", for: UIControl.State.normal)
                let cell = tableView.cellForRow(at: IndexPath(row: 3, section: 1))
                cell?.textLabel?.text = "Switch To Buying"
            }
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                NotificationCenter.default.post(name: NSNotification.Name("profile"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu1"), object: self)
            }
            else if indexPath.row == 1 {
                NotificationCenter.default.post(name: NSNotification.Name("wish"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu1"), object: self)
            }
            else if indexPath.row == 2 {
                NotificationCenter.default.post(name: NSNotification.Name("books"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu1"), object: self)
            }
            else if indexPath.row == 3 {
                NotificationCenter.default.post(name: NSNotification.Name("renting"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu1"), object: self)
            }
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                NotificationCenter.default.post(name: NSNotification.Name("setting"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu1"), object: self)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }
        else if section == 1 {
            return 1
        }
        return 1
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
