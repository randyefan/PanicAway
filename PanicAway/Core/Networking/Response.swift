//
//  Response.swift
//  PanicAway
//
//  Created by Randy Efan Jayaputra on 21/08/21.
//

import Foundation

struct SendMessagesResponses: Codable {
    let id: String?
    let status: String?
    let message: String?
    let meta: LocationApiResponses?
}

struct LocationApiResponses: Codable {
    let location: String?
}
