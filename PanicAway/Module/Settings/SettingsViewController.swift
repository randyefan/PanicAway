//
//  SettingsViewController.swift
//  PanicAway
//
//  Created by Darindra R on 26/07/21.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var breathingMethodCell: UIStackView!
    @IBOutlet weak var breathingMethodValue: UILabel!
    @IBOutlet weak var breathingCycleValue: UILabel!
    @IBOutlet weak var breathingCyclePickerView: UIPickerView!
    @IBOutlet weak var guidedAudioToggle: UISwitch!
    @IBOutlet weak var hapticToggle: UISwitch!
    @IBOutlet weak var appleHealthToggle: UISwitch!

    private let cycleOption = Array(4...100)

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
    }

    override func viewWillAppear(_ animated: Bool) {
        breathingCyclePickerView.isHidden = true
    }

    @IBAction func showHidePickerView(_ sender: Any) {
        breathingCyclePickerView.isHidden = !breathingCyclePickerView.isHidden
    }

    @IBAction func hidePickerViewAnywhere(_ sender: UITapGestureRecognizer) {
        breathingCyclePickerView.isHidden = true
    }

    @IBAction func breathingMethodButton(_ sender: UITapGestureRecognizer) {
    }

    @IBAction func emergencyContactButon(_ sender: UITapGestureRecognizer) {
    }

    @IBAction func emergencyMessageButton(_ sender: UITapGestureRecognizer) {
        let vc = EmergencyMessageSettingViewController(nibName: EmergencyMessageSettingViewController.identifier, bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
}

fileprivate extension SettingsViewController {
    func initialSetup() {
        title = "Preferences"
    }
}

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cycleOption.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(cycleOption[row])"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        breathingCycleValue.text = "\(cycleOption[row])"
    }
}
