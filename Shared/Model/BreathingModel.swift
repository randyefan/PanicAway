//
//  BreathingModel.swift
//  PanicAway
//
//  Created by Randy Efan Jayaputra on 30/07/21.
//

import Foundation

struct Breathing {
    var id: Int
    var breathingName: String
    var breathInCount: Int
    var holdOnCount: Int
    var breathOutCount: Int
}

class BreathingLoader {
    var entries: [Breathing] = []
    
    func loadDataBreath() {
        let entries = [
            Breathing(id: 0,
                      breathingName: "4-7-8",
                      breathInCount: 4,
                      holdOnCount: 7,
                      breathOutCount: 8),
            Breathing(id: 1,
                      breathingName: "4-4-4",
                      breathInCount: 4,
                      holdOnCount: 4,
                      breathOutCount: 4),
            Breathing(id: 2,
                      breathingName: "7-11",
                      breathInCount: 7,
                      holdOnCount: 0,
                      breathOutCount: 11)
        ]
        self.entries = entries
    }
}
