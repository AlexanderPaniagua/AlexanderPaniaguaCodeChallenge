//
//  Utils.swift
//  AlexanderPaniaguaCodeChallenge
//
//  Created by Alexander Paniagua on 27/10/22.
//

import Foundation
import Kingfisher

class Utils {
    
    /// Prints if app is in debug mode
    static func printIfInDebugMode(_ message: String) {
        #if DEBUG
        print(message)
        #endif
    }
    
    /// Creates a dictionary from a Codable data
    static func createDictionary(data: Codable) -> [String: Any] {
        var dictionary = [String: Any]()
        do {
            if let createdDictionary = try data.asDictionary() {
                dictionary = createdDictionary
            }
        }
        catch {
            self.printIfInDebugMode("Error while converting to dictionary")
        }
        return dictionary
    }
    
    // Returns a DateFormatter based on the passed locale
    static func getDateFormatter(locale: Locale) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.amSymbol = "a.m."
        dateFormatter.pmSymbol = "p.m."
        return dateFormatter
    }
    
}
