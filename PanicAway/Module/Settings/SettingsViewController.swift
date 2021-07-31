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

    let data = BreathingLoader()
    var emergencyContact: [EmergencyContactModel]?
    
    var breathingTechnique: BreathingModel? {
        didSet {
            guard let breathing = breathingTechnique else { return }
            breathingMethodValue.text = breathing.breathingName
        }
    }
    
    
    private let cycleOption = Array(4...100)

    override func viewDidLoad() {
        super.viewDidLoad()
        data.loadDataBreath()
        initialSetup()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setupViewWithData() {
        getEmergencyContacts()
        let defaultBreathingId = UserDefaults.standard.integer(forKey: "defaultBreatheId")
        let defaultBreathingCycle = UserDefaults.standard.integer(forKey: "defaultBreathingCycle")
        breathingCycleValue.text = "\(defaultBreathingCycle)"
        breathingTechnique = data.entries[defaultBreathingId]
    }

    override func viewWillAppear(_ animated: Bool) {
        setupViewWithData()
        breathingCyclePickerView.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.setValue(Int(breathingCycleValue.text ?? "4"), forKey: "defaultBreathingCycle")
    }

    @IBAction func showHidePickerView(_ sender: Any) {
        breathingCyclePickerView.isHidden = !breathingCyclePickerView.isHidden
    }

    @IBAction func hidePickerViewAnywhere(_ sender: UITapGestureRecognizer) {
        breathingCyclePickerView.isHidden = true
    }

    @IBAction func breathingMethodButton(_ sender: UITapGestureRecognizer) {
        navigateToBreathingChoice()
    }

    @IBAction func emergencyContactButon(_ sender: UITapGestureRecognizer) {
        navigateToEmergencyContact()
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
    
    func getEmergencyContacts() {
        if let data = UserDefaults.standard.data(forKey: "defaultEmergencyContact") {
            do {
                let decoder = JSONDecoder()
                let emergencyContact = try decoder.decode([EmergencyContactModel].self, from: data)
                self.emergencyContact = emergencyContact
                } catch {
                    print("Unable to Decode (\(error))")
                }
        }
    }
    
    func setDefaultBreathingCycle() {
        
    }
    
    func navigateToBreathingChoice() {
        let vc = BreathingChoiceViewController(entryPoint: .settings)
        vc.selected = breathingTechnique
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToEmergencyContact() {
        let vc = EmergencyContactViewController(entryPoint: .settings)
        vc.emergencyContact = emergencyContact ?? []
        self.navigationController?.pushViewController(vc, animated: true)
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
