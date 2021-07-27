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
    
    @IBOutlet weak var addContactCollectionView: UICollectionView!
    var emergencyContact: [CNContact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()

        addContactCollectionView.register(ContactCollectionViewCell.nib(), forCellWithReuseIdentifier: ContactCollectionViewCell.reuseID)
        addContactCollectionView.register(AddContactCollectionViewCell.nib(), forCellWithReuseIdentifier: AddContactCollectionViewCell.reuseID)
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
extension EmergencyContactViewController: UICollectionViewDelegate, UICollectionViewDataSource, CNContactPickerDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emergencyContact.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == emergencyContact.count {
            let cell = addContactCollectionView.dequeueReusableCell(withReuseIdentifier: AddContactCollectionViewCell.reuseID, for: indexPath) as! AddContactCollectionViewCell
            
            return cell
        }else {
            let cell = addContactCollectionView.dequeueReusableCell(withReuseIdentifier: ContactCollectionViewCell.reuseID, for: indexPath) as! ContactCollectionViewCell
            
            cell.contactInformation = emergencyContact[indexPath.row]
            return cell
        }
    }
    
    //handle button AddContact Action
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == emergencyContact.count{
            //contact Picker
            let contactPickerVC = CNContactPickerViewController()
            contactPickerVC.delegate = self
            present(contactPickerVC, animated: true)
        }
    }
    
    //handle contact selectionHow to fetch contacts and store in array on iOS?
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        emergencyContact.append(contact)
        addContactCollectionView.reloadData()
    }
    
}

//MARK: Cell Size Configuration
extension EmergencyContactViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize: CGRect = addContactCollectionView.bounds
        return CGSize(width: collectionViewSize.width, height: 48)
    }
}

