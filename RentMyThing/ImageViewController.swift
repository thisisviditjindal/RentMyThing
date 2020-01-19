//
//  ImageViewController.swift
//  RentMyThing
//
//  Created by vidit jindal on 14/08/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    var image = ""
    
    var hidden = false
    @IBOutlet var image1: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.image1.sd_setImage(with: URL(string: self.image), completed: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(ImageViewController.view1))
        self.image1.addGestureRecognizer(tap)
        self.image1.isUserInteractionEnabled = true
    }
    @objc func view1(){
        if hidden == true {
            self.navigationController?.navigationBar.isHidden = true
            hidden = false
        }
        else{
            self.navigationController?.navigationBar.isHidden = false
            hidden = true
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
