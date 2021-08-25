//
//  ProfileNameOnBoardingViewController.swift
//  PanicAway
//
//  Created by Gratianus Martin on 24/08/21.
//

import UIKit

class ProfileNameOnBoardingViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var saveButton: SaveButton!
    @IBOutlet weak var nameTextField: UITextField!

    // MARK: - Variable
    private var name: String?

    // MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.onTap {
            self.view.endEditing(true)
        }
    }

    // MARK: - Setup Function for ViewController
    func setupView() {
        saveButton.isEnabled = false
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        guard nameTextField.text != nil else {
            return
        }
        saveButton.isEnabled = true
    }

    // MARK: - Action Triggered
    @IBAction func saveButtonAction(_ sender: UIButton) {
        guard let name = nameTextField.text else { return }
        UserDefaults.standard.setValue(name, forKey: "fullName")
        navigateToEmergencyContact()
    }
    // MARK: - Functionality
    private func navigateToEmergencyContact() {
        let vc = EmergencyContactViewController(entryPoint: .onBoarding)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func navigateToAppleHealthAuthorize() {
        let vc = OnboardingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
