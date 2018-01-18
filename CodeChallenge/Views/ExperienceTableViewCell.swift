//
//  ExperienceTableViewCell.swift
//  CodeChallenge
//
//  Created by Pierluigi Galdi on 18/01/18.
//  Copyright © 2018 Pierluigi Galdi. All rights reserved.
//

import UIKit
import Kingfisher

class ExperienceTableViewCell: UITableViewCell {

    /// UIs
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    /// Core
    var experienceItem: Experience? {
        didSet {
            if self.experienceItem != nil {
                self.updateUI()
            }
        }
    }
    
    fileprivate func updateUI() {
        if let url = URL(string: experienceItem!.image) {
            self.previewImageView.kf.setImage(with: url)
        }
        self.titleLabel.text = self.experienceItem!.title
        self.subTitleLabel.text = String(format: "%@, %@", self.experienceItem!.city.name, self.experienceItem!.city.country.name)
        self.ratingLabel.text = String(format: "%d/5", self.experienceItem!.review_rating)
        self.priceLabel.text = CurrenciesConverter.getFormattedPrice(price: experienceItem!.price_usd_cents)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
