//
//  BreathingTechniqueCell.swift
//  PanicAway
//
//  Created by Randy Efan Jayaputra on 27/07/21.
//

import UIKit

class BreathingTechniqueCell: UITableViewCell {
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var background: UIImageView!
    
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setImageBackgroundUnselected()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            setImageBackgroundSelected()
        } else {
            setImageBackgroundUnselected()
        }
    }
    
    private func setImageBackgroundUnselected() {
        guard let indexPath = indexPath else { return }
        if indexPath.row == 0 {
            background.image = UIImage(named: "bg_breathing_unselected_top")
        } else if indexPath.row == 1 {
            background.image = UIImage(named: "bg_breathing_unselected_center")
        } else {
            background.image = UIImage(named: "bg_breathing_unselected_bottom")
        }
    }
    
    private func setImageBackgroundSelected() {
        guard let indexPath = indexPath else { return }
        if indexPath.row == 0 {
            background.image = UIImage(named: "bg_breathing_selected_top")
        } else if indexPath.row == 1 {
            background.image = UIImage(named: "bg_breathing_selected_center")
        } else {
            background.image = UIImage(named: "bg_breathing_selected_bottom")
        }
    }
}
