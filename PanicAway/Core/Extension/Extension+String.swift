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
        }
        return ""
    }
}
