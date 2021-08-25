//
//  LocalizationMenuViewController.swift
//  PanicAway
//
//  Created by Javier Fransiscus on 23/08/21.
//

import Foundation
import UIKit

private let userLanguageKey = "applicationKey"
class LocalizationMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var languageTableView: UITableView!
    @IBOutlet weak var selectButton: UIButton!
    
    var languageOptions: [LanguageModel] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = languageTableView.dequeueReusableCell(withIdentifier: LocalizationMenuTableViewCell.identifier, for: indexPath) as! LocalizationMenuTableViewCell

        cell.setupCell(with: languageOptions[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let languageChosed = languageOptions[indexPath.row].id{
            setLanguange(language: languageChosed)
        }else{
            setLanguange(language: "en")
        }
        selectButton.isEnabled = true
       
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        languageOptions = [LanguageModel(flag: "🇬🇧", name: "English", id: "en"),
                            LanguageModel(flag: "🇮🇩", name: "Bahasa Indonesia", id: "id")]
        
        languageTableView.register(LocalizationMenuTableViewCell.nib(), forCellReuseIdentifier: LocalizationMenuTableViewCell.identifier)
        
        languageTableView.dataSource = self
        languageTableView.delegate = self
        
        selectButton.isEnabled = false
        
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction func confirmSelectedLanguange(_ sender: Any) {
        navigateToProductShowcase()
    }
    
    func navigateToProductShowcase() {
        let vc = ProductShowcaseViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setLanguange(language: String) {
        UserDefaults.standard.set(language, forKey: userLanguageKey)
    }
}

extension String{
    func localized() ->String {
        let selectedLanguage = UserDefaults.standard.string(forKey: userLanguageKey)
        let path = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
        
    }
}