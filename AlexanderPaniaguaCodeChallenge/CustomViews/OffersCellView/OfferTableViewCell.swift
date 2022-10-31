//
//  OfferTableViewCell.swift
//  AlexanderPaniaguaCodeChallenge
//
//  Created by Alexander Paniagua on 29/10/22.
//

import UIKit
import Kingfisher

class OfferTableViewCell: UITableViewCell {
    // MARK: IBOUtlet connections
    @IBOutlet weak var offerImageView: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    // MARK: Lifecylce
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Class methods
    func configure(offerDetails: OfferDetailsModel) {
        let opt = KingfisherOptionsInfo([.scaleFactor(UIScreen.main.scale), .transition(.fade(1)), .forceRefresh])
        self.offerImageView.configureKFImage(imageUrl: offerDetails.imageUrl ?? "", options: opt)
        self.offerImageView.layer.cornerRadius = 2.0
        self.offerImageView.clipsToBounds = true
        
        self.brandLabel.text = offerDetails.brand ?? "Not available"
        self.favoriteCountLabel.text = "\(offerDetails.favoriteCount ?? 0)"
        self.titleLabel.text = offerDetails.title ?? "Not available"
        self.tagsLabel.text = offerDetails.tags ?? "Not available"
    }

}
