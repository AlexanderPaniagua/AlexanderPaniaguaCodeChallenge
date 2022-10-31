//
//  ImageViewExtension.swift
//  AlexanderPaniaguaCodeChallenge
//
//  Created by Alexander Paniagua on 30/10/22.
//

import UIKit
import Kingfisher

extension UIImageView {

    func configureKFImage(imageUrl: String, options: KingfisherOptionsInfo?) {
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: URL(string: imageUrl),
            placeholder: UIImage(named: "iconLucky"),
            options: options
        )
    }

}
