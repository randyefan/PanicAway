//
//  Networking.swift
//  PanicAway
//
//  Created by Randy Efan Jayaputra on 19/08/21.
//

import Foundation

protocol NetworkRequest {
    func postMessage(phoneNumber: String, message: String, completion: @escaping (Result<Data?, Error>) -> ())
}

class NetworkingManager: NetworkRequest {
    static let shared = NetworkingManager()
    private init() { }
    
    func postMessage(phoneNumber: String, message: String, completion: @escaping (Result<Data?, Error>) -> ()) {
        let urlString = "https://api.kirimwa.id/v1/messages"
        self.post(url: urlString, phoneNumber: phoneNumber, message: message, completion: completion)
    }
}

fileprivate extension NetworkingManager {
    func post(url: String, phoneNumber: String, message: String, completion: @escaping (Result<Data?, Error>) -> ()) {
        guard let urlService = URL(string: url) else { fatalError("Cannot convert from url string") }
        let headers: [String:String] = [
            "Authorization": "Bearer 1234567891011123456677", // Change to token later
            "Content-Type": "application/json",
        ]
        
        let deviceId: String = "" // Change to device id later
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
            fatalError("Error convert param to json")
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if error != nil { return completion(.failure(error!)) }
            
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                print("Status Code Response not success")
                return completion(.success(data))
            }
            
            return completion(.success(data))
        }.resume()
    }
}
