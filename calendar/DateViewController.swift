//
//  DateViewController.swift
//  RentMyThing
//
//  Created by vidit jindal on 10/09/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit

class DateViewController: UIViewController {

    @IBOutlet var segment: UISegmentedControl!
    @IBOutlet var datepicker: UIDatePicker!
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(done))
        self.view.addGestureRecognizer(tap)
    }
    var formatted1: String {
        get {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter.string(from: datepicker.date)
        }
    }
    var formatted: String{
        get {
            let formatter = ISO8601DateFormatter()
            return formatter.string(from: datepicker.date)
        }
    }
    @objc func done() {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func savedate(_ sender: Any) {
        
        if segment.selectedSegmentIndex == 0 {
            self.dismiss(animated: true, completion: nil)
        }
        else{
            NotificationCenter.default.post(name: NSNotification.Name("Selectdate"), object: self)
            self.dismiss(animated: true, completion: nil)
        }
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
