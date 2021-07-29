//
//  AddToContactTableViewCell.swift
//  PanicAway
//
//  Created by Gratianus Martin on 29/07/21.
//

import UIKit

class AddToContactTableViewCell: UITableViewCell {
    
    static let reuseID = "AddContactCell"
    static let identifier = "AddToContactTableViewCell"
    
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
