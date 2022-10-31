//
//  OfferDetailsViewController.swift
//  AlexanderPaniaguaCodeChallenge
//
//  Created by Alexander Paniagua on 30/10/22.
//

import Foundation
import UIKit
import Kingfisher

class OfferDetailsViewController: BaseViewController {
    // MARK: IBOutlet connections
    @IBOutlet weak var heartImageView: UIImageView!
    @IBOutlet weak var offerImageView: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var expirationLabel: UILabel!
    @IBOutlet weak var redemptionsCapLabel: UILabel!
    
    // MARK: IBOutlet actions
    @IBAction func offerImageTapped(_ sender: Any) {
        self.toggleLike(liked: true)
        self.showAlert(message: "Failed with animation challenge point :(")
    }
    
    @IBAction func hearthImageTapped(_ sender: Any) {
        self.toggleLike(liked: !self.likedOffer)
        self.showAlert(message: "Failed with animation challenge point :(")
    }
    
    @IBAction func backImageTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.performRequests()
    }
    
    // MARK: Class props
    private let offersViewModel = OffersViewModel()
    var offerId: String?
    private var offerDetails: OfferDetailsModel?
    private var likedOffer = false
    
    // MARK: Class methods
    private func setupView() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func toggleLike(liked: Bool) {
        self.likedOffer = liked
        self.heartImageView.image = self.likedOffer ? UIImage(named: "iconHearth") : UIImage(named: "iconHearth2")
    }
    
}

// MARK: Extensions
extension OfferDetailsViewController {
    
    private func performRequests() {
        self.showLoader()
        
        self.offersViewModel.getOffer(offerId: self.offerId ?? "") { (offerDetailsModel, succeded) in
            self.hideLoader()
            if succeded {
                self.offerDetails = offerDetailsModel
                self.updateUI()
            }
            else {
                self.showAlert(message: "Something went wrong, please try again.")
            }
        }
    }
    
    private func updateUI() {
        if let offerDetails = self.offerDetails {
            
            let opt = KingfisherOptionsInfo([.scaleFactor(UIScreen.main.scale), .transition(.fade(1)), .forceRefresh])
            self.offerImageView.configureKFImage(imageUrl: offerDetails.imageUrl ?? "", options: opt)
            
            self.brandLabel.text = offerDetails.brand ?? ""
            self.favoriteCount.text = "\(offerDetails.favoriteCount ?? 0)"
            self.titleLabel.text = offerDetails.title ?? ""
            self.descriptionLabel.text = offerDetails.description ?? ""
            
            if offerDetails.hasDiscount ?? false {
                self.priceLabel.attributedText = "\(offerDetails.currency ?? "")\(offerDetails.price ?? 0)".strikeThrough()
                self.discountPriceLabel.text = "\(offerDetails.currency ?? "")\(offerDetails.discountPrice ?? 0)"
            }
            else {
                self.priceLabel.text = "\(offerDetails.currency ?? "")\(offerDetails.price ?? 0)"
                self.discountPriceLabel.text = ""
            }
            
            if let expDate = offerDetails.expDate {
                let cuteExpDate = expDate.toString(withFormat: "d MMMM yyy")
                self.expirationLabel.text = "Exp.\(cuteExpDate)"
            }
            
            self.redemptionsCapLabel.text = "REDEMPTIONS CAP: \(offerDetails.redemptionsCap ?? 0) TIMES"
            
        }
        else {
            self.showAlert(message: "Something went wrong, please try again.")
        }
    }
    
}
