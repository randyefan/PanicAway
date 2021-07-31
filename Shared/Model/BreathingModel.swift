//
//  BreathingModel.swift
//  PanicAway
//
//  Created by Randy Efan Jayaputra on 30/07/21.
//

import Foundation

struct BreathingModel {
    let id: Int
    let breathingName: String
    let breathInCount: Int
    let holdOnCount: Int
    let breathOutCount: Int
    let description: String
}

class BreathingLoader {
    var entries: [BreathingModel] = []
    
    func loadDataBreath() {
        let entries = [
            BreathingModel(id: 0,
                           breathingName: "4-7-8",
                           breathInCount: 4,
                           holdOnCount: 7,
                           breathOutCount: 8,
                           description: "Inhale for 4s, holding for 7s, and exhale for 8s. Aims to reduce anxiety or help to get sleep."),
            BreathingModel(id: 1,
                           breathingName: "4-4-4",
                           breathInCount: 4,
                           holdOnCount: 4,
                           breathOutCount: 4,
                           description: "Inhale for 4s, hold for 4s, then exhale for 4s, and hold 4s before the next cycle; Aim to clear your head from distractions and reduce stress."),
            BreathingModel(id: 2,
                           breathingName: "7-11",
                           breathInCount: 7,
                           holdOnCount: 0,
                           breathOutCount: 11,
                           description: "Inhale for 7s and exhale 11s. Breathe from your belly for this one.")
        ]
        self.entries = entries
    }
}
