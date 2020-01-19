//
//  RateViewController.swift
//  RentMyThing
//
//  Created by vidit jindal on 02/07/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit

class RateViewController: UIViewController {
    var originalprice = ""
    var days = ""
    var condition = ""
    @IBOutlet weak var original: UITextField!
    @IBOutlet weak var nodays: UITextField!
    @IBOutlet weak var condi: UITextField!
    @IBOutlet weak var moneymake: UITextField!
    var amount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        original.text = originalprice
        nodays.text = days
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func amountcalculator(_ sender: Any) {
        if Int(originalprice) ?? 0 > 100 && Int(originalprice) ?? 0 <= 300 {
            amount = ((Int(nodays.text ?? "") ?? 0 * 10) + 15)
        }
        else if Int(originalprice) ?? 0 > 300 && Int(originalprice) ?? 0 <= 500 {
            amount = ((Int(nodays.text ?? "") ?? 0 * 15) + 20)
        }
        else if Int(originalprice) ?? 0 > 500 && Int(originalprice) ?? 0 <= 700{
            amount = ((Int(nodays.text ?? "") ?? 0 * 20) + 25)
        }
        else if Int(originalprice) ?? 0 > 700 && Int(originalprice) ?? 0 <= 1000 {
            amount = ((Int(nodays.text ?? "") ?? 0 * 20) + 30)
        }
        else {
            amount = ((Int(nodays.text ?? "") ?? 0 * 20) + 40)
        }
        moneymake.text = String(amount)
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
