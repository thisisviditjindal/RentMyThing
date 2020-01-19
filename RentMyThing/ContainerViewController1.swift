//
//  ContainerViewController1.swift
//  RentMyThing
//
//  Created by vidit jindal on 01/09/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit
class ContainerViewController1: UIViewController {
    @IBOutlet var sidemenue1: NSLayoutConstraint!
    var sidemenue = false
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ContainerViewController1.menue1),name: NSNotification.Name("ToggleSideMenu1"),object: nil)
        // Do any additional setup after loading the view.
    }
    @objc func menue1() {
        if sidemenue {
            sidemenue1.constant = -274
            sidemenue = false
        }
        else {
            sidemenue1.constant = 0
            sidemenue = true
        }
    }
}
