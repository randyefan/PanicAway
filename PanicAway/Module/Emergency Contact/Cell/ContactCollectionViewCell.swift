//
//  ContactCollectionViewCell.swift
//  PanicAway
//
//  Created by Gratianus Martin on 26/07/21.
//

import UIKit
import Contacts



class ContactCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var labelContactName: UILabel!
    static let identifier = "ContactCollectionViewCell"
    static let reuseID = "ContactCell"
    
    var contactInformation : CNContact? = nil {
        didSet {
            labelContactName.text = contactInformation?.givenName
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

}
