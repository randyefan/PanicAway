//
//  LocalizationMenuViewController.swift
//  PanicAway
//
//  Created by Javier Fransiscus on 23/08/21.
//

import Foundation
import UIKit

enum LocalizationEntryPoint {
    case onBoarding
    case settings
}

private let userLanguageKey = "applicationLocalizationKey"
class LocalizationMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var mainTitle: LocalizedLabel!
    @IBOutlet weak var languageTableView: UITableView!
    @IBOutlet weak var selectButton: UIButton!
    
    var languageOptions: [LanguageModel] = []
    var selectedLanguage:String? = ""
    var languageChosenIndex = 0
    var currentlySelected = ""
    private var rightBarButton: UIBarButtonItem?
    
    private var entryPoint: LocalizationEntryPoint?
    
    init(entryPoint: LocalizationEntryPoint) {
        super.init(nibName: "LocalizationMenuViewController", bundle: nil)
        self.entryPoint = entryPoint
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        //        print("\(currentlySelected) \(languageOptions[indexPath.row].id)")
        //        if currentlySelected != languageOptions[indexPath.row].id {
        //            self.navigationItem.rightBarButtonItem?.isEnabled = true
        //        }else{
        //            self.navigationItem.rightBarButtonItem?.isEnabled = false
        //        }
        //
        //
        //
        //
        //        selectButton.isEnabled = true
        //        guard let temporarySelectedLanguageVariable = languageOptions[indexPath.row].id else{
        //            print("gak bisa")
        //            return
        //        }
        //        currentlySelected = temporarySelectedLanguageVariable
        //        selectedLanguage = currentlySelected
        
        if let languageChosed = languageOptions[indexPath.row].id {
            selectedLanguage = languageChosed
        }
        selectButton.isEnabled = true
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        languageOptions = [LanguageModel(flag: "🇬🇧", name: "English".localized(), id: "en"),
                           LanguageModel(flag: "🇮🇩", name: "Bahasa Indonesia".localized(), id: "id")]
        
        languageTableView.register(LocalizationMenuTableViewCell.nib(), forCellReuseIdentifier: LocalizationMenuTableViewCell.identifier)
        
        languageTableView.dataSource = self
        languageTableView.delegate = self
        setupBackBarButtonItem()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBackBarButtonItem()
    }
    
    
    @IBAction func confirmSelectedLanguage(_ sender: Any) {
        if let languageChosed = selectedLanguage {
            setLanguage(language: languageChosed)
            print("success change language to \(languageChosed)")
        }
        navigateToProductShowcase()
    }
    
    func navigateToProductShowcase() {
        let vc = ProductShowcaseViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setLanguage(language: String) {
        selectedLanguage = language
        UserDefaults.standard.set(language, forKey: userLanguageKey)
    }
    
    func initialSetup() {
        
        
        selectButton.isEnabled = false
        selectButton.setTitle("Select".localized(), for: .normal)
        
        switch entryPoint {
        case .settings:
            languageChosenIndex = UserDefaults.standard.value(forKey: userLanguageKey) as? String == "en" ? 0 : 1
            title = "Select Language".localized()
            mainTitle.isHidden = true
            selectButton.isHidden = true
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save".localized(), style: .done, target:  self, action:  #selector(edit))
            languageTableView.reloadData()
            languageTableView.selectRow(at: IndexPath(row: languageChosenIndex, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition(rawValue: 0)!)
            self.navigationController?.navigationBar.isHidden = false
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        default:
            self.navigationController?.navigationBar.isHidden = true
        }
    }
    
    
    @objc func edit() {
        if let languageChosed = selectedLanguage {
            setLanguage(language: languageChosed)
        }
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    private func setupBackBarButtonItem() {
        let backItem = UIBarButtonItem()
        backItem.title = "Preferences".localized()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
    }
}
