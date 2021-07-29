//
//  NativeAdCell.swift
//  Studee
//
//  Created by Navjeeven Mann on 2021-05-06.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import UIKit
import GoogleMobileAds
class NativeAdCell: UITableViewCell {
    @IBOutlet weak var mediaView: GADMediaView!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var bodyView: UILabel!
    @IBOutlet weak var callToAction: UIButton!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    @IBOutlet weak var adView: GADUnifiedNativeAdView!
    @IBOutlet weak var advertiserLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func setAdInfo(nativeAd: GADUnifiedNativeAd) {
        self.adView.nativeAd = nativeAd
        self.headlineLabel.text = nativeAd.headline

        self.priceLabel.text = nativeAd.price

        if let starRating = nativeAd.starRating {
            starLabel.text = starRating.description + "\u{2605}"
        }

        self.bodyView.text = nativeAd.body
        self.advertiserLabel.text = nativeAd.advertiser
        self.callToAction.isUserInteractionEnabled = false
        self.callToAction.setTitle(nativeAd.callToAction, for: .normal)
    }
}
