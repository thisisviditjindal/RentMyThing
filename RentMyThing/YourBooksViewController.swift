//
//  YourBooksViewController.swift
//  RentMyThing
//
//  Created by vidit jindal on 02/08/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class YourBooksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var labelbook: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    var currentbook = [DataSnapshot]()
    var rentedbook = [DataSnapshot]()
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        if index == -4 {
            let button = UIBarButtonItem(image: #imageLiteral(resourceName: "backward-arrow"), style: UIBarButtonItem.Style.done, target: self, action: #selector(back))
            self.navigationItem.leftBarButtonItem = button
            self.navigationItem.leftBarButtonItem?.imageInsets.left = -9
        }
        if Auth.auth().currentUser != nil {
            Database.database().reference().child("RentedBook").child(Auth.auth().currentUser?.uid ?? "").observe(DataEventType.childAdded) { (snap) in
                if let dic = snap.value as? [String: Any] {
                    if let rent = dic["IsBookRented"] as? Bool {
                        if rent == true {
                            self.rentedbook.append(snap)
                            self.currentbook.append(snap)
                            self.tableview.reloadData()
                        }
                        else{
                            self.rentedbook.append(snap)
                            self.tableview.reloadData()
                        }
                    }
                }
            }
            if segment.selectedSegmentIndex == 0 {
                self.labelbook.text = "Total Money Saved: "
            }
            else {
                self.labelbook.text = "Moeny to be paid: "
            }
        }
        else {
            
        }
    }
    @objc func back() {
        self.performSegue(withIdentifier: "back", sender: self)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Auth.auth().currentUser != nil {
            if segment.selectedSegmentIndex == 1 {
                return rentedbook.count
            }
            else {
                return currentbook.count
            }
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuse", for: indexPath) as? YourbookTableViewCell
        if segment.selectedSegmentIndex == 1 {
            if let dic = rentedbook[indexPath.row].value as? [String: Any]{
                if let bookimage = dic["Book Image"] as? String {
                    if let name = dic["Book Name"] as? String {
                        if let genre = dic["Rent"] as? Int{
                            cell?.bookname.text = name
                            cell?.imagev.sd_setImage(with: URL(string: bookimage), completed: nil)
                            cell?.bookgenre.text = String(genre)
                        }
                    }
                }
            }
        }
        else{
            if let dic = currentbook[indexPath.row].value as? [String: Any]{
                if let bookimage = dic["Book Image"] as? String {
                    if let name = dic["Book Name"] as? String {
                        if let genre = dic["Rent"] as? Int{
                            cell?.bookname.text = name
                            cell?.imagev.sd_setImage(with: URL(string: bookimage), completed: nil)
                            cell?.bookgenre.text = String(genre)
                        }
                    }
                }
            }
        }
        return cell!
    }
    @IBAction func segment(_ sender: UISegmentedControl) {
        self.view.reloadInputViews()
        self.tableview.reloadData()
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
