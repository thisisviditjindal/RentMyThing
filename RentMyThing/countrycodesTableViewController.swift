//
//  countrycodesTableViewController.swift
//  RentMyThing
//
//  Created by vidit jindal on 22/08/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit

class countrycodesTableViewController: UITableViewController {
    var codes = [String: String]()
    var ccode = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            if let path = Bundle.main.path(forResource: "CountryCodes", ofType: "json") {
                print("h1")
                let jsondata = try Data(contentsOf: URL(fileURLWithPath: path))
                let jsonpath = try JSONSerialization.jsonObject(with: jsondata, options: .mutableContainers)
                if let object = jsonpath as? [[String: Any]] {
                    for ob1 in object {
                        if let countryname = ob1["name"] as? String{
                            if let dialcode = ob1["dial_code"] as? String{
                                if let code = ob1["code"] as? String{
                                    self.codes[countryname] = dialcode
                                    self.ccode.append(code)
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
        catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    func sorted1() {
    }
    @IBAction func cancel(_ sender: Any) {
        self.performSegue(withIdentifier: "select", sender: self)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictsorted = self.codes.sorted { (key, value) -> Bool in
            key.key < value.key
        }
        let sorted = ccode.sorted()
        let dic = ["\(sorted[indexPath.row])": "\(dictsorted[indexPath.row].value)"]
        self.performSegue(withIdentifier: "select", sender: dic)
        print(dic)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return codes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let dictsorted = self.codes.sorted { (key, value) -> Bool in
            key.key < value.key
        }
        cell.textLabel?.text = dictsorted[indexPath.row].key
        cell.detailTextLabel?.text = dictsorted[indexPath.row].value
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "select" {
            if let dest = segue.destination as? SignViewController {
                if let sender1 = sender as? [String: String] {
                    dest.codes = sender1
                }
            }
        }
    }

}
