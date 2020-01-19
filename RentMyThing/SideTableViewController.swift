//
//  SideTableViewController.swift
//  RentMyThing
//
//  Created by vidit jindal on 29/06/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SideTableViewController: UITableViewController {
    var renter = false
    var user = true
    var username = ""
    var index = -1
    @IBOutlet weak var button1: UIButton!
    override func viewDidAppear(_ animated: Bool) {
        if let indexpath = tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: indexpath, animated: true)
        }
    }
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self,selector:#selector(SideTableViewController.menue(_:)),name:
            NSNotification.Name("ToggleSideMenu"),object: nil)
        super.viewDidLoad()
        Database.database().reference().child("Email").queryOrdered(byChild: "uid").queryEqual(toValue: Auth.auth().currentUser?.uid).observe(DataEventType.childAdded, with: { (snap) in
            if let dic = snap.value as? [String: Any] {
                if let seller = dic["Are you seller"] as? Bool {
                    self.renter = seller
                }
            }
        })
    }
    @objc func menue(_ not: Notification) {
        if let userinfor = not.object as? MainTableViewController{
            self.index = userinfor.index
            if index == -1{
                button1.setTitle("Hello. SignIn", for: UIControl.State.normal)
            }
            else{
                button1.setTitle("Hello \(Auth.auth().currentUser?.displayName ?? "")", for: UIControl.State.normal)
                let cell = tableView.cellForRow(at: IndexPath(row: 3, section: 0))
                if self.renter == true {
                    cell?.textLabel?.text = "Switch To Renting"
                }
            }
        }
    }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                index = -2
                NotificationCenter.default.post(name: NSNotification.Name("ShowProfile"), object: self)
                NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: self)
            }
            else if indexPath.row == 1 {
                index = -3
                NotificationCenter.default.post(name: NSNotification.Name("Wishlist"), object: self)
                NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: self)
            }
            else if indexPath.row == 2 {
                index = -4
                NotificationCenter.default.post(name: NSNotification.Name("yourbooks"), object: self)
                NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: self)
            }
            else if indexPath.row == 3 {
                index = -5
                NotificationCenter.default.post(name: NSNotification.Name("startrenting"), object: self)
                NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: self)
            }
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                NotificationCenter.default.post(name: NSNotification.Name("ShowSettings"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: self)
            }
        }
    }
    @IBAction func insignbutton(_ sender: UIButton) {
        index = -6
        NotificationCenter.default.post(name: NSNotification.Name("ShowProfile"), object: self)
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "usersignin"{
            if let dest = segue.destination as? MainViewController {
                dest.index = -2
            }
        }
        else if segue.identifier == "setting" {
            if let dest = segue.destination as? SettingsTableViewController {
                if let sender1 = sender as? Int {
                    dest.index = sender1
                }
            }
        }
    }
}
