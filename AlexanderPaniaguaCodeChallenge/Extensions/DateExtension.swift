//
//  DateExtension.swift
//  AlexanderPaniaguaCodeChallenge
//
//  Created by Alexander Paniagua on 30/10/22.
//

import Foundation

extension Date {
    
    func toString(withFormat customFormat: String) -> String {
        let formatter = Utils.getDateFormatter(locale: Locale.current)
        formatter.dateFormat = customFormat
        return formatter.string(from: self)
    }
    
}
