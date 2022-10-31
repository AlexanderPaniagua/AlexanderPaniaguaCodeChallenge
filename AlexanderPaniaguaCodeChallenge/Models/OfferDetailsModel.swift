//
//  OfferDetailsModel.swift
//  AlexanderPaniaguaCodeChallenge
//
//  Created by Alexander Paniagua on 26/10/22.
//

import Foundation

struct OfferDetailsModel: OffersBaseModel, Codable {
    var imageUrl: String?
    var brand: String?
    var title: String?
    let detailUrl: String?
    let tags: String?
    let offerId: String?
    let favoriteCount: Double?
    let description: String?
    let hasDiscount: Bool?
    let currency: String?
    let price: Double?
    let discountPrice: Double?
    let startDate: Date?
    let expDate: Date?
    let redemptionsCap: Decimal?
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "imageUrl"
        case brand = "brand"
        case title = "title"
        case detailUrl = "detailUrl"
        case tags = "tags"
        case offerId = "offerId"
        case favoriteCount = "favoriteCount"
        case description = "description"
        case hasDiscount = "hasDiscount"
        case currency = "currency"
        case price = "price"
        case discountPrice = "discountPrice"
        case startDate = "startDate"
        case expDate = "expDate"
        case redemptionsCap = "redemptionsCap"
    }
}
