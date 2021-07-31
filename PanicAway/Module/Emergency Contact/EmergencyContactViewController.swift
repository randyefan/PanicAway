//
//  EmergencyContactViewController.swift
//  PanicAway
//
//  Created by Gratianus Martin on 26/07/21.
//

import UIKit
import Contacts
import ContactsUI

// MARK: - ENUM For Entry Point

enum EmergencyContactEntryPoint {
    case onBoarding
    case settings
}

class EmergencyContactViewController: UIViewController{
    
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var stackButton: UIStackView!
    @IBOutlet weak var contactTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    var emergencyContact: [EmergencyContactModel] = []
    private var isEdit: Bool = false
    private var editIndex: Int? = nil
    private var isEditTableView: Bool = false
    private var entryPoint: EmergencyContactEntryPoint?
    
    init(entryPoint: EmergencyContactEntryPoint) {
        super.init(nibName: "EmergencyContactViewController", bundle: nil)
        self.entryPoint = entryPoint
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        contactTableView.register(ContactTableViewCell.nib(), forCellReuseIdentifier: ContactTableViewCell.reuseID)
        contactTableView.register(AddToContactTableViewCell.nib(), forCellReuseIdentifier: AddToContactTableViewCell.reuseID)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if entryPoint == .settings {
            contactTableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if entryPoint == .settings {
            setSaveEmergencyContact()
        }
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        setSaveEmergencyContact()
        navigateToAuthorizeHealthKit()
    }
    
    
    @IBAction func skipButtonAction(_ sender: UIButton) {
        navigateToAuthorizeHealthKit()
    }
}

fileprivate extension EmergencyContactViewController {
    func initialSetup(){
        checkContact()
        switch entryPoint {
        case .settings:
            title = "Emergency Contact"
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(edit))
            mainTitle.isHidden = true
            stackButton.isHidden = true
        default:
            self.navigationController?.navigationBar.isHidden = true
        }
    }
    
    @objc func edit() { //insert logic save here
        
        if isEditTableView {
            contactTableView.isEditing = false
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(edit))
            
            isEditTableView = false
        } else {
            contactTableView.isEditing = true
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(edit))
            
            isEditTableView = true
        }
        
    }
    
    func setSaveEmergencyContact() {
        if emergencyContact.count != 0 {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(emergencyContact)
                UserDefaults.standard.set(data, forKey: "defaultEmergencyContact")
            } catch {
                print("Unable to Encode (\(error))")
            }
        }
    }
    
    func navigateToAuthorizeHealthKit() {
        let vc = OnboardingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: CollectionView Configuration
extension EmergencyContactViewController: CNContactPickerDelegate, UITableViewDelegate, UITableViewDataSource{
    
    //check if emergency contact data is exist to set save button state
    private func checkContact () {
        if emergencyContact.count == 0 {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emergencyContact.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row <= emergencyContact.count - 1 {
            let cell = contactTableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.reuseID, for: indexPath) as! ContactTableViewCell
            cell.contactInformation = emergencyContact[indexPath.row]
            cell.selectionStyle = .none
            
            return cell
            
        } else {
            let cell = contactTableView.dequeueReusableCell(withIdentifier: AddToContactTableViewCell.reuseID, for: indexPath) as! AddToContactTableViewCell
            
            if emergencyContact.count == 3 {
                cell.setInactive()
            }else{
                cell.setActive()
            }
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    //handle button AddContact Action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row <= emergencyContact.count - 1 {
            isEdit = true
            editIndex = indexPath.row
            //present contact picker VC
            let contactPickerVC = CNContactPickerViewController()
            contactPickerVC.delegate = self
            present(contactPickerVC, animated: true)
            
        } else {
            if emergencyContact.count == 3 {
                return
            }
            let contactPickerVC = CNContactPickerViewController()
            contactPickerVC.delegate = self
            present(contactPickerVC, animated: true)
        }
    }
    
    //handle contact selection
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        if isEdit {
            guard let index = editIndex else { return }
            let contactFriend = EmergencyContactModel(name: contact.givenName, phoneNumber: (contact.phoneNumbers[0].value.value(forKey: "digits") as? String)!)
            emergencyContact[index] = contactFriend
            isEdit = false
        } else {
            let contactFriend = EmergencyContactModel(name: contact.givenName, phoneNumber: (contact.phoneNumbers[0].value.value(forKey: "digits") as? String)!)
            emergencyContact.append(contactFriend)
            checkContact()
        }
        contactTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row <= emergencyContact.count - 1 {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.row <= emergencyContact.count - 1 {
            return .delete
        } else {
            return .none
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            contactTableView.beginUpdates()
            emergencyContact.remove(at: indexPath.row)
            contactTableView.deleteRows(at: [indexPath], with: .none)
            checkContact()
            contactTableView.endUpdates()
            contactTableView.reloadRows(at: [IndexPath(row: emergencyContact.count, section: 0)], with: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if destinationIndexPath.row > emergencyContact.count - 1 {
            contactTableView.reloadData()
            return
        }
        let movedContact = emergencyContact[sourceIndexPath.row]
        emergencyContact.remove(at: sourceIndexPath.row)
        emergencyContact.insert(movedContact, at: destinationIndexPath.row)
    }
}

