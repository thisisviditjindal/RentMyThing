//
//  PhoneViewController.swift
//  RentMyThing
//
//  Created by vidit jindal on 28/07/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
//import FirebaseUI
import FirebaseInstanceID
class PhoneViewController: UIViewController, UITableViewDelegate{
    
    @IBOutlet weak var cell: UITableViewCell!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var entercode: UITextField!
    @IBOutlet weak var label1: UILabel!
    var image = ""
    var index = 0
    var number1 = ""
    var email = ""
    var address = ""
    var amount = ""
    var rent = ""
    var name = ""
    var day = ""
    var seemail = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        print(number1)
        self.label1.isHidden = true
        self.number.text = self.number1
        self.number.sizeToFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func verify(_ sender: Any) {
        //let activityindictor = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        if let numb = entercode.text {
            if numb == "" {
                self.label1.isHidden = false
            }
            else{
                let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
                let credentional = PhoneAuthProvider.provider().credential(withVerificationID: verificationID ?? "", verificationCode: numb)
                Auth.auth().signIn(with: credentional) { (result, error) in
                    if error != nil {
                        self.displayalert(title: "Error", message: error?.localizedDescription ?? "")
                    }
                    else {
                        switch self.index {
                        case 0:
                            self.authentication()
                            self.performSegue(withIdentifier: "verify", sender: self)
                        case -1:
                            Database.database().reference().child("RentedBook").child((Auth.auth().currentUser?.uid)!).queryOrdered(byChild: "Book Image").queryEqual(toValue: self.image).observe(DataEventType.childAdded) { (snap) in
                                if (snap.value as? [String: Any]) != nil {
                                    self.index = 8
                                    self.authentication()
                                    self.performSegue(withIdentifier: "rentit", sender: self.image)
                                }
                            }
                        case -2:
                            self.authentication()
                            self.performSegue(withIdentifier: "profileback", sender: self.index)
                        case -3:
                            self.authentication()
                            self.performSegue(withIdentifier: "wishlistback", sender: self.index)
                        case -4:
                            self.authentication()
                            self.performSegue(withIdentifier: "yourbooksback", sender: self.index)
                        case -5:
                            self.authentication()
                            self.performSegue(withIdentifier: "address", sender: self)       
                        default:
                            print("Done")
                        }
                    }
                }
            }
        }
    }
    func authentication() {
        var dict = UserDefaults.standard.dictionary(forKey: "userdefaults")
        if let dic = dict {
            if let email = dic["email"] as? String {
                if let phone = dic["phone"] as? String {
                    self.number1 = phone
                    if let name = dic["Name"] as? String {
                        if let seller = dic["Are you seller"] as? Bool {
                            if let password = dic["pass"] as? String {
                                let request = Auth.auth().currentUser?.createProfileChangeRequest()
                                request?.displayName = name
                                request?.commitChanges(completion: nil)
                                Auth.auth().currentUser?.updateEmail(to: email) { (error) in
                                    if error != nil {
                                        print(error?.localizedDescription ?? "rjvfn")
                                    }
                                    else {
                                        if let dic = dict {
                                            if let name = dic["Name"] as? String {
                                                if name == Auth.auth().currentUser?.displayName {
                                                    dict?.updateValue(Auth.auth().currentUser?.uid ?? "", forKey: "uid")
                                                }
                                            }
                                        }
                                    }
                                }
                                Auth.auth().currentUser?.updatePassword(to: password) { (error) in
                                    if error != nil {
                                        print(error?.localizedDescription ?? "rjvfr3r3vn")
                                    }
                                }
                                /*if let token = InstanceID.instanceID().token() {
                                    let value = ["Are you seller": seller, "Name": name, "email": email, "phone": phone, "uid": Auth.auth().currentUser?.uid ?? "", "Token": token] as [String: Any]
                                    Database.database().reference().child("Email").childByAutoId().setValue(value)
                                }*/
                            }
                        }
                    }
                }
            }
        }
    }
    @IBAction func cellaction(_ sender: Any) {
        PhoneAuthProvider.provider().verifyPhoneNumber(self.number1, uiDelegate: nil) { (verificationid, error) in
            if error != nil {
                self.displayalert(title: "Error", message: error?.localizedDescription ?? "")
            }
            else{
                UserDefaults.standard.set(verificationid, forKey: "authVerificationID")
            }
        }
    }
    @IBAction func backbutton(_ sender: Any) {
        self.performSegue(withIdentifier: "back", sender: self)
    }
    @IBAction func changenumber(_ sender: Any) {
        self.performSegue(withIdentifier: "back", sender: self)
    }
    func displayalert(title: String, message: String){
        let actioncontroller = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel) { (uiaction) in
            actioncontroller.dismiss(animated: true, completion: nil)
        }
        actioncontroller.addAction(action)
        present(actioncontroller, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "verify":
            if let sender1 = sender as? String {
                if let destination = segue.destination as? MainTableViewController {
                    destination.name = sender1
                    destination.index = 4
                }
            }
        case "rentit":
            if let nav = segue.destination as? UINavigationController {
                if let dest = nav.topViewController as? EndRentViewController {
                    if let sender1 = sender as? String {
                        dest.index = self.index
                        dest.image = sender1
                        dest.name = self.name
                        dest.amount = self.amount
                        dest.seemail = self.seemail
                        dest.rent = self.rent
                        dest.day = self.day
                        dest.address = self.address
                    }
                }
            }
        case "profileback":
            if let nav = segue.destination as? UINavigationController {
                if let dest = nav.topViewController as? ProfileViewController {
                    dest.index = self.index
                }
            }
        case "wishlistback":
            if let nav = segue.destination as? UINavigationController {
                if let dest = nav.topViewController as? WishListTableViewController {
                    dest.index = self.index
                }
            }
        case "yourbooksback":
            if let nav = segue.destination as? UINavigationController {
                if let dest = nav.topViewController as? YourBooksViewController {
                    dest.index = self.index
                }
            }
        default:
            print("Done")
        }
    }
}
