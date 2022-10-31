//
//  DataExtension.swift
//  AlexanderPaniaguaCodeChallenge
//
//  Created by Alexander Paniagua on 26/10/22.
//

import Foundation

extension Data {
    
    func decode<T: Codable>(toType: T.Type) -> T? {
        do {
            let decoder = JSONDecoder()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            return try decoder.decode(toType, from: self)
        }
        catch let error {
            print("Error while decoding data: \(error.localizedDescription)")
            return nil
        }
    }
    
}
