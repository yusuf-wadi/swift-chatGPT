//
//  OpenAIManager.swift
//  swift-openai-api
//
//  Adapted by Yusuf Wadi 20230906
//

import UIKit

let openAIKey = "OPENAI_KEY_HERE"


class OpenAIManager {
    
    static let shared = OpenAIManager()
    
    func makeRequest(json: [String: Any], completion: @escaping (String)->()) {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions"),
              let payload = try? JSONSerialization.data(withJSONObject: json) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(openAIKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = payload
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { completion("Error::\(String(describing: error?.localizedDescription))"); return }
            guard let data = data else { completion("Error::Empty data"); return }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            
            if let json = json,
               let choices = json["choices"] as? [[String: Any]],
               let message = choices.first?["message"] as? [String: String],
               let str = message["content"]{
                completion (str)
            } else {
                completion("Error::nothing returned")
            }
            
        }.resume()
    }
}
