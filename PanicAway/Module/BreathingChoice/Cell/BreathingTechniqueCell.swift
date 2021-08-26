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
    @IBOutlet weak var breatheGoalLabel: UILabel!
    
    var indexPath: IndexPath?
    
    var model: BreathingModel? {
        didSet {
            guard let model = model else { return }
            titleLabel.text = model.breathingName
            captionLabel.text = model.description
            breatheGoalLabel.text = model.breathGoal
        }
    }
    
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
            background.image = UIImage(named: "unselected_478")
        } else if indexPath.row == 1 {
            background.image = UIImage(named: "unselected_444")
        } else {
            background.image = UIImage(named: "unselected_711")
        }
    }
    
    private func setImageBackgroundSelected() {
        guard let indexPath = indexPath else { return }
        if indexPath.row == 0 {
            background.image = UIImage(named: "selected_478")
        } else if indexPath.row == 1 {
            background.image = UIImage(named: "selected_444")
        } else {
            background.image = UIImage(named: "selected_711")
        }
    }
 }
