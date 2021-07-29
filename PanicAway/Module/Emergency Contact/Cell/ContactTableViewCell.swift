//
//  ContactTableViewCell.swift
//  PanicAway
//
//  Created by Gratianus Martin on 29/07/21.
//

import UIKit
import Contacts

class ContactTableViewCell: UITableViewCell {
    
    static let reuseID = "ContactCell"
    static let identifier = "ContactTableViewCell"

    @IBOutlet weak var contactNameLabel: UILabel!
    
    var contactInformation : CNContact? = nil {
        didSet {
            contactNameLabel.text = contactInformation?.givenName
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
