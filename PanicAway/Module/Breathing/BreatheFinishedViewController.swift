//
//  BreatheFinishedViewController.swift
//  PanicAway
//
//  Created by Gratianus Martin on 20/08/21.
//

import UIKit

class BreatheFinishedViewController: UIViewController {
    
    //variable
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    var repeatBreathing: (() -> ())?
    var finishBreathing: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setupLocalization()
    }

    @IBAction func finishButtonAction(_ sender: Any) {
        
        self.dismiss(animated: true) {
            self.finishBreathing?()
        }
        
        
    }
    
    @IBAction func repeatButtonAction(_ sender: Any) {
        self.dismiss(animated: true) {
            self.repeatBreathing?()
        }
    }
    
    func setupLocalization() {
        repeatButton.setTitle("Repeat".localized(), for: .normal)
        finishButton.setTitle("Finish".localized(), for: .normal)
    }
}
