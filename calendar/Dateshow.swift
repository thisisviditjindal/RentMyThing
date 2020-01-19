//
//  Dateshow.swift
//  RentMyThing
//
//  Created by vidit jindal on 09/09/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit
protocol datechange:class {
    func diddatechange(dayindex: Int, monthindex: Int, yearindex: Int)
}
class Dateshow: UIView {
    var delegate: datechange?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupview()
    }
    func setupview() {
        self.addSubview(label1)
        /*
        label1.rightAnchor.constraint(equalTo: rightAnchor, constant: 8)
        label1.leftAnchor.constraint(equalTo: leftAnchor)
        label1.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        label1.bottomAnchor.constraint(equalTo: bottomAnchor)
 */
        self.addSubview(label2)
        /*
        label2.rightAnchor.constraint(equalTo: rightAnchor)
        label2.leftAnchor.constraint(equalTo: leftAnchor, constant: 8)
        label2.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        label2.bottomAnchor.constraint(equalTo: bottomAnchor)
 */
        self.addSubview(label3)
        /*
        label3.rightAnchor.constraint(equalTo: rightAnchor)
        label3.leftAnchor.constraint(equalTo: leftAnchor, constant: 8)
        label3.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        label3.bottomAnchor.constraint(equalTo: bottomAnchor)
 */
    }
    let label1: UILabel = {
        let lbl=UILabel()
        lbl.text="No of Days"
        lbl.textColor = UIColor.black
        lbl.textAlignment = .center
        lbl.font=UIFont.boldSystemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    let label2: UILabel = {
        let lbl=UILabel()
        lbl.text="First Date"
        lbl.textColor = UIColor.black
        lbl.textAlignment = .left
        lbl.font=UIFont.boldSystemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    let label3: UILabel = {
        let lbl=UILabel()
        lbl.text="Second Date"
        lbl.textColor = UIColor.black
        lbl.textAlignment = .left
        lbl.font=UIFont.boldSystemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
