//
//  ProfileNameFromSettingViewController.swift
//  PanicAway
//
//  Created by Gratianus Martin on 24/08/21.
//

import UIKit

class ProfileNameFromSettingViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var nameTextfield: UITextField!
    
    // MARK: - Variable
    var name: String?
    
    // MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

       setupView()
        isNameExist()
    }
    
    // MARK: - Setup Function for ViewController
    func setupView(){
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: nameTextfield.frame.height))
        nameTextfield.leftView = padding
        nameTextfield.leftViewMode = .always
        title = "Profile Name".localized()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save".localized(), style: .done, target: self, action: #selector(saveName))
        navigationItem.rightBarButtonItem?.isEnabled = false
        nameTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard nameTextfield.text != nil else {
            return
        }
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func isNameExist(){
        if let name = name {
            nameTextfield.text = name
        }
    }
    
    // MARK: - Action Triggered     
    @objc func saveName() {
        print("save nama")
        guard let name = nameTextfield.text else { return }
        UserDefaults.standard.setValue(name, forKey: "fullName")
        self.navigationController?.popViewController(animated: true)
    }
}
