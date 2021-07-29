//
//  AddToContactTableViewCell.swift
//  PanicAway
//
//  Created by Gratianus Martin on 29/07/21.
//

import UIKit

class AddToContactTableViewCell: UITableViewCell {
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    static let reuseID = "AddContactCell"
    static let identifier = "AddToContactTableViewCell"
    
    
    static func nib() -> UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
    
    func setInactive() {
        content.backgroundColor = #colorLiteral(red: 0.7450318933, green: 0.7451404333, blue: 0.7450082302, alpha: 1)
        content.borderWidth = 0
        iconImage.tintColor = #colorLiteral(red: 0.999904573, green: 1, blue: 0.9998808503, alpha: 1)
        label.textColor = #colorLiteral(red: 0.999904573, green: 1, blue: 0.9998808503, alpha: 1)
    }
    
    func setActive() {
        content.backgroundColor = #colorLiteral(red: 0.999904573, green: 1, blue: 0.9998808503, alpha: 1)
        content.borderWidth = 1
        iconImage.tintColor = #colorLiteral(red: 0.9438729286, green: 0.6096045375, blue: 0.5635720491, alpha: 1)
        label.textColor = #colorLiteral(red: 0.9438729286, green: 0.6096045375, blue: 0.5635720491, alpha: 1)
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
