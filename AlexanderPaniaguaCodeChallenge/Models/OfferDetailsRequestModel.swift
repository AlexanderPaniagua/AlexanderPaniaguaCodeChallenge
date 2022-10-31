//
//  OfferDetailsRequestModel.swift
//  AlexanderPaniaguaCodeChallenge
//
//  Created by Alexander Paniagua on 26/10/22.
//

import Foundation

struct OfferDetailsRequestModel: Codable {
    
    let offerId: String?
    
    enum CodingKeys: String, CodingKey {
        case offerId = "offerId"
    }
    
}
