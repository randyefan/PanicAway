//
//  SettingsViewController.swift
//  PanicAway
//
//  Created by Darindra R on 26/07/21.
//

import UIKit
import WatchConnectivity

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
    var wcSession = WCSession.default
    
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
        setupWCSession()
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setupWCSession() {
        wcSession.delegate = self
        wcSession.activate()
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
        sendDataToWatch()
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
        navigateToProfileName()
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
    
    func getSettingsModel() -> SettingModel {
        let breathingCycle = UserDefaults.standard.integer(forKey: "defaultBreathingCycle")
        let isUsingHaptic = true // Handle Later
        
        return SettingModel(defaultBreath: self.breathingTechnique, emergencyContact: self.emergencyContact, breathingCycle: breathingCycle, isUsingHaptic: isUsingHaptic)
    }
    
    func sendDataToWatch() {
        let model = getSettingsModel()
        
        var settings: [String:Any] = [:]
        settings["defaultBreathingCycle"] = model.breathingCycle ?? 4
        settings["defaultEmergencyContact"] = UserDefaults.standard.data(forKey: "defaultEmergencyContact") ?? Data()
        settings["defaultBreatheId"] = model.defaultBreath?.id
        settings["date"] = Date()
        
        do {
            try wcSession.updateApplicationContext(settings)
        } catch {
            print("error: \(error.localizedDescription)")
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
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToProfileName() {
        let vc = ProfileNameFromSettingViewController()
        if let fullName = UserDefaults.standard.string(forKey: "fullName") {
            vc.name = fullName
        }
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

extension SettingsViewController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        return
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        return
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        return
    }
}
