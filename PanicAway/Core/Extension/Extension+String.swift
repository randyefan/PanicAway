//
//  Extension+String.swift
//  PanicAway
//
//  Created by Randy Efan Jayaputra on 21/08/21.
//

import Foundation

extension String {
    func toPhoneNumber() -> String {
        let firstString = self[self.startIndex]
        if firstString == "+" {
            let newText = self.replacingOccurrences(of: "+", with: "")
            return newText
        } else if firstString == "0" {
            let newText = self.replacingCharacters(in: ...self.startIndex, with: "62")
            return newText
        } else {
            return self
        }
    }
    
    func localized() ->String {
        let selectedLanguage = UserDefaults.standard.string(forKey: "applicationLocalizationKey")
        let path = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj")
        guard let path = path else { return self }
        let bundle = Bundle(path: path)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
        
    }
}
