//
//  LocalizationMenuTableViewCell.swift
//  PanicAway
//
//  Created by Javier Fransiscus on 24/08/21.
//

import UIKit

class LocalizationMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var flagLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentViewCell: UIView!
    
    static let identifier = "LocalizationMenuTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected{
            contentViewCell.backgroundColor = UIColor(named: "Main")
            nameLabel.font = .systemFont(ofSize: 17)
            contentViewCell.borderWidth = 0
        }else{
            contentViewCell.backgroundColor = UIColor(displayP3Red: 255, green: 242, blue: 240, alpha: 1)
            nameLabel.font = .systemFont(ofSize: 17)
            contentViewCell.borderWidth = 2
            
        }
    }
    
    static func nib()-> UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func setupCell(with model: LanguageModel){
        flagLabel.text = model.flag
        nameLabel.text = model.name
    }
}
