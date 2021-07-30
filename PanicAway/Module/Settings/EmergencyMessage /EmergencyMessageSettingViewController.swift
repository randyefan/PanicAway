//
//  EmergencyMessageSettingViewController.swift
//  PanicAway
//
//  Created by Darindra R on 26/07/21.
//

import UIKit

class EmergencyMessageSettingViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!

    static let identifier = "EmergencyMessageSettingViewController"

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
}

fileprivate extension EmergencyMessageSettingViewController {
    func initialSetup() {
        title = "Emergency Message"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
    }

    @objc func save() {

    }
}
