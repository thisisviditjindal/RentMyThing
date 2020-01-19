//
//  MapViewController.swift
//  RentMyThing
//
//  Created by vidit jindal on 14/09/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseDatabase

class MapViewController: UIViewController, CLLocationManagerDelegate{
    @IBOutlet var mapview: MKMapView!
    let locationmaneger = CLLocationManager()
    var userlocation = CLLocationCoordinate2D()
    var seller = [location]()
    var index = 0
    var name = "lnk"
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(not), name: NSNotification.Name("Seller"), object: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.name)
        locationmaneger.delegate = self
        locationmaneger.requestWhenInUseAuthorization()
        locationmaneger.startUpdatingLocation()
        locationmaneger.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            Database.database().reference().child("Email").queryOrdered(byChild: "Are you seller").queryEqual(toValue: true).observe(DataEventType.childAdded) { (snap) in
                if let dic = snap.value as? [String: Any] {
                    if let email1 = dic["uid"] as? String{
                        Database.database().reference().child("SellerInformation").child(email1).observe(DataEventType.childAdded, with: { (snap5) in
                            if let dic = snap5.value as? [String: Any]{
                                if let lat = dic["Seller Latitude"] as? Double {
                                    if let lon = dic["Seller Longitude"] as? Double {
                                        self.seller.append(location(latitude: lat, longitude: lon))
                                        self.mapview.reloadInputViews()
                                    }
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            if let coord = manager.location?.coordinate {
                self.userlocation = coord
                var slat = 0.0
                var slon = 0.0
                for i in self.seller{
                    slat += i.latitude
                    slon += i.longitude
                    let ann = MKPointAnnotation()
                    ann.title = "Seller Location"
                    ann.coordinate = CLLocationCoordinate2D(latitude: i.latitude, longitude: i.longitude)
                    self.mapview.addAnnotation(ann)
                }
                let span = MKCoordinateSpan(latitudeDelta: abs(slat - self.userlocation.latitude) * 2 + 0.005, longitudeDelta: abs(slon - self.userlocation.longitude) * 2 + 0.005)
                let location = MKCoordinateRegion(center: self.userlocation, span: span)
                self.mapview.setRegion(location, animated: true)
                let annotation = MKPointAnnotation()
                annotation.coordinate = self.userlocation
                annotation.title = "Your Location"
                self.mapview.addAnnotation(annotation)
            }
        }
    }
    @objc func not(_ not: Notification) {
        if let object1 = not.object as? ContainerViewController2{
            self.name = object1.book
            self.index = object1.index1
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
class location {
    var latitude: Double
    var longitude: Double
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
