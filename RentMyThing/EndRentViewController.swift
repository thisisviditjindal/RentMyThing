//
//  EndRentViewController.swift
//  RentMyThing
//
//  Created by vidit jindal on 16/07/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth

class EndRentViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    var index = 0
    var image = ""
    var address = ""
    var amount = ""
    var rent = ""
    var name = ""
    var day = ""
    var seemail = ""
    var bookboght = false
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var cost1: UILabel!
    @IBOutlet weak var mapview: MKMapView!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var remin: UIButton!
    
    var cost = ""
    let locationmanager = CLLocationManager()
    var userloc = CLLocationCoordinate2D()
    var sellerloc = CLLocationCoordinate2D()
    override func viewWillAppear(_ animated: Bool) {
        if index == -1 {
            let value = ["Book Name": self.name,"Seller Address": self.address, "Seller Email": self.seemail, "Days": Int(self.day) ?? 0, "Amounttobepaid": Int(self.amount) ?? 0, "Rent": Int(self.rent) ?? 0,"Book Image": self.image] as [String : Any]
            Database.database().reference().child("RentedBook").child((Auth.auth().currentUser?.uid)!).childByAutoId().setValue(value)
            Database.database().reference().child("Seller Inventory").child(self.seemail).queryOrdered(byChild: "Book Image").queryEqual(toValue: self.image).observe(DataEventType.childAdded, with: { (snap2) in
                snap2.ref.child("IsBookRented").setValue(true)
            })
        }
    }
    override func viewDidLoad() {
        self.remin.isHidden = true
        super.viewDidLoad()
        print("index\(self.index)")
        if index == 8 {
            self.label.text = "You have already rented this book"
            self.navigationItem.title = "Already Rented"
            self.label1.text = "If Book is not picked up? Pick up fast!!"
            if CLLocationManager.locationServicesEnabled() {
                locationmanager.delegate = self
                locationmanager.activityType = .otherNavigation
                locationmanager.desiredAccuracy = kCLLocationAccuracyBest
                locationmanager.startUpdatingLocation()
            }
            Database.database().reference().child("SellerInformation").child(self.seemail).observe(DataEventType.childAdded, with: { (snap1) in
                print(snap1)
                if let dic1 = snap1.value as? [String: Any]{
                    if let lat = dic1["Seller Latitude"] as? Double{
                        if let lon = dic1["Seller Longitude"] as? Double {
                            self.sellerloc = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                            self.cost1.text = self.cost
                        }
                    }
                }
            })
        }
        else if index == -2 {
            self.label.text = "This book has been already rented by someone"
            self.navigationItem.title = "Already Rented"
            self.mapview.isHidden = true
            self.label1.isHidden = true
            self.label2.isHidden = true
            self.label3.isHidden = true
            self.button2.isHidden = true
            self.remin.isHidden = false
        }
        else {
            tranisition()
        }
    }
    func tranisition() {
        if CLLocationManager.locationServicesEnabled() {
            locationmanager.delegate = self
            locationmanager.activityType = .otherNavigation
            locationmanager.desiredAccuracy = kCLLocationAccuracyBest
            locationmanager.startUpdatingLocation()
        }
        Database.database().reference().child("Email").observe(DataEventType.childAdded) { (snap) in
            if let dic = snap.value as? [String: Any] {
                if let email = dic["uid"] as? String {
                    Database.database().reference().child("SellerInformation").child(email).observe(DataEventType.childAdded, with: { (snap1) in
                        print(snap1)
                        if let dic1 = snap1.value as? [String: Any]{
                            if let lat = dic1["Seller Latitude"] as? Double{
                                if let lon = dic1["Seller Longitude"] as? Double {
                                    self.sellerloc = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                                    self.cost1.text = self.cost
                                }
                            }
                        }
                    })
                }
            }
        }
    }
    @IBAction func startnavigation(_ sender: Any) {
        let requestlocation = CLLocation(latitude: sellerloc.latitude, longitude: sellerloc.longitude)
        CLGeocoder().reverseGeocodeLocation(requestlocation) { (placemarks, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            else {
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let place = MKPlacemark(placemark: placemark[0])
                        let mapitem = MKMapItem(placemark: place)
                        mapitem.name = "Seller Locaion"
                        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                        mapitem.openInMaps(launchOptions: options)
                    }
                }
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location {
            userloc = coord.coordinate
            let span = MKCoordinateSpan(latitudeDelta: abs(sellerloc.latitude - userloc.latitude) * 2 + 0.005 , longitudeDelta: abs(sellerloc.longitude - userloc.longitude) * 2 + 0.005)
            let location = MKCoordinateRegion(center: sellerloc, span: span)
            self.mapview.setRegion(location, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = userloc
            annotation.title = "Your Location"
            self.mapview.addAnnotation(annotation)
            let annotation1 = MKPointAnnotation()
            annotation1.coordinate = sellerloc
            annotation1.title = "Seller Location"
            self.mapview.addAnnotation(annotation1)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
