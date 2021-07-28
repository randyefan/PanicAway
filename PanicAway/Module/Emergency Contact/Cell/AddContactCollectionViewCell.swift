//
//  AddContactCollectionViewCell.swift
//  PanicAway
//
//  Created by Gratianus Martin on 26/07/21.
//

import UIKit



class AddContactCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AddContactCollectionViewCell"
    static let reuseID = "AddContactCell"
    
    static func nib() -> UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    

}
