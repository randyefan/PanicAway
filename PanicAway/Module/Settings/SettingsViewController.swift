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
    @IBOutlet weak var breathingTItleLabel: LocalizedLabel!
    @IBOutlet weak var breathingCycleLabel: LocalizedLabel!
    @IBOutlet weak var guidedAudioLabel: LocalizedLabel!
    @IBOutlet weak var emergencyTitleLabel: LocalizedLabel!
    @IBOutlet weak var profileNameLabel: LocalizedLabel!
    @IBOutlet weak var emergencyContactLabel: LocalizedLabel!
    @IBOutlet weak var languageTitleLabel: LocalizedLabel!
    @IBOutlet weak var selectLanguageLabel: LocalizedLabel!
    
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
        setupBackBarButtonItem()
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
        
        let defaultHaptic = UserDefaults.standard.bool(forKey: "defaultHapticState")
        hapticToggle.isOn = defaultHaptic
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViewWithData()
        breathingCyclePickerView.isHidden = true
        reloadLocalization()
        title = "Preferences".localized()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupBackBarButtonItem()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.setValue(Int(breathingCycleValue.text ?? "4"), forKey: "defaultBreathingCycle")
        sendDataToWatch()
    }
    
    @IBAction func audioSwitch(_ sender: UISwitch) {
        if guidedAudioToggle.isOn {
            UserDefaults.standard.setValue(true, forKey: "defaultAudioState")
        } else {
            UserDefaults.standard.setValue(false, forKey: "defaultAudioState")
        }
    }
    
    @IBAction func hapticSwitch(_ sender: UISwitch) {
        if hapticToggle.isOn {
            UserDefaults.standard.setValue(true, forKey: "defaultHapticState")
        } else {
            UserDefaults.standard.setValue(false, forKey: "defaultHapticState")
        }
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
    @IBAction func selectLanguageButton(_ sender: UITapGestureRecognizer) {
        navigateToLocalizationView()
    }
}

fileprivate extension SettingsViewController {
    func initialSetup() {
        title = "Preferences".localized()
        guidedAudioToggle.isOn = UserDefaults.standard.bool(forKey: "defaultAudioState")
    }
    
    func reloadLocalization(){
        breathingTItleLabel.reloadText()
        breathingCycleLabel.reloadText()
        guidedAudioLabel.reloadText()
        emergencyTitleLabel.reloadText()
        profileNameLabel.reloadText()
        emergencyContactLabel.reloadText()
        languageTitleLabel.reloadText()
        selectLanguageLabel.reloadText()
    }
    
    
    private func setupBackBarButtonItem() {
        let backItem = UIBarButtonItem()
        backItem.title = "Back".localized()
        self.navigationController?.navigationBar.backItem?.backBarButtonItem = backItem
        
        guard let navigation = navigationController,
              !(navigation.topViewController === self) else {
            return
        }
        let bar = navigation.navigationBar
        bar.setNeedsLayout()
        bar.layoutIfNeeded()
        bar.setNeedsDisplay()
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
        
        var settings: [String: Any] = [:]
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
    
    func navigateToLocalizationView(){
        let vc = LocalizationMenuViewController(entryPoint: .settings)
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
