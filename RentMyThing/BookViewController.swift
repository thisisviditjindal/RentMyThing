//
//  BookViewController.swift
//  RentMyThing
//
//  Created by vidit jindal on 01/07/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import GoogleMobileAds

class BookViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    var sell = false
    var name = ""
    var genre = ""
    var download = ""
    var condition = ""
    var price = 0
    var copies = 0
    var index = -1
    var textfield = false
    var username = [String]()
    
    
    @IBOutlet var adview: GADBannerView!
    @IBOutlet var authorname: UITextField!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var bookname: UITextField!
    @IBOutlet weak var bookgenre: UITextField!
    @IBOutlet weak var bookcond: UITextField!
    @IBOutlet weak var sellbox: UIButton!
    @IBOutlet weak var sellingprice: UITextField!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var copylabel: UITextField!
    @IBOutlet weak var required: UILabel!
    @IBOutlet weak var specify: UITextField!
    let genrenames = ["Select","Action","Adventure","Biographical","Computing, Internet and Digital","Crime","Drama","Fantasy","Fiction","Horror","Mystery","Non-Fiction","Romance","Science Fiction","Science, Techonology & Medicine","Sports", "Social","Thriller"]
    let conditionforms = ["Select","New", "Less than a month old","Two months old", "More Than 3 month old"]
    var numberv = [String]()
    let pickerview = UIPickerView()
    let pickerview1 = UIPickerView()
    let pickerview2 = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        adview.adUnitID = "ca-app-pub-3940256099942544/2934735716"
       // NotificationCenter.default.addObserver(self,selector: #selector(BookViewController.keyboardWillShow(_:)),name: Notification.Name.UIKeyboardWillShow,object: nil)
        //NotificationCenter.default.addObserver(self,selector: #selector(BookViewController.keyboardWillHide(_:)),name: Notification.Name.UIKeyboardWillHide,object: nil)
        self.specify.isHidden = true
        self.numberv.append("Select")
        for i in stride(from: 1, to: 4, by: 1) {
            self.numberv.append(String(i))
        }
        for i in stride(from: 5, to: 30, by: 5) {
            self.numberv.append(String(i))
        }
        self.numberv.append("Other(Please specify)")
        required.isHidden = true
        toolbar1()
        if index == 1 {
            if sell == true {
                sellbox.isHidden = false
                sellbox.isSelected = true
                sellbox.imageView?.image = UIImage(named: "check-mark")
                sell = false
            }
            else{
                sellbox.isHidden = true
                sellbox.isSelected = false
                sell = true
            }
            sellingprice.text = String(price)
            copylabel.text = String(copies)
            image.sd_setImage(with: URL(string: download), completed: nil)
            bookname.text = name
            bookcond.text = condition
            bookgenre.text = genre
            add.setTitle("Save Changes", for: UIControl.State.normal)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(BookViewController.tap))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tap)
        bookname.addTarget(self, action: #selector(BookViewController.text), for: UIControl.Event.editingDidBegin)
        bookgenre.addTarget(self, action: #selector(BookViewController.text), for: UIControl.Event.editingDidBegin)
        bookcond.addTarget(self, action: #selector(BookViewController.text), for: UIControl.Event.editingDidBegin)
    }

    /*
    @objc func keyboardWillShow(_ notification: Notification) {
        adjustInsetForKeyboardShow(true, notification: notification)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        adjustInsetForKeyboardShow(false, notification: notification)
    }
 */
    /*
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == bookname {
            scrollview.setContentOffset(CGPoint(x: 0, y: 30), animated: true)
        }
        else if textField == bookgenre{
            scrollview.setContentOffset(CGPoint(x: 0, y: 50), animated: true)
        }
        else if textField == bookcond{
            scrollview.setContentOffset(CGPoint(x: 0, y: 60), animated: true)
        }
        else if textField == copylabel {
            scrollview.setContentOffset(CGPoint(x: 0, y: 70), animated: true)
        }
        else if textField == sellingprice {
            scrollview.setContentOffset(CGPoint(x: 0, y: 80), animated: true)
        }
    }
 */
    func toolbar1() {
        self.pickerview.delegate = self
        self.pickerview.dataSource = self
        self.pickerview1.delegate = self
        self.pickerview1.dataSource = self
        self.pickerview2.delegate = self
        self.pickerview2.dataSource = self
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let donebutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(BookViewController.tap))
        let fixed = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        toolbar.setItems([fixed, donebutton], animated: true)
        toolbar.isUserInteractionEnabled = true
        bookgenre.inputAccessoryView = toolbar
        bookname.inputAccessoryView = toolbar
        bookcond.inputAccessoryView = toolbar
        sellingprice.inputAccessoryView = toolbar
        copylabel.inputAccessoryView = toolbar
        copylabel.inputView = pickerview2
        bookcond.inputView = pickerview1
        bookgenre.inputView = pickerview
    }
    @objc func tap() {
        self.view.endEditing(true)
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
        let action1 = UIAlertAction(title: "Take the picture of book", style: UIAlertAction.Style.default) { (action) in
            pickercontroller.sourceType = .camera
            self.present(pickercontroller, animated: true, completion: nil)
        }
        let action2 = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
            actionsheet.dismiss(animated: true, completion: nil)
        }
        actionsheet.addAction(action)
        actionsheet.addAction(action1)
        actionsheet.addAction(action2)
        if index == 1 {
            textfield = true
            present(actionsheet, animated: true, completion: nil)
        }
        else {
            present(actionsheet, animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let info1 = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            self.image.image = info1
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func Addthebook(_ sender: Any) {
        if let email = Auth.auth().currentUser?.uid {
            if let bookname1 = bookname.text {
                if let condition = bookcond.text {
                    if let bookgenre = bookgenre.text {
                        if let copies = copylabel.text {
                            if let originalprice = sellingprice.text {
                                if bookname1 == "" || condition == "Select" || bookgenre == "Select" || originalprice == ""{
                                    self.displayalert(title: "Error", message: "One Of The Field is Empty")
                                }
                                else if copies == "Select" {
                                    self.required.isHidden = false
                                }
                                else if copies == "Other(Please specify)" {
                                    if let day1 = specify.text {
                                        if day1 == "" {
                                            self.required.isHidden = false
                                        }
                                    }
                                }
                                else{
                                    if self.index == -1 {
                                        //When Adding book
                                        let string1 = NSUUID().uuidString
                                        let reference = Storage.storage().reference().child(email).child("\(string1).jpg")
                                        let activityindictor = UIActivityIndicatorView()
                                        self.view.addSubview(activityindictor)
                                        activityindictor.frame = CGRect(x: 0, y: 0, width: 55, height: 55)
                                        activityindictor.center = self.view.center
                                        activityindictor.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
                                        if let image1 = self.image.image {
                                            if self.image.image == nil {
                                                self.displayalert(title: "Error", message: "The Photo of the book is Necessary")
                                            }
                                            else {
                                                activityindictor.startAnimating()
                                                UIApplication.shared.beginIgnoringInteractionEvents()
                                                let imagedata = image1.jpegData(compressionQuality: 0.1)
                                                reference.putData(imagedata!, metadata: nil){( meta, error) in
                                                    if error != nil {
                                                        self.displayalert(title: "Error", message: (error?.localizedDescription)!)
                                                        UIApplication.shared.endIgnoringInteractionEvents()
                                                        activityindictor.stopAnimating()
                                                    }
                                                    else{
                                                        reference.downloadURL(completion: { (URl, error) in
                                                            if error != nil {
                                                                self.displayalert(title: "Error", message: (error?.localizedDescription)!)
                                                            }
                                                            else{
                                                                var value = [String: Any]()
                                                                if copies == "Other(Please specify)" {
                                                                    value = ["Book Name": bookname1, "Book Condition": condition, "Book Genre": bookgenre,"Book Sell": self.sell, "Book Image": URl?.absoluteString ?? "","Book Image Path": meta?.path ?? "","Book Copies": Int(self.specify.text ?? "") ?? "","Book O Price": Int(originalprice) ?? "", "IsBookRented": false, "IsBookSold": false,"Books Sold": 0, "Books Rented": 0, "Book Seller": Auth.auth().currentUser?.uid ?? ""]
                                                                }
                                                                else{
                                                                    value = ["Book Name": bookname1, "Book Condition": condition, "Book Genre": bookgenre,"Book Sell": self.sell, "Book Image": URl?.absoluteString ?? "","Book Image Path": meta?.path ?? "","Book Copies": Int(copies) ?? "","Book O Price": Int(originalprice) ?? "", "IsBookRented": false, "IsBookSold": false, "Books Sold": 0, "Books Rented": 0, "Book Seller": Auth.auth().currentUser?.uid ?? ""]
                                                                }
                                                                Database.database().reference().child("Seller Inventory").child(email).childByAutoId().setValue(value)
                                                                UIApplication.shared.endIgnoringInteractionEvents()
                                                                activityindictor.stopAnimating()
                                                                self.performSegue(withIdentifier: "bookshow", sender: self)
                                                            }
                                                        })
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    else {
                                        Database.database().reference().child("Seller Inventory").child(email).queryOrdered(byChild: "Book Image").queryEqual(toValue: download).observe(DataEventType.childAdded, with: { (snap) in
                                            let activityindictor = UIActivityIndicatorView()
                                            self.view.addSubview(activityindictor)
                                            activityindictor.frame = CGRect(x: 0, y: 0, width: 55, height: 55)
                                            activityindictor.center = self.view.center
                                            activityindictor.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
                                            if self.textfield == true {
                                                let string1 = NSUUID().uuidString
                                                let reference = Storage.storage().reference().child(email).child("\(string1).jpg")
                                                if let dic = snap.value as? [String: Any] {
                                                    if let imagepath = dic["Book Image Path"] as? String {
                                                        let ref = Storage.storage().reference().child(imagepath)
                                                        if let image1 = self.image.image {
                                                            if self.image.image == nil {
                                                                self.displayalert(title: "Error", message: "The Photo of the book is Necessary")
                                                            }
                                                            else{
                                                                activityindictor.startAnimating()
                                                                UIApplication.shared.beginIgnoringInteractionEvents()
                                                                let imagedata = image1.jpegData(compressionQuality: 0.1)
                                                                reference.putData(imagedata!, metadata: nil){( meta, error) in
                                                                    if error != nil {
                                                                        self.displayalert(title: "Error", message: (error?.localizedDescription)!)
                                                                        UIApplication.shared.endIgnoringInteractionEvents()
                                                                        activityindictor.stopAnimating()
                                                                    }
                                                                    else{
                                                                        reference.downloadURL(completion: { (URl, error) in
                                                                            if error != nil {
                                                                                self.displayalert(title: "Error", message: (error?.localizedDescription)!)
                                                                            }
                                                                            else{
                                                                                ref.delete(completion: { (error) in
                                                                                    if error != nil {
                                                                                        print("Error in connectivity")
                                                                                    }
                                                                                })
                                                                                snap.ref.child("Book Name").setValue(bookname1)
                                                                                snap.ref.child("Book Condition").setValue(condition)
                                                                                snap.ref.child("Book Genre").setValue(bookgenre)
                                                                                if copies == "Other(Please specify)" {
                                                                                    snap.ref.child("Book Copies").setValue(Int(self.specify.text ?? ""))
                                                                                }
                                                                                else{
                                                                                    snap.ref.child("Book Copies").setValue(Int(copies))
                                                                                }
                                                                                snap.ref.child("Book Image").setValue(URl?.absoluteString)
                                                                                snap.ref.child("Book Image Path").setValue(meta?.path)
                                                                                UIApplication.shared.endIgnoringInteractionEvents()
                                                                                activityindictor.stopAnimating()
                                                                                self.performSegue(withIdentifier: "bookshow", sender: self)
                                                                            }
                                                                        })
                                                                        
                                                                    }
                                                                }
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
                    }
                }
            }
        }
    }
    @IBAction func sellcheck(_ sender: Any) {
        if sell == false{
            sellbox.imageView?.image = UIImage(named: "check-mark")
            sell = true
            sellbox.isSelected = true
        }
        else {
            sellbox.imageView?.image = UIImage(named: "")
            sell = false
            sellbox.isSelected = false
        }
    }
    @IBAction func cancelbutton(_ sender: Any) {
        if index == 1 {
            if textfield == true {
                self.alert(title: "Not Saved", message: "Please Save The Changes")
            }
            else {
                self.performSegue(withIdentifier: "cancel", sender: self)
            }
        }
        else {
            if textfield == true {
                self.alert(title: "Not Saved!", message:"Please click 'Add the book' to add the book")
            }
            else {
                self.performSegue(withIdentifier: "cancel", sender: self)
            }
        }
    }
    func alert(title: String, message: String){
        let actioncontroller = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "ok", style: UIAlertAction.Style.default) { (uiaction) in
            actioncontroller.dismiss(animated: true, completion: nil)
        }
        let action1 = UIAlertAction(title: "cancel", style: UIAlertAction.Style.cancel) { (actin) in
            self.performSegue(withIdentifier: "cancel", sender: self)
        }
        actioncontroller.addAction(action)
        actioncontroller.addAction(action1)
        present(actioncontroller, animated: true, completion: nil)
    }
    @objc func text() {
        self.textfield = true
    }
    func displayalert(title: String, message: String){
        let actioncontroller = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel) { (uiaction) in
            actioncontroller.dismiss(animated: true, completion: nil)
        }
        actioncontroller.addAction(action)
        present(actioncontroller, animated: true, completion: nil)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerview {
            return self.genrenames.count
        }
        else if pickerView == pickerview2 {
            return self.numberv.count
        }
        else {
            return self.conditionforms.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerview {
            return self.genrenames[row]
        }
        else if pickerView == pickerview2 {
            return self.numberv[row]
        }
        else{
            return self.conditionforms[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerview {
            self.bookgenre.text = self.genrenames[row]
        }
        else if pickerView == pickerview2 {
             self.copylabel.text = self.numberv[row]
        }
        else{
            self.bookcond.text = self.conditionforms[row]
        }
    }
    @IBAction func cehckprice(_ sender: Any) {
        if let condition = bookcond.text {
            if let copies = copylabel.text {
                if let originalprice = sellingprice.text {
                    if condition == "" || originalprice == ""{
                        self.displayalert(title: "Error", message: "One Of The Field is Empty")
                    }
                    else if copies == "" {
                        self.required.isHidden = false
                    }
                }
            }
        }
    }
    
    @IBAction func text1(_ sender: UITextField) {
        if sender.text == "Other(Please specify)" {
            self.required.center.x = 221
            self.specify.isHidden = false
        }
        else {
            self.required.center.x = 101
            self.specify.isHidden = true
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "renting" {
            if let destin = segue.destination as? RateViewController {
                destin.originalprice = sellingprice.text!
                destin.days = copylabel.text!
                destin.condition = bookcond.text!
            }
        }
    }
    /*2
    func adjustInsetForKeyboardShow(_ show: Bool, notification: Notification) {
        let userInfo = notification.userInfo ?? [:]
        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let adjustmentHeight = (keyboardFrame.height + 20) * (show ? 1 : -1)
        scrollview.contentInset.bottom += adjustmentHeight
        scrollview.scrollIndicatorInsets.bottom += adjustmentHeight
    }
 */
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
