//
//  SellerNearYouTableViewController.swift
//  RentMyThing
//
//  Created by vidit jindal on 22/07/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import MapKit
class SellerNearYouTableViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet var tableView: UITableView!
    var name = ""
    var image = ""
    var email = ""
    var bookname1 = ""
    var index = 7
    var distance = 0.0
    var sellerinfo = [DataSnapshot]()
    let locationmaneger = CLLocationManager()
    var userlocation = CLLocationCoordinate2D()
    var sellerloc = CLLocationCoordinate2D()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(not), name: NSNotification.Name("Seller"), object: nil)
        print(self.name)
        self.tableView.reloadData()
        let nib = UINib.init(nibName: "SellerTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "resuseidentifier")
        self.tableView.delegate = self
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        locationmaneger.delegate = self
        locationmaneger.requestWhenInUseAuthorization()
        locationmaneger.startUpdatingLocation()
        locationmaneger.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        Database.database().reference().child("Email").queryOrdered(byChild: "Are you seller").queryEqual(toValue: true).observe(DataEventType.childAdded) { (snap) in
            if let dic = snap.value as? [String: Any] {
                if let email1 = dic["uid"] as? String{
                    Database.database().reference().child("Seller Inventory").child(email1).queryOrdered(byChild: "Book Image").queryEqual(toValue: self.name).observe(DataEventType.childAdded, with: { (snap) in
                        Database.database().reference().child("SellerInformation").child(email1).observe(DataEventType.childAdded, with: { (snap5) in
                            if let dic = snap5.value as? [String: Any]{
                                if let lat = dic["Seller Latitude"] as? Double {
                                    if let lon = dic["Seller Longitude"] as? Double {
                                        self.sellerloc = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                                    }
                                }
                            }
                        })
                        if let dic = snap.value as? [String: Any]{
                            if let bookname = dic["Book Name"] as? String {
                                self.bookname1 = bookname
                                self.tableView.reloadData()
                                Database.database().reference().child("Email").queryOrdered(byChild: "Are you seller").queryEqual(toValue: true).observe(DataEventType.childAdded) { (snap) in
                                    if let dic = snap.value as? [String: Any] {
                                        if let email1 = dic["uid"] as? String{
                                            Database.database().reference().child("Seller Inventory").child(email1).queryOrdered(byChild: "Book Name").queryEqual(toValue: self.bookname1).observe(DataEventType.childAdded, with: { (snap1) in
                                                self.sellerinfo.append(snap1)
                                                self.tableView.reloadData()
                                            })
                                        }
                                    }
                                    self.tableView.reloadData()
                                }
                            }
                        }
                        self.tableView.reloadData()
                    })
                }
            }
        }
    }
    @objc func not(_ not: Notification){
        if let object1 = not.object as? ContainerViewController2{
            let index1 = object1.index1
            let book = object1.bookname
            self.index = index1
            self.name = book
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate {
            userlocation = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            let sellerloc1 = CLLocation(latitude: sellerloc.latitude, longitude: sellerloc.longitude)
            let userloc = CLLocation(latitude: userlocation.latitude, longitude: userlocation.longitude)
            distance = (sellerloc1.distance(from: userloc)/1000).rounded()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sellerinfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resuseidentifier", for: indexPath) as? SellerTableViewCell
        cell?.setSelected(false, animated: true)
        if let dic = sellerinfo[indexPath.row].value as? [String: Any]{
            if let bookname = dic["Book Name"] as? String {
                if let bookcond = dic["Book Condition"] as? String {
                    cell?.bookname.text = bookname
                    cell?.condition.text = bookcond
                    cell?.distance.text = "\(self.distance)Km"
                }
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dic = sellerinfo[indexPath.row].value as? [String: Any]{
            if let image1 = dic["Book Image"] as? String {
                if let rented1 = dic["IsBookRented"] as? Bool {
                    if let bookcopies1 = dic["Book Copies"] as? Int {
                        if let booksold1 = dic["Books Sold"] as? Int {
                            if let bookrented1 = dic["Books Rented"] as? Int {
                                if index == -1 {
                                    let value = ["image": image1, "copies": bookcopies1, "sold": booksold1, "rent": rented1, "rentedb": bookrented1, "bought": true, "email": "", "distance": self.distance] as [String : Any]
                                    NotificationCenter.default.post(name: NSNotification.Name("rentit"), object: value)
                                }
                                else {
                                    Database.database().reference().child("RentedBook").child((Auth.auth().currentUser?.uid)!).queryOrdered(byChild: "Book Image").queryEqual(toValue: image1).observe(DataEventType.childAdded) { (snap) in
                                        if let dic = snap.value as? [String: Any]{
                                            if let email2 = dic["Seller Email"] as? String {
                                                self.email = email2
                                                let value = ["image": image1, "copies": bookcopies1, "sold": booksold1, "rent": rented1, "rentedb": bookrented1, "bought": true, "email": email2, "distance": self.distance] as [String : Any]
                                                NotificationCenter.default.post(name: NSNotification.Name("rentit"), object: value)
                                            }
                                        }
                                    }
                                    let value = ["image": image1, "copies": bookcopies1, "sold": booksold1, "rent": rented1, "rentedb": bookrented1, "bought": false, "email": "", "distance": self.distance] as [String : Any]
                                    NotificationCenter.default.post(name: NSNotification.Name("rentit"), object: value)
                                }
                            }
                        }
                    }
                }
            }
        }
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
    }
}
/*
 if index == -1 {
 
 }
 else {
 
 }
 */
