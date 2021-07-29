//
//  EmergencyContactViewController.swift
//  PanicAway
//
//  Created by Gratianus Martin on 26/07/21.
//

import UIKit
import Contacts
import ContactsUI

class EmergencyContactViewController: UIViewController{
    
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var stackButton: UIStackView!
    @IBOutlet weak var contactTableView: UITableView!
    
    private var emergencyContact: [CNContact] = []
    private var isEdit: Bool = false
    private var editIndex: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
        contactTableView.register(ContactTableViewCell.nib(), forCellReuseIdentifier: ContactTableViewCell.reuseID)
        contactTableView.register(AddToContactTableViewCell.nib(), forCellReuseIdentifier: AddToContactTableViewCell.reuseID)
    }
    @IBAction func saveButtonAction(_ sender: UIButton) {
    }
    
    
    @IBAction func skipButtonAction(_ sender: UIButton) {
    }
}

fileprivate extension EmergencyContactViewController {
    func initialSetup(){
        title = "Emergency Contact"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
    }
    
    @objc func save() { //insert logic save here
        
    }
}

//MARK: CollectionView Configuration
extension EmergencyContactViewController: CNContactPickerDelegate, UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if emergencyContact.count < 3 {
            return emergencyContact.count + 1
        } else {
            return emergencyContact.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if emergencyContact.count < 3 {
            if indexPath.row == emergencyContact.count {
                let cell = contactTableView.dequeueReusableCell(withIdentifier: AddToContactTableViewCell.reuseID, for: indexPath) as! AddToContactTableViewCell
                
                cell.selectionStyle = .none
                
                return cell
            }else {
                let cell = contactTableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.reuseID, for: indexPath) as! ContactTableViewCell
                
                cell.contactInformation = emergencyContact[indexPath.row]
                cell.selectionStyle = .none
                
                return cell
            }
        } else {
            let cell = contactTableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.reuseID, for: indexPath) as! ContactTableViewCell
            
            cell.contactInformation = emergencyContact[indexPath.row]
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    //handle button AddContact Action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if emergencyContact.count < 3 {
            if indexPath.row == emergencyContact.count{
                //contact Picker
                let contactPickerVC = CNContactPickerViewController()
                contactPickerVC.delegate = self
                present(contactPickerVC, animated: true)
            } else {
                isEdit = true
                editIndex = indexPath.row
                
                let contactPickerVC = CNContactPickerViewController()
                contactPickerVC.delegate = self
                present(contactPickerVC, animated: true)
            }
        } else {
            isEdit = true
            editIndex = indexPath.row
            
            let contactPickerVC = CNContactPickerViewController()
            contactPickerVC.delegate = self
            present(contactPickerVC, animated: true)
        }
    }

    //handle contact selection
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        if isEdit {
            guard let index = editIndex else { return }
            emergencyContact[index] = contact
            isEdit = false
        } else {
            emergencyContact.append(contact)
        }
        
        contactTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if emergencyContact.count < 3 {
            if indexPath.row == emergencyContact.count - 1 {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if emergencyContact.count < 3 {
            if indexPath.row == emergencyContact.count - 1 {
                return .delete
            } else {
                return .none
            }
        } else {
            return .delete
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            contactTableView.beginUpdates()
            emergencyContact.remove(at: indexPath.row)
            contactTableView.deleteRows(at: [indexPath], with: .fade)
            contactTableView.endUpdates()
        }
    }
    
}

