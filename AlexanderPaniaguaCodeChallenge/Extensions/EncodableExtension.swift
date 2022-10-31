//
//  EncodableExtension.swift
//  AlexanderPaniaguaCodeChallenge
//
//  Created by Alexander Paniagua on 26/10/22.
//

import Foundation

extension Encodable {
    
    func encoded() throws -> Data? {
        do {
            return try JSONEncoder().encode(self)
        }
        catch let error {
            print("Error while encoding data: \(error.localizedDescription)")
            return nil
        }
    }
    
    func asDictionary() throws -> [String: Any]? {
        var dictionary: [String: Any]?
        
        if let data = try self.encoded() {
            guard let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                throw NSError()
            }
            dictionary = dict
        }
        
        return dictionary
    }
    
}
