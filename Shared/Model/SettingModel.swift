//
//  SettingModel.swift
//  PanicAway
//
//  Created by Randy Efan Jayaputra on 04/08/21.
//

import Foundation

struct SettingModel: Codable {
    let defaultBreath: BreathingModel?
    let emergencyContact: [EmergencyContactModel]?
    let breathingCycle: Int?
    let isUsingHaptic: Bool?
}
