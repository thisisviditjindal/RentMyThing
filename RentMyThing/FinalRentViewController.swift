//
//  FinalRentViewController.swift
//  RentMyThing
//
//  Created by vidit jindal on 16/07/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
//import GoogleMobileAds
import UserNotifications
class FinalRentViewController: UIViewController, UITextFieldDelegate{ //GADBannerViewDelegate
    @IBOutlet weak var bookname: UILabel!
    @IBOutlet weak var bookimage: UIImageView!
    @IBOutlet weak var addressofseller: UILabel!
    @IBOutlet weak var noofdays: UITextField!
    @IBOutlet weak var totalcost: UILabel!
    @IBOutlet weak var totalpay: UILabel!
    @IBOutlet weak var recievedmonye: UILabel!
    @IBOutlet weak var required: UILabel!
    @IBOutlet weak var distnceaway: UILabel!
    @IBOutlet weak var specify: UITextField!
    //@IBOutlet weak var adview: GADBannerView!
    var emails = [String]()
    var imagecap = ""
    var copies = 0
    var email = ""
    var index = 0
    var amount = 0
    var date = Date()
    var distance = 0.0
    var dteinter = DateInterval()
    var token = ""
    private let notificationhandler = NOtificationpublish()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("n5ii\(self.imagecap)")
        self.navigationController?.navigationBar.prefersLargeTitles = true
        NotificationCenter.default.addObserver(self, selector: #selector(done), name: NSNotification.Name("Selectdate"), object: nil)
        noofdays.delegate = self
        specify.delegate = self
        //adview.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        //adview.rootViewController = self
        //adview.load(GADRequest())
        //adview.delegate = self
        toolbar()
        self.distnceaway.text = "\(self.distance)Km Away"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.hidesBackButton = false
        required.isHidden = true
        Database.database().reference().child("Email").queryOrdered(byChild: "Are you seller").queryEqual(toValue: true).observe(DataEventType.childAdded) { (snap) in
            if let dic = snap.value as? [String: Any] {
                if let email1 = dic["uid"] as? String{
                    self.emails.append(email1)
                    Database.database().reference().child("Seller Inventory").child(email1).queryOrdered(byChild: "Book Image").queryEqual(toValue: self.imagecap).observe(DataEventType.childAdded, with: { (snap2) in
                        let activityindictor = UIActivityIndicatorView()
                        activityindictor.frame = CGRect(x: 0, y: 0, width: 55, height: 55)
                        activityindictor.center = self.view.center
                        self.view.addSubview(activityindictor)
                        activityindictor.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
                        activityindictor.startAnimating()
                        UIApplication.shared.beginIgnoringInteractionEvents()
                        if let dic = snap2.value as? [String: Any] {
                            if let bookname1 = dic["Book Name"] as? String{
                                if let copies1 = dic["Book Copies"] as? Int {
                                    if let originalpri = dic["Book O Price"] as? Int {
                                        self.totalpay.text = String(originalpri)
                                        self.bookname.text = bookname1
                                        self.bookimage.sd_setImage(with: URL(string: self.imagecap), completed: nil)
                                        self.copies = copies1
                                        Database.database().reference().child("SellerInformation").child(email1).observe(DataEventType.childAdded, with: { (snap1) in
                                            if let dic = snap1.value as? [String: Any] {
                                                if let address = dic["Addressline"] as? String {
                                                    if let pincode = dic["Pincode"] as? String {
                                                        if let city = dic["city"] as? String {
                                                            if let area = dic["Area"] as? String {
                                                                self.addressofseller.text = "\(address),\(area)-\(city), \(pincode)"
                                                                self.email = email1
                                                                UIApplication.shared.endIgnoringInteractionEvents()
                                                                activityindictor.stopAnimating()
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    })
                }
                if let token1 = dic["Token"] as? String {
                    self.token = token1
                }
            }
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == noofdays{
            self.index = 1
            self.performSegue(withIdentifier: "date", sender: self.index)
        }
        else {
            self.index = 2
            self.performSegue(withIdentifier: "date", sender: self.index)
        }
        return false
    }
    func pushnotification() {
        notificationhandler.sendnotification(title: "Hey", subtitle: "This is amazing", body: "very Amazing", badge: 1, delayinterval: nil)
    }
    func toolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let donebutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(FinalRentViewController.done1))
        let flex = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flex,donebutton], animated: true)
        toolbar.isUserInteractionEnabled = true
        noofdays.inputAccessoryView = toolbar
    }
    @objc func done1() {
        self.resignFirstResponder()
    }
    @objc func done(_ not: Notification) {
        if let object = not.object as? DateViewController {
            let index1 = object.index
            var d1 = ""
            let dateformatter = ISO8601DateFormatter()
            if index1 == 1 {
                noofdays.text = object.formatted1
                d1 = object.formatted
            }
            else {
                specify.text = object.formatted1
                let date = dateformatter.date(from: d1)
                print(d1)
                let date1 = dateformatter.date(from: object.formatted)
                print(date1!)
                print(specify.text!)
                self.dteinter = DateInterval(start: date!, end: date1!)
                print(self.dteinter.duration / (60 * 24 * 60))
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func rent(_ sender: Any) {
        print("test1")
        if index == -1 {
            self.performSegue(withIdentifier: "goback", sender: self)
        }
        else {
            print("test1")
            if let day = noofdays.text {
                print("test2")
                if let day2 = specify.text {
                    print("test3")
                    if let booknam = bookname.text {
                        print("test4")
                        if day == "" || day2 == ""{
                            required.isHidden = false
                        }
                        else {
                            print("test 5")
                            var value = [String: Any]()
                            value = ["Book Name": booknam,"Seller Address": addressofseller.text ?? "", "Seller Email": email, "Days": 0, "Amounttobepaid": Int(totalpay.text ?? "") ?? 0, "Rent": Int(totalcost.text ?? "") ?? 0,"Book Image": imagecap,"IsBookRented": true, "Renting Date": day, "Ending Date": day2]
                            
                            Database.database().reference().child("RentedBook").child((Auth.auth().currentUser?.uid)!).childByAutoId().setValue(value)
                            Database.database().reference().child("Seller Inventory").child(email).queryOrdered(byChild: "Book Image").queryEqual(toValue: self.imagecap).observe(DataEventType.childAdded, with: { (snap2) in
                                snap2.ref.child("IsBookRented").setValue(true)
                                if let dic = snap2.value as? [String: Any] {
                                    if let rent = dic["Books Rented"] as? Int {
                                        let add = rent + 1
                                        snap2.ref.child("Books Rented").setValue(add)
                                        self.performSegue(withIdentifier: "renting", sender: self)
                                        self.pushnotification()
                                        print("test5")
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    @IBAction func tap(_ sender: Any) {
        self.performSegue(withIdentifier: "imageview", sender: self.imagecap)
    }
    
    @IBAction func text1(_ sender: UITextField) {
        let dateformatter = DateFormatter()
        if let day1 = sender.text {
            self.date = dateformatter.date(from: day1)!
        }
    }
    
    @IBAction func text2(_ sender: UITextField) {
        
        amount = 0
        let a = Int(self.noofdays.text ?? "") ?? 0
        if Int(self.totalpay.text ?? "") ?? 0 > 100 && Int(self.totalpay.text ?? "") ?? 0 <= 300 {
            amount = ((a * 10) + 15)
        }
        else if Int(self.totalpay.text ?? "") ?? 0 > 300 && Int(self.totalpay.text ?? "") ?? 0 <= 500 {
            amount = (a * 15) + 20
        }
        else if Int(self.totalpay.text ?? "") ?? 0 > 500 && Int(self.totalpay.text ?? "") ?? 0 <= 700{
            amount = ((a * 20) + 25)
        }
        else if Int(self.totalpay.text ?? "") ?? 0 > 700 && Int(self.totalpay.text ?? "") ?? 0 <= 1000 {
            amount += (a * 20) + 30
        }
        else {
            amount += (a * 20) + 40
        }
        self.totalcost.text = String(amount)
        self.recievedmonye.text = String(Int(self.totalpay.text ?? "") ?? 0 - amount)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "renting":
            if let dest = segue.destination as? EndRentViewController {
                if let totalpay1 = totalpay.text {
                    dest.cost = totalpay1
                }
            }
        case "goback":
            if let nav = segue.destination as? UINavigationController {
                if let dest = nav.topViewController as? MainViewController {
                    dest.index = self.index
                    dest.amount = self.totalpay.text ?? ""
                    dest.image = self.imagecap
                    dest.name = self.bookname.text ?? ""
                    dest.seemail = self.email
                    dest.rent = self.totalcost.text ?? ""
                    dest.day = self.noofdays.text ?? ""
                    dest.address = self.addressofseller.text ?? ""
                }
            }
        case "imageview":
            if let dest = segue.destination as? ImageViewController  {
                if let sender1 = sender as? String {
                    dest.image = sender1
                }
            }
        case "date":
            if let dest = segue.destination as? DateViewController {
                if let sender1 = sender as? Int {
                    dest.index = sender1
                }
            }
        default:
            print("Done")
        }
    }
}
/*
 let content = UNMutableNotificationContent()
 content.title = "Time To Return The Book"
 content.body = "Only one day is remaing"
 content.badge = 1
 var dateComponents = DateComponents()
 dateComponents.calendar = Calendar.current
 dateComponents.hour = 20
 dateComponents.minute = 40
 dateComponents.day = 5
 dateComponents.month = 9
 // Create the trigger as a repeating event.
 let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
 let uuidString = UUID().uuidString
 let request = UNNotificationRequest(identifier: uuidString,content: content, trigger: trigger)
 // Schedule the request with the system.
 let notificationCenter = UNUserNotificationCenter.current()
 notificationCenter.add(request) { (error) in
 if error != nil {
 print("Error12 \(error?.localizedDescription ?? "")")
 }
 }
 if let url = URL(string: "https://fcm.googleapis.com/fcm/send") {
 var request = URLRequest(url: url)
 request.allHTTPHeaderFields = ["Content-Type":"application/json", "Authorization":"key=AAAAQYQ5wLc:APA91bFsmBuiq0iUVrOjXI5IzLIru3rmib0fB34CBr9VEi72xsrw6lKkoK8jTJLcD9P4QPVDSHhErYzjAu5yNFTQjaeblTR5S8Zhq4akTs7T1ihyWzUIG-3lJ1XL02QZvs9THuiJT4_cKZeWOsmCcZYI82vuhkG9jA"]
 request.httpMethod = "POST"
 request.httpBody = "{\"to\":\"\(self.token)\",\"notification\": {\"title\": \"Amazing\",\"body\": \"This is to check everything is going fine\"},\"apns\":{\"headers\": {\"apns-priority\": \"5\"}}}".data(using: String.Encoding.utf8)
 URLSession.shared.dataTask(with: request) { (data, response, error) in
 if error != nil {
 print("error\(error!)")
 }
 print(String(data: data!, encoding: String.Encoding.utf8) ?? "")
 }.resume()
 }
 */
