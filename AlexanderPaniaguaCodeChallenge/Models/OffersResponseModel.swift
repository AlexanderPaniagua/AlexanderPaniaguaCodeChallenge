//
//  OffersResponseModel.swift
//  AlexanderPaniaguaCodeChallenge
//
//  Created by Alexander Paniagua on 29/10/22.
//

import Foundation

struct OffersResponseModel: Codable {
    let title: String?
    let sections: [OffersSectionModel]?
}

struct OffersSectionModel: Codable {
    let title: String?
    var items: [OfferDetailsModel]?
    
    mutating func reset() {
        self = OffersSectionModel(title: nil, items: nil)
    }
    
    //This function will help if the table's headers needs to be showed up while the user is searching for something
    mutating func setItems(items: [OfferDetailsModel]) {
        self.items = items
    }
}
