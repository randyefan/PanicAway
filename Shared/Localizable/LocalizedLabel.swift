//
//  LocalizedLabel.swift
//  PanicAway
//
//  Created by Javier Fransiscus on 23/08/21.
//

import Foundation
import UIKit

class LocalizedLabel : UILabel {

    @IBInspectable var keyValue: String {
        get {
            return self.text!
        }
        set(value) {
            if let selectedLanguage = UserDefaults.standard.string(forKey: "applicationKey"){
                let path = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj")
                let bundle = Bundle(path: path!)
                
                self.text = NSLocalizedString(value, tableName: nil, bundle: bundle!, value: "", comment: "")
            }
        }
    }
}

