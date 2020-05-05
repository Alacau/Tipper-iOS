//
//  Utilities.swift
//  Tipper
//
//  Created by Alan Cao on 5/5/20.
//  Copyright © 2020 Alan Cao. All rights reserved.
//

import UIKit

class Utilities {
    func textField(withPlaceholder placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = "$0.00"
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        textField.textColor = .systemPink
        
        return textField
    }
}
