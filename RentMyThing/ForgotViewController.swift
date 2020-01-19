//
//  ForgotViewController.swift
//  RentMyThing
//
//  Created by vidit jindal on 28/06/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotViewController: UIViewController {
    @IBOutlet weak var emails: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignViewController.tap1))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tap)
    }
    @objc func tap1() {
        self.view.endEditing(true)
        self.resignFirstResponder()
    }

    @IBAction func sendlink(_ sender: Any) {
        if let email = emails.text {
            Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
                if error != nil {
                    self.displayalert(title: "Error", message: (error?.localizedDescription)!)
                }
                else {
                    self.displayalert(title: "Link Sent", message: "Link Has been Sent To your email. Check Your Email")
                }
            })
        }
    }
    @IBAction func cancel(_ sender: Any) {
        self.performSegue(withIdentifier: "cancel", sender: self)
    }
    
    func displayalert(title: String, message: String){
        let actioncontroller = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel) { (uiaction) in
            actioncontroller.dismiss(animated: true, completion: nil)
        }
        actioncontroller.addAction(action)
        present(actioncontroller, animated: true, completion: nil)
    }
}
