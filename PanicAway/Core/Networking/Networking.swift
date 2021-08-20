//
//  Networking.swift
//  PanicAway
//
//  Created by Randy Efan Jayaputra on 19/08/21.
//

import Foundation

protocol NetworkRequest {
    func postMessage(phoneNumber: String, message: String, completion: ((Result<SendMessagesResponses?, Error>) -> ())?)
}

class NetworkingManager: NetworkRequest {
    static let shared = NetworkingManager()
    private init() { }
    
    func postMessage(phoneNumber: String, message: String, completion: ((Result<SendMessagesResponses?, Error>) -> ())? = nil) {
        let urlString = "https://api.kirimwa.id/v1/messages"
        self.post(url: urlString, phoneNumber: phoneNumber, message: message, completion: completion)
    }
}

fileprivate extension NetworkingManager {
    func post(url: String, phoneNumber: String, message: String, completion: ((Result<SendMessagesResponses?, Error>) -> ())?) {
        guard let urlService = URL(string: url) else { fatalError("Cannot convert from url string") }
        let decoder = JSONDecoder()
        let headers: [String:String] = [
            "Authorization": "Bearer M}D4jhn2SW@wQBVCcOFAXUskG/|D@uCSqLdXyiY2}PfeJk=1-darindra",
            "Content-Type": "application/json",
        ]
        
        let deviceId: String = "panicaway"
        let messageType: String = "text"
        
        var parameters: [String:Any] {
            return [
                "phone_number": phoneNumber,
                "message": message,
                "device_id": deviceId,
                "message_type": messageType
            ]
        }
        
        var urlRequest = URLRequest(url: urlService)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = "POST"
        urlRequest.timeoutInterval = 120
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Error convert param to json")
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if error != nil { print("Ada Error") }
        
            guard let data = data else { return print("gagal get data") }
            
            do {
                let people = try decoder.decode(SendMessagesResponses.self, from: data)
                print("Status API Whatsapp: \(String(describing: people.message))")
                print("Meta Location: \(String(describing: people.meta?.location))")
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
