//
//  MainTableViewController.swift
//  RentMyThing
//
//  Created by vidit jindal on 28/06/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import UserNotifications
import FirebaseInstanceID
class MainTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, MyCustomCellDelegator{
    @IBOutlet weak var sidebutton: UIBarButtonItem!
    var books = [String:[String]]()
    var genre = [String]()
    var name = ""
    var side = false
    var index = 0
    var renter = false
    let refresh = UIRefreshControl()
    let label1 = UILabel()
    let button1 = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        var dict = UserDefaults.standard.dictionary(forKey: "userdefaults")
        if let dic = dict {
            if let name = dic["Name"] as? String {
                if name == Auth.auth().currentUser?.displayName {
                    dict?.updateValue(Auth.auth().currentUser?.uid ?? "", forKey: "uid")
                }
            }
        }
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all 
        self.navigationController?.navigationBar.prefersLargeTitles = true
        addnotifiction()
        let pangesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(MainTableViewController.side(_:)))
        self.view.addGestureRecognizer(pangesture)
        self.view.addSubview(refresh)
        refresh.center = self.view.center
        refresh.tintColor = UIColor.darkGray
        //self.refresh.beginRefreshing()
        //self.tableView.reloadData()
        //self.refresh.endRefreshing()
        books.removeAll()
        genre.removeAll()
        let activityindictor = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityindictor.center = view.center
        activityindictor.tintColor = UIColor.darkGray
        self.view.addSubview(activityindictor)
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if snapshot.value as? Bool ?? false {
                self.tableView.separatorStyle = .singleLine
                
                    Database.database().reference().child("Email").observe(DataEventType.childAdded) { (snap) in
                        //activityindictor.startAnimating()
                        if let dic = snap.value as? [String: Any] {
                            if let renter1 = dic["Are you seller"] as? Bool {
                                if renter1{
                                     self.renter = true
                                }
                                else {
                                    self.renter = false
                                }
                            }
                            if let email1 = dic["uid"] as? String{
                                Database.database().reference().child("Seller Inventory").child(email1).observe(DataEventType.childAdded, with: { (snap1) in
                                    if let dic = snap1.value as? [String: Any] {
                                        if let bookgenr = dic["Book Genre"] as? String {
                                            if let bookimage = dic["Book Image"] as? String {
                                                let index = self.genre.firstIndex(of: bookgenr)
                                                if index == nil {
                                                    self.genre.append(bookgenr)
                                                    print("Checking")
                                                    self.tableView.reloadData()
                                                }
                                                let index1 = self.books[bookgenr]?.firstIndex(of: bookimage)
                                                if index1 == nil {
                                                    self.books(key: bookgenr, values: bookimage)
                                                    self.tableView.reloadData()
                                                }
                                            }
                                        }
                                    }
                                    //self.tableView.reloadData()
                                    //activityindictor.stopAnimating()
                                })
                            }
                        }
                    }
                
            }
            else {
                self.tableView.separatorStyle = .none
                /*
                self.label.topAnchor.constraint(equalTo: self.view.topAnchor)
                self.label.leftAnchor.constraint(equalTo: self.view.leftAnchor)
                self.label.rightAnchor.constraint(equalTo: self.view.rightAnchor)
                self.label.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
                self.view.addSubview(self.label)
 */
                self.dispaly()
                self.tableView.reloadData()
            }
        })
        let handle = Auth.auth().addStateDidChangeListener { (auth, user1) in
            if auth.currentUser != nil {
                self.index = 0
            }
            else {
                self.index = -1
            }
        }
        if Auth.auth().currentUser != nil {
            Auth.auth().removeStateDidChangeListener(handle)
        }
        self.tableView.reloadData()
    }

    var label: UILabel{
        let label1 = UILabel()
        label1.text = "No Connection"
        return label1
    }
    func addnotifiction() {
        NotificationCenter.default.addObserver(self, selector: #selector(showProfile(_:)),name: NSNotification.Name("ShowProfile"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(showSettings(_:)),name: NSNotification.Name("ShowSettings"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(yourbook(_:)),name: NSNotification.Name("yourbooks"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(renting(_:)),name: NSNotification.Name("startrenting"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(wish(_:)),name: NSNotification.Name("Wishlist"),object: nil)
    }
    @objc func showProfile(_ not: Notification) {
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "ShowProfile", sender: nil)
        }
        else {
            if let user = not.object as? SideTableViewController{
                self.index = user.index
                let index1 = user.index
                performSegue(withIdentifier: "usersignin", sender: index1)
            }
        }
    }
    @objc func wish(_ not: Notification) {
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "wishlist", sender: nil)
        }
        else {
            if let user = not.object as? SideTableViewController{
                self.index = user.index
                let index1 = user.index
                performSegue(withIdentifier: "usersignin", sender: index1)
            }
        }
    }
    @objc func showSettings(_ not: Notification) {
        performSegue(withIdentifier: "settings", sender: nil)
    }
    @objc func yourbook(_ not: Notification){
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "yourbooks", sender: nil)
        }
        else{
            if let user = not.object as? SideTableViewController{
                self.index = user.index
                let index1 = user.index
                performSegue(withIdentifier: "usersignin", sender: index1)
            }
        }
    }
    @objc func renting(_ not: Notification){
        if Auth.auth().currentUser != nil {
            if self.renter == true {
                performSegue(withIdentifier: "sellerback", sender: nil)
            }
            else {
                performSegue(withIdentifier: "startrenting", sender: nil)
            }
        }
        else {
            if let user = not.object as? SideTableViewController{
                self.index = user.index
                let index1 = user.index
                performSegue(withIdentifier: "usersignin", sender: index1)
            }
        }
    }
    
    @IBAction func search(_ sender: Any) {
        self.performSegue(withIdentifier: "segue", sender: self)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.genre.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let gnere = self.genre[collectionView.tag]
        return (self.books[gnere]!.count)
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? MainTableViewCell else{
            return
        }
        cell.collectionview.delegate = self
        cell.collectionview.dataSource = self
        cell.collectionview.tag = indexPath.row
        cell.collectionview.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.reloadData()
        if side {
            NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: self)
            side = false
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "books", for: indexPath) as? CollectionViewCell
        let gnere = self.genre[collectionView.tag]
        let book = self.books[gnere]![indexPath.item]
        cell?.image1.sd_setImage(with: URL(string: book), completed: nil)
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let genre = self.genre[indexPath.row]
        self.performSegue(withIdentifier: "showgenre", sender: genre)
        if side {
            NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: self)
            side = false
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? MainTableViewCell
        let genre1 = self.genre[indexPath.row]
        cell?.name.text = genre1
        cell?.delegate = self
        return cell!
    }
    func callSegueFromCell(myData dataobject: String) {
        self.performSegue(withIdentifier: "showgenre", sender: dataobject)
    } 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "booksforrent":
            if let destination = segue.destination as? ContainerViewController2 {
                if let sender1: CollectionViewCell = sender as? CollectionViewCell{
                    if let collectionview: UICollectionView = sender1.superview as? UICollectionView{
                        let indexpath = collectionview.indexPath(for: sender1)
                        let genre = self.genre[collectionview.tag]
                        let book = self.books[genre]![(indexpath?.item)!]
                        destination.bookname = book
                        destination.index1 = self.index
                    }
                }
            }
        case "showgenre":
            if let destination = segue.destination as? CollectionViewController {
                if let sender1 = sender as? String {
                    destination.genre = sender1
                }
            }
        case "segue":
            if let nav = segue.destination as? UINavigationController {
                if let dest = nav.topViewController as? SearchTableViewController {
                    dest.index = self.index
                }
            }
        case "settings":
            if Auth.auth().currentUser != nil {
                if let dest = segue.destination as? SettingsTableViewController {
                    dest.index = self.index
                }
            }
            else{
                if let dest = segue.destination as? SettingsTableViewController {
                    dest.index = self.index
                }
            }
        case "usersignin":
            if let nav = segue.destination as? UINavigationController {
                if let dest = nav.topViewController as? MainViewController{
                    if let sender1 = sender as? Int{
                        dest.index = sender1
                    }
                }
            }
        default:
            print("done")
        }
    }
    func dispaly() {
        let actioncontroller = UIAlertController(title: "Connection Error", message:"", preferredStyle: UIAlertController.Style.actionSheet)
        let action1 = UIAlertAction(title: "Try Again", style: UIAlertAction.Style.cancel) { (action) in
            self.tableView.reloadData()
            actioncontroller.dismiss(animated: true, completion: nil)
        }
        actioncontroller.addAction(action1)
        self.present(actioncontroller, animated: true, completion: nil)
    }
    func displayalert(title: String, message: String){
        let actioncontroller = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel) { (uiaction) in
            actioncontroller.dismiss(animated: true, completion: nil)
        }
        actioncontroller.addAction(action)
        present(actioncontroller, animated: true, completion: nil)
    }
    @IBAction func side(_ sender: Any) {
        if side {
            side = false
        }
        else {
            side = true
        }
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: self)
    }
    
    func books(key: String, values: String) {
        if var val = books[key] {
            val.append(values)
            books[key] = val
        }
        else {
            books[key] = [values]
        }
        self.tableView.reloadData()
    }
}
/*
 func tap1() {
 self.button1.setTitle("Try Again", for: UIControlState.highlighted)
 self.button1.center = self.view.center
 //self.button1.addTarget(self, action: #selector(MainTableViewController.tap1), for: UIControlEvents.touchUpInside)
 self.label1.text = "No Internet Connection"
 self.label1.center = self.view.center
 self.label1.textColor = UIColor.darkGray
 self.tableView.reloadData()
 Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
 self.refresh.beginRefreshing()
 }
 self.refresh.endRefreshing()
 }
 */
/*
 Database.database().reference().child("Email").queryOrdered(byChild: "Are you seller").queryEqual(toValue: true).observe(DataEventType.childAdded) { (snap) in
 activityindictor.startAnimating()
 if let dic = snap.value as? [String: Any] {
 if let email1 = dic["uid"] as? String{
 let maincore = Database.database().reference(withPath: "/Seller Inventory/\(email1)")
 maincore.keepSynced(true)
 maincore.queryOrderedByValue().queryLimited(toLast: 4).observe(DataEventType.childAdded, with: { (snap2) in
 if let dic = snap2.value as? [String: Any] {
 if let bookgenr = dic["Book Genre"] as? String {
 if let bookimage = dic["Book Image"] as? String {
 let index = self.genre.index(of: bookgenr)
 if index == nil {
 self.genre.append(bookgenr)
 self.tableView.reloadData()
 }
 self.books(key: bookgenr, values: bookimage)
 self.tableView.reloadData()
 }
 }
 }
 self.tableView.reloadData()
 activityindictor.stopAnimating()
 })
 }
 }
 }
 */
