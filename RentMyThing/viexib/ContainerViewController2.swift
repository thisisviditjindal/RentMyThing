//
//  ContainerViewController2.swift
//  RentMyThing
//
//  Created by vidit jindal on 15/09/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ContainerViewController2: UIViewController {
    @IBOutlet var viewcontroller: UIView!
    var tableview: UIView!
    var mapview: UIView!
    var bookname = ""
    var bought = false
    var book = ""
    var distance = 0.0
    var index = 0
    var index1 = 0
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.post(name: NSNotification.Name("Seller"), object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(rentit), name: NSNotification.Name("rentit"), object: nil)
        if Auth.auth().currentUser != nil {
            self.index1 = 0
        }
        else{
            self.index1 = -1
        }
    }
    @objc func rentit(_ not: Notification) {
        if let not1 = not.object as? [String: Any]{
            if let image = not1["image"] as? String {
                if let nrent = not1["rentedb"] as? Int {
                    if let nsold = not1["sold"] as? Int {
                        if let rent = not1["rent"] as? Bool {
                            if let copies = not1["copies"] as? Int {
                                if let bought = not1["bought"] as? Bool {
                                    if let email = not1["email"] as? String{
                                        if let distance = not1["distance"] as? Double {
                                            self.distance = distance
                                            if rent == true {
                                                print("YEs its working1")
                                                if (nsold + nrent) == copies {
                                                    print("YEs its working2")
                                                    if self.index == -1 {
                                                        print("YEs its working3")
                                                        self.performSegue(withIdentifier: "renting1", sender: self)
                                                    }
                                                    else{
                                                        print("YEs its working4")
                                                        self.performSegue(withIdentifier: "renting1", sender: self)
                                                    }
                                                }
                                                else{
                                                    if self.index1 == -1 {
                                                        self.performSegue(withIdentifier: "rentit", sender: image)
                                                    }
                                                    else{
                                                        if bought == true {
                                                            print("YEs its working5")
                                                            self.performSegue(withIdentifier: "renting1", sender: email)
                                                        }
                                                        else{
                                                            print("YEs its working6")
                                                            self.performSegue(withIdentifier: "rentit", sender: image)
                                                        }
                                                    }
                                                }
                                            }
                                            else {
                                                print("YEs its working7")
                                                self.performSegue(withIdentifier: "rentit", sender: image)
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
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.index)
        Database.database().reference().child("Email").queryOrdered(byChild: "Are you seller").queryEqual(toValue: true).observe(DataEventType.childAdded) { (snap) in
            if let dic = snap.value as? [String: Any] {
                if let email1 = dic["uid"] as? String{
                    Database.database().reference().child("Seller Inventory").child(email1).queryOrdered(byChild: "Book Image").queryEqual(toValue: self.bookname).observe(DataEventType.childAdded, with: { (snap) in
                        if let dic = snap.value as? [String: Any]{
                            if let bookname1 = dic["Book Name"] as? String {
                                self.book = bookname1
                                print(self.book)
                            }
                        }
                    })
                }
            }
        }
        tableview = SellerNearYouTableViewController().view
        mapview = MapViewController().view
        self.viewcontroller.addSubview(tableview)
        self.viewcontroller.addSubview(mapview)
        self.viewcontroller.bringSubviewToFront(tableview)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentview(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.viewcontroller.bringSubviewToFront(tableview)
            break
        case 1:
            self.viewcontroller.bringSubviewToFront(mapview)
            break
        default:
            print("Hello")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rentit"{
            if let destination = segue.destination as? FinalRentViewController {
                destination.imagecap = (sender as? String)!
                destination.index = self.index1
                destination.distance = self.distance
            }
        }
        else if segue.identifier == "renting1" {
            if let nav = segue.destination as? UINavigationController {
                if let destination = nav.topViewController as? EndRentViewController {
                    if self.index1 == -1 {
                        destination.index = -2
                    }
                    else {
                        if self.bought == true {
                            destination.index = -2
                        }
                        else {
                            if let sender1 = sender as? String {
                                destination.index = 8
                                destination.seemail = sender1
                            }
                        }
                    }
                }
            }
        }
    }
}
