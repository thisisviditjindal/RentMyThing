//
//  MainViewController.swift
//  RentMyThing
//
//  Created by vidit jindal on 28/06/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseInstanceID

class MainViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet var label: UILabel!
    var index = 0
    var image = ""
    var address = ""
    var rent = ""
    var name = ""
    var day = ""
    var seemail = ""
    var amount = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        print(index)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(MainViewController.back))
        let tap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.tap1))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tap)
        self.navigationItem.hidesBackButton = true
    }
    @objc func back() {
        self.performSegue(withIdentifier: "backwith", sender: self)
    }
    @objc func tap1() {
        self.view.endEditing(true)
        self.resignFirstResponder()
    }
    @IBAction func login(_ sender: Any) {
        if let emails = email.text {
            if let password1 = password.text {
                if emails == "" || password1 == "" {
                    self.displayalert(title: "Error", message: "One of The Field Is Empty")
                }
                else{
                    Auth.auth().signIn(withEmail: emails, password: password1) { (result, error) in
                        if error != nil{
                            self.displayalert(title: "Error", message: (error?.localizedDescription)!)
                        }
                        else {
                            switch self.index {
                            case -1:
                                Database.database().reference().child("RentedBook").child((Auth.auth().currentUser?.uid)!).queryOrdered(byChild: "Book Image").queryEqual(toValue: self.image).observe(DataEventType.childAdded) { (snap) in
                                    if (snap.value as? [String: Any]) != nil {
                                        print("test1yfyf")
                                        self.index = 8
                                        self.performSegue(withIdentifier: "buyit", sender: self.image)
                                        self.navigationController?.setNavigationBarHidden(false, animated: true)
                                      //  self.instanceid()
                                    }
                                }
                            case -2:
                                self.performSegue(withIdentifier: "profileback", sender: self.index)
                                //self.instanceid()
                            case -3:
                                self.performSegue(withIdentifier: "wishlistback", sender: self.index)
                                //self.instanceid()
                            case -4:
                                self.performSegue(withIdentifier: "yourbooksback", sender: self.index)
                                //self.instanceid()
                            case -5:
                                Database.database().reference().child("Email").queryOrdered(byChild: "email").queryEqual(toValue: emails).observe(DataEventType.childAdded, with: { (snap) in
                                    if let dic = snap.value as? [String: Any] {
                                        if let bool = dic["Are you seller"] as? Bool {
                                            if bool == true {
                                                self.performSegue(withIdentifier: "rentingback", sender: self.index)
                                            }
                                            else {
                                                self.performSegue(withIdentifier: "address", sender: self)
                                            }
                                        }
                                    }
                                })
                                //self.instanceid()
                            default:
                                self.performSegue(withIdentifier: "backwith", sender: self)
                                //self.instanceid()
                            }
                        }
                    }
                }
            }
        }
    }
    /*func instanceid(){
        if let emails = email.text {
            Database.database().reference().child("Email").queryOrdered(byChild: "email").queryEqual(toValue: emails).observe(DataEventType.childAdded, with: { (snap) in
                if let token = InstanceID.instanceID().token(withAuthorizedEntity: <#String#>, scope: <#String#>, handler: <#InstanceIDTokenHandler#>) {
                    snap.ref.child("Token").setValue(token)
                }
            })
        }
    */
    func displayalert(title: String, message: String){
        let actioncontroller = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel) { (uiaction) in
            actioncontroller.dismiss(animated: true, completion: nil)
        }
        actioncontroller.addAction(action)
        present(actioncontroller, animated: true, completion: nil)
    }
    @IBAction func forgotpssword(_ sender: Any) {
        performSegue(withIdentifier: "forgot", sender: self)
    }
    
    @IBAction func Signup(_ sender: Any) {
        performSegue(withIdentifier: "signup", sender: self.image)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "signup":
            if let dest = segue.destination as? SignViewController {
                if let sender1 = sender as? String {
                    dest.index = self.index
                    dest.image = sender1
                    dest.amount = self.amount
                    dest.name1 = self.name
                    dest.seemail = self.seemail
                    dest.rent = self.rent
                    dest.day = self.day
                    dest.address = self.address
                }
            }
        case "buyit":
            if let nav = segue.destination as? UINavigationController {
                if let dest = nav.topViewController as? EndRentViewController{
                    if let sender1 = sender as? String {
                        dest.index = self.index
                        dest.image = sender1
                        dest.amount = self.amount
                        dest.name = self.name
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
