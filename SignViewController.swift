//
//  SignViewController.swift
//  
//
//  Created by vidit jindal on 28/06/18.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import MapKit

class SignViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate{
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var createpassword: UITextField!
    @IBOutlet weak var confirmpasseord: UITextField!
    @IBOutlet var code: UIButton!
    var codes = [String: String]()
    var usernames = Set<String>()
    var emails = Set<String>()
    let toolbar = UIToolbar()
    let pickerview = UIPickerView()
    let locationmanager = CLLocationManager()
    var index = 0
    var phone1 = ""
    var image = ""
    var address = ""
    var amount = ""
    var rent = ""
    var name1 = ""
    var day = ""
    var seemail = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setuptoolbar()
        for (key,value) in codes{
            if key != "" && value != ""{
                self.code.setTitle("\(key)- \(value)", for: .normal)
            }
        }
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
            Database.database().reference().child("Email").observe(DataEventType.childAdded) { (snap) in
                if let dic = snap.value as? [String: Any]{
                    if let username1 = dic["phone"] as? String{
                        if let email = dic["email"] as? String{
                            self.usernames.insert(username1)
                            self.emails.insert(email)
                        }
                    }
                }
                Database.database().reference().child("Email").observe(DataEventType.childRemoved) { (snap) in
                    if let dic = snap.value as? [String: Any]{
                        if let username1 = dic["phone"] as? String{
                            if let email = dic["email"] as? String{
                                self.usernames.remove(username1)
                                self.emails.remove(email)
                            }
                        }
                    }
                }
            }
        })
    }
    @objc func tap1() {
        self.view.endEditing(true)
        self.resignFirstResponder()
    }
    @IBAction func signup(_ sender: Any) {
        //let activityindictor = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        //self.view.addSubview(activityindictor)
        if let names = name.text {
            if let emails = email.text {
                if let createpassword1 = createpassword.text {
                    if let confimpass = confirmpasseord.text {
                        if let phone = username.text {
                            phone1 = "+91\(phone)"
                            let index = self.usernames.firstIndex(of: phone1)
                            let index1 = self.emails.firstIndex(of: emails)
                            if emails == "" || createpassword1 == "" || confimpass == "" || phone == "" || names == ""{
                                self.displayalert(title: "Error", message: "One of the field is empty")
                            }
                            else if index1 != nil {
                                self.displayalert(title: "Error", message: "Email has already been taken")
                            }
                            else if email1(emails) == false {
                                self.displayalert(title: "Error", message: "Email is not valid")
                            }
                            else if index != nil {
                                self.displayalert(title: "Error", message: "Number has already been taken")
                            }
                            else if createpassword1 != confimpass {
                                self.displayalert(title: "Error", message: "Passwords Dont Match")
                            }
                            else if passwordcheck(createpassword1) == false {
                                self.displayalert(title: "Short Password", message: "Passoword must be bigger than or equal to 6 characters")
                            }
                            else{
                                PhoneAuthProvider.provider().verifyPhoneNumber(phone1, uiDelegate: nil) { (verificationid, error) in
                                    if error != nil {
                                        self.displayalert(title: "Error", message: error?.localizedDescription ?? "")
                                        print(error ?? "")
                                    }
                                    else{
                                        let value = ["Are you seller": false, "Name": names, "email": emails, "phone": self.phone1, "pass": createpassword1, "uid": ""] as [String: Any]
                                        UserDefaults.standard.set(verificationid, forKey: "authVerificationID")
                                        UserDefaults.standard.setValue(value, forKey: "userdefaults")
                                        self.performSegue(withIdentifier: "continue", sender: self.phone1)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func setuptoolbar() {
        email.inputAccessoryView = toolbar
        name.inputAccessoryView = toolbar
        username.inputAccessoryView = toolbar
        createpassword.inputAccessoryView = toolbar
        confirmpasseord.inputAccessoryView = toolbar
        let flexiblespace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: self, action: nil)
        let donebutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done
            , target: self, action: #selector(SignViewController.tap1))
        let items = [flexiblespace,donebutton]
        toolbar.items = items
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignViewController.tap1))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tap)
    }
    func passwordcheck(_ text: String) -> Bool {
        if text.count < 6 {
            return false
        }
        return true
    }
    func email1(_ text: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: text)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.delegate = self
        if name.resignFirstResponder() {
            email.becomeFirstResponder()
        }
        return true
    }
    func displayalert(title: String, message: String){
        let actioncontroller = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel) { (uiaction) in
            actioncontroller.dismiss(animated: true, completion: nil)
        }
        actioncontroller.addAction(action)
        present(actioncontroller, animated: true, completion: nil)
    }
    @IBAction func cancels(_ sender: Any) {
        self.performSegue(withIdentifier: "cancel", sender: self)
    }
    @IBAction func numbcheck(_ sender: UITextField) {
        if (sender.text?.count)! < 10{
            self.displayalert(title: "Invalid Nummber", message: "The number must be of 10 digits")
        }
        if (sender.text?.count)! > 10 {
            self.displayalert(title: "Invalid Nummber", message: "The number must not exceed 10 digit")
        }
    }
    @IBAction func usrname12(_ sender: UITextField) {
        if let user = sender.text {
            if user != "" {
                let index = usernames.firstIndex(of: user)
                if index != nil {
                    self.displayalert(title: "Username Taken", message: "Choose Another Username")
                }
                else{
                    sender.resignFirstResponder()
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "continue" {
            if let dest = segue.destination as? PhoneViewController {
                if let sende1 = sender as? String {
                    dest.index = self.index
                    dest.image = self.image
                    dest.amount = self.amount
                    dest.name = self.name1
                    dest.seemail = self.seemail
                    dest.rent = self.rent
                    dest.day = self.day
                    dest.address = self.address
                    dest.number1 = sende1
                }
            }
        }
    }
}
