//
//  SaveButton.swift
//  PanicAway
//
//  Created by Gratianus Martin on 30/07/21.
//

import UIKit

class SaveButton: UIButton {

    override var isEnabled: Bool{
        didSet{
            if isEnabled {
                self.backgroundColor = #colorLiteral(red: 0.9438729286, green: 0.6096045375, blue: 0.5635720491, alpha: 1)
            } else {
                self.backgroundColor = #colorLiteral(red: 0.7450318933, green: 0.7451404333, blue: 0.7450082302, alpha: 1)
            }
        }
    }

}
