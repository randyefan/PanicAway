//
//  BreathingModel.swift
//  PanicAway
//
//  Created by Randy Efan Jayaputra on 30/07/21.
//

import Foundation
#if !os(watchOS)
import WidgetKit
struct BreathingModel: Codable, TimelineEntry {
    let id: Int
    let breathingName: String
    let breathGoal: String
    let breathInCount: Int
    let holdOnCount: Int
    let breathOutCount: Int
    let description: String
    var date: Date = Date()
}
#else
struct BreathingModel: Codable {
    let id: Int
    let breathingName: String
    let breathGoal: String
    let breathInCount: Int
    let holdOnCount: Int
    let breathOutCount: Int
    let description: String
    var date: Date = Date()
}
#endif

class BreathingLoader {
    var entries: [BreathingModel] = []
    
    func loadDataBreath() {
        let entries = [
            BreathingModel(id: 0,
                           breathingName: "4-7-8 Method".localized(),
                           breathGoal: "Anxiety Away".localized(),
                           breathInCount: 4,
                           holdOnCount: 7,
                           breathOutCount: 8,
                           description: "Inhale 4s, hold 7s, and exhale 8s. Aims to reduce anxiety or help to get sleep.".localized()),
            BreathingModel(id: 1,
                           breathingName: "4-4-4 Method".localized(),
                           breathGoal: "Calm".localized(),
                           breathInCount: 4,
                           holdOnCount: 4,
                           breathOutCount: 4,
                           description: "Inhale 4s, hold 4s, exhale 4s, and hold 4s. Aim to reduce tension and clear mind from distractions.".localized()),
            BreathingModel(id: 2,
                           breathingName: "7-11 Method".localized(),
                           breathGoal: "Relax".localized(),
                           breathInCount: 7,
                           holdOnCount: 0,
                           breathOutCount: 11,
                           description: "Inhale 7s and exhale 11s. Repeat this cycle or until you feel relaxed.".localized())
        ]
        self.entries = entries
    }
}
