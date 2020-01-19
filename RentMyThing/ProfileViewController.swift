//
//  ProfileViewController.swift
//  RentMyThing
//
//  Created by vidit jindal on 29/06/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet var tap: UITapGestureRecognizer!
    @IBOutlet var wishlist: UICollectionView!
    @IBOutlet var image1: Image1!
    @IBOutlet var name: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var phonenumber: UITextField!
    @IBOutlet var password: UITextField!
    var changed = true
    var texting = false
    var data = [String]()
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        if index == -2 {
            let button = UIBarButtonItem(image: #imageLiteral(resourceName: "backward-arrow"), style: UIBarButtonItem.Style.done, target: self, action: #selector(back))
            self.navigationItem.leftBarButtonItem = button
            self.navigationItem.leftBarButtonItem?.imageInsets.left = -9
        }
        self.tap.isEnabled = false
        wishlist.delegate = self
        wishlist.dataSource = self
        Database.database().reference().child("WishList").child(Auth.auth().currentUser?.uid ?? "").observe(DataEventType.childAdded, with: { (snap1) in
            if let dic = snap1.value as? [String: String]{
                if let image = dic["Book Image"]  {
                    let index = self.data.firstIndex(of: image)
                    if index == nil {
                        self.data.append(image)
                        self.wishlist.reloadData()
                    }
                }
            }
        })
        Database.database().reference().child("WishList").child(Auth.auth().currentUser?.uid ?? "").observe(DataEventType.childRemoved, with: { (snap2) in
            if let dic = snap2.value as? [String: String]{
                if let image = dic["Book Image"]  {
                    if let index = self.data.firstIndex(of: image) {
                        self.data.remove(at: index)
                        self.wishlist.reloadData()
                    }
                }
            }
        })
        let dict = UserDefaults.standard.dictionary(forKey: "userdefaults")
        if let dic = dict {
                if let phone = dic["phone"] as? String {
                    if let name = dic["Name"] as? String {
                        if let user = dic["email"] as? String {
                            self.name.text = name
                            self.email.text = user
                            self.phonenumber.text = phone
                            self.password.isSecureTextEntry = true
                        }
                    }
                }
            
            if let pass = dic["pass"] as? String {
                self.password.text = pass
            }
        }
    }
    @objc func back() {
        self.performSegue(withIdentifier: "back", sender: self)
    }
    @IBAction func photo(_ sender: Any) {
        let pickercontroller = UIImagePickerController()
        pickercontroller.allowsEditing = true
        pickercontroller.delegate = self
        let actionsheet = UIAlertController(title: "Choose", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        let action = UIAlertAction(title: "Choose From Library", style: UIAlertAction.Style.default) { (action) in
            pickercontroller.sourceType = .photoLibrary
            self.present(pickercontroller, animated: true, completion: nil)
        }
        let action1 = UIAlertAction(title: "Take your picture", style: UIAlertAction.Style.default) { (action) in
            pickercontroller.sourceType = .camera
            self.present(pickercontroller, animated: true, completion: nil)
        }
        let action2 = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
            actionsheet.dismiss(animated: true, completion: nil)
        }
        actionsheet.addAction(action)
        actionsheet.addAction(action1)
        actionsheet.addAction(action2)
        present(actionsheet, animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("nen")
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuse", for: indexPath) as? WishListCollectionViewCell
        cell?.image1.sd_setImage(with: URL(string: self.data[indexPath.item]), completed: nil)
        return cell!
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func email1(_ text: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: text)
    }
    @IBAction func emailtexting(_ sender: UITextField) {
        if let text = sender.text {
            if email1(text) == false {
                self.displayalert(title: "Email Invalid", message: "Write a valid email")
                self.texting = false
            }
            else {
                self.texting = true
            }
        }
    }
    @IBAction func nametext(_ sender: UITextField) {
        if let text = sender.text {
            if text == "" {
                self.texting = false
            }
            else{
                self.texting = true
            }
        }
    }
    @IBAction func savechanges(_ sender: UIBarButtonItem) {
        if changed {
            self.tap.isEnabled = true
            self.navigationItem.hidesBackButton = true
            sender.title = "Save changes"
            self.name.isEnabled = false
            self.email.isEnabled = false
            if self.texting == true {
                let changeprofile = Auth.auth().currentUser?.createProfileChangeRequest()
                changeprofile?.displayName = name.text
                changeprofile?.commitChanges(completion: nil)
                Auth.auth().currentUser?.updateEmail(to: email.text ?? "", completion: { (error) in
                    if error != nil {
                        print("Error: \(error?.localizedDescription ?? "")")
                    }
                })
            }
            changed = false
        }
        else{
            self.tap.isEnabled = false
            self.navigationItem.hidesBackButton = false
            sender.title = "Edit"
            self.name.isEnabled = true
            self.email.isEnabled = true
            changed = true
        }
    }
    @IBAction func edit(_ sender: Any) {
        self.performSegue(withIdentifier: "edit", sender: self)
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
    }
}
