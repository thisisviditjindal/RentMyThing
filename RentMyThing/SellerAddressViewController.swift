//
//  SellerAddressViewController.swift
//  RentMyThing
//
//  Created by vidit jindal on 30/06/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import MapKit
import CoreLocation

class SellerAddressViewController: UIViewController, CLLocationManagerDelegate{
    @IBOutlet weak var pincode: UITextField!
    @IBOutlet weak var addressline: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var Area: UITextField!
    @IBOutlet var pin: [UILabel]!
    
    let toolbar = UIToolbar()
    var yourareseller = true
    var location = CLLocationCoordinate2D()
    let locationmaneger = CLLocationManager()
    var userloca = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationmaneger.delegate = self
        locationmaneger.requestWhenInUseAuthorization()
        locationmaneger.startUpdatingLocation()
        locationmaneger.desiredAccuracy = kCLLocationAccuracyNearestTenMeters

        settoolbar()
        for i in pin {
            i.isHidden = true
        }
    }
    @objc func donebutton() {
        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func Registerme(_ sender: UIButton) {
        if let uid = Auth.auth().currentUser?.uid {
            if let pincode1 = pincode.text {
                if let address = addressline.text {
                    if let city1 = city.text {
                        if let state1 = state.text {
                            if let area = Area.text {
                                if let country1 = country.text {
                                    if pincode1 == "" || address == "" || city1 == "" || state1 == "" || country1 == "" || area == ""{
                                        self.displayalert(title: "Error", message: "One of the field is empty")
                                    }
                                    else {
                                        let value = ["email": Auth.auth().currentUser?.email ?? "","Pincode": pincode1, "Addressline": address, "city": city1, "state": state1, "country": country1, "Area": area, "Seller Latitude": userloca.latitude, "Seller Longitude": userloca.longitude] as [String : Any]
                                        Database.database().reference().child("SellerInformation").child(uid).childByAutoId().setValue(value)
                                        
                                        Database.database().reference().child("Email").queryOrdered(byChild: "uid").queryEqual(toValue: uid).observe(DataEventType.childAdded, with: { (snap) in
                                            snap.ref.child("Are you seller").setValue(self.yourareseller)
                                        })
                                        let dict = UserDefaults.standard.dictionary(forKey: "userdefaults")
                                        if var dic = dict {
                                            dic.updateValue(true, forKey: "Are you seller")
                                        }
                                        self.performSegue(withIdentifier: "registerme", sender: self)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func settoolbar() {
        pincode.inputAccessoryView = toolbar
        addressline.inputAccessoryView = toolbar
        city.inputAccessoryView = toolbar
        state.inputAccessoryView = toolbar
        country.inputAccessoryView = toolbar
        toolbar.isUserInteractionEnabled = true
        let flexiblespace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: self, action: nil)
        let donebutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done
            , target: self, action: #selector(SellerAddressViewController.donebutton))
        let items = [flexiblespace,donebutton]
        toolbar.setItems(items, animated: true)
        let tap = UITapGestureRecognizer(target: self, action:
            #selector(SellerAddressViewController.donebutton))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tap)
    }
    func displayalert(title: String, message: String){
        let actioncontroller = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel) { (uiaction) in
            actioncontroller.dismiss(animated: true, completion: nil)
        }
        actioncontroller.addAction(action)
        present(actioncontroller, animated: true, completion: nil)
    }
    @IBAction func pincode(_ sender: Any) {
        do {
            if let path = Bundle.main.path(forResource: "convertcsv123", ofType: "json") {
                let jasondata = try Data(contentsOf: URL(fileURLWithPath: path) )
                let json = try JSONSerialization.jsonObject(with: jasondata, options: [])
                if let object = json as? [String: [Any]] {
                    if let field2 = object["pincode"] as? [Int]{
                        if let state1 = object["statename"] as? [String] {
                            if let pincod = pincode.text {
                                let index = field2.firstIndex(of: Int(pincod) ?? -1)
                                if pincod == "" {
                                    pin[0].isHidden = false
                                }
                                else if index != nil{
                                    state.text = state1[index!]
                                    country.text = "India"
                                    pin[0].isHidden = true
                                }
                                else if index == nil {
                                    pin[0].isHidden = false
                                    pin[0].text = "Please Enter Valid Pincode"
                                    state.text = ""
                                    country.text = ""
                                }
                            }
                        }
                    }
                    else {
                        self.displayalert(title: "Error", message: "Pincode is wrong")
                    }
                }
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let cood = manager.location?.coordinate{
            userloca = cood
        }
    }
    @IBAction func userlocation(_ sender: Any) {
        let activityindictor = UIActivityIndicatorView()
        self.view.addSubview(activityindictor)
        activityindictor.frame = CGRect(x: 0, y: 0, width: 55, height: 55)
        activityindictor.center = self.view.center
        activityindictor.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
        activityindictor.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        let location = CLLocation(latitude: userloca.latitude, longitude: userloca.longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                UIApplication.shared.endIgnoringInteractionEvents()
                activityindictor.stopAnimating()
            }
            else {
                if let placemark = placemarks {
                    if placemark.count > 0{
                        let place = placemark[0]
                        self.state.text = place.administrativeArea ?? ""
                        self.Area.text = place.subLocality ?? ""
                        self.country.text = place.country ?? ""
                        self.city.text = place.locality ?? ""
                        self.pincode.text = place.postalCode ?? ""
                        UIApplication.shared.endIgnoringInteractionEvents()
                        activityindictor.stopAnimating()
                    }
                }
            }
        })
    }
    
    @IBAction func cancelit(_ sender: Any) {
        self.performSegue(withIdentifier: "cancel", sender: self)
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
