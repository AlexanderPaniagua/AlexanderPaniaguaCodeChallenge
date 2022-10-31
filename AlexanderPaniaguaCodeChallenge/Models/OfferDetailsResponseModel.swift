//
//  OfferDetailsResponseModel.swift
//  AlexanderPaniaguaCodeChallenge
//
//  Created by Alexander Paniagua on 26/10/22.
//

import Foundation

struct OfferDetailsResponseModel: Codable {
    
    let title: String?
    let offerDetails: OfferDetailsModel?
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case offerDetails = "offerDetails"
    }
    
}
