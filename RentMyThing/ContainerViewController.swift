//
//  ContainerViewController.swift
//  RentMyThing
//
//  Created by vidit jindal on 29/08/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit
class ContainerViewController: UIViewController {
    @IBOutlet var sidemenu: NSLayoutConstraint!
    var sidemenue = false
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ContainerViewController.menue),name: NSNotification.Name("ToggleSideMenu"),object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func menue() {
        if sidemenue {
            sidemenu.constant = -274
            sidemenue = false
        }
        else {
            sidemenu.constant = 0
            sidemenue = true
        }
    }
}
