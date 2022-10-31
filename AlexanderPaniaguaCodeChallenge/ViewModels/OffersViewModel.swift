//
//  OffersViewModel.swift
//  AlexanderPaniaguaCodeChallenge
//
//  Created by Alexander Paniagua on 29/10/22.
//

import Foundation

class OffersViewModel {
    
    static let offersViewModel = OffersViewModel()
    
    private let webService = WebService.shared()
    
    func getOffers(completionHandler: @escaping ([OffersSectionModel]?, Bool) -> ()) {
        self.webService.performRequest(endpointUrl: WebServiceConstants.offersEndpoint, type: OffersResponseModel.self) { (offersResponseModel, succeded) in
            if let offersResponseModel = offersResponseModel {
                completionHandler(offersResponseModel.sections ?? [OffersSectionModel](), true)
            }
            else {
                completionHandler(nil, false)
            }
        }
    }
    
    func getOffer(offerId: String, completionHandler: @escaping (OfferDetailsModel?, Bool) -> ()) {
        
        let offerDetailsRequestModel = OfferDetailsRequestModel(offerId: offerId)
        let queryString = "/\(offerDetailsRequestModel.offerId ?? "")"
        
        self.webService.performRequest(endpointUrl: WebServiceConstants.offerDetailsEndpoint, queryString: queryString, type: OfferDetailsResponseModel.self) { (offerDetailsResponseModel, succeded) in
            if let offerDetailsResponseModel = offerDetailsResponseModel, let offerDetailsModel = offerDetailsResponseModel.offerDetails {
                completionHandler(offerDetailsModel, true)
            }
            else {
                completionHandler(nil, false)
            }
        }
    }
    
}
