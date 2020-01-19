//
//  Image1.swift
//  picpie
//
//  Created by vidit jindal on 16/04/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit
@IBDesignable
class Image1: UIImageView {
    @IBInspectable var imgae: Bool = false{
        didSet{
            if imgae {
                layer.cornerRadius = frame.height/2
            }
        }
    }
    override func prepareForInterfaceBuilder() {
        if imgae {
            layer.cornerRadius = frame.height/2
        }
    }
}
