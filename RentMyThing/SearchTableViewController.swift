//
//  SearchTableViewController.swift
//  RentMyThing
//
//  Created by vidit jindal on 15/08/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit
import FirebaseDatabase
class SearchTableViewController: UITableViewController, UISearchBarDelegate{
    @IBOutlet var searchbar: UISearchBar!
    var bookname = [String]()
    var selectedsearch = [String]()
    var cuurentbookname = [String]()
    var search = false
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        self.navigationController?.navigationBar.isHidden = true
        searchbar.becomeFirstResponder()
        searchbar.delegate = self
        searchbar.placeholder = "Search For Books"
        Database.database().reference().child("Email").queryOrdered(byChild: "Are you seller").queryEqual(toValue: true).observe(DataEventType.childAdded) { (snap) in
            if let dic = snap.value as? [String: Any] {
                if let email = dic["uid"] as? String {
                    Database.database().reference().child("Seller Inventory").child(email).observe(DataEventType.childAdded, with: { (snap1) in
                        if let dic1 = snap1.value as? [String: Any] {
                            if let name = dic1["Book Name"] as? String {
                                self.bookname.append(name)
                                //self.cuurentbookname.append(name)
                                self.tableView.reloadData()
                            }
                        }
                    })
                    self.tableView.reloadData()
                }
            }
        }
       // let tap = UITapGestureRecognizer(target: self, action: #selector(SearchTableViewController.cancel1))
        //self.view.addGestureRecognizer(tap)
        //self.view.alpha = 0.6
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
        }
        else {
            search = true
            cuurentbookname = bookname.filter { (book) -> Bool in
                return book.lowercased().contains(searchText.lowercased())
            }
        }
        self.tableView.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //search = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
    @objc func cancel1() {
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if search == true {
            return cuurentbookname.count
        }
        else{
            return selectedsearch.count
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedsearch.append(cuurentbookname[indexPath.row])
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        if search == true{
            cell.textLabel?.text = cuurentbookname[indexPath.row]
            tableView.separatorStyle = .singleLine
        }
        else{
            cell.textLabel?.text = selectedsearch[indexPath.row]
            tableView.separatorStyle = .singleLine
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchresult" {
            if let nav = segue.destination as? UINavigationController {
                if let dest = nav.topViewController as? SearchResultTableViewController{
                    if let sender1 = sender as? UITableViewCell{
                        if let indexpath = tableView.indexPath(for: sender1) {
                            dest.name = self.cuurentbookname[indexpath.row]
                            dest.index = self.index
                        }
                    }
                }
            }
        }
    }
}
