//
//  button1.swift
//  picpie
//
//  Created by vidit jindal on 15/04/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit
@IBDesignable
class button1: UIButton {
    @IBInspectable var roundbutton:Bool = false {
        didSet{
            if roundbutton {
                layer.cornerRadius = frame.height / 2
            }
        }
    }
    override func prepareForInterfaceBuilder() {
        if roundbutton {
            layer.cornerRadius = frame.height / 2
        }
    }
}
