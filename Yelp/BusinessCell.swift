//
//  BusinessCell.swift
//  Yelp
//
//  Created by Laura on 4/5/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import AFNetworking

class BusinessCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cuisineLabel: UILabel!
    
    var businesses: Business? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        
        // reset existing content to avoid flickering caused by the fact that cells are reused
        
        avatarImageView.image = nil
        restaurantNameLabel.text = nil
        distanceLabel.text = nil
        ratingImageView.image = nil
        reviewsCountLabel.text = nil
        addressLabel.text = nil
        cuisineLabel.text = nil

        if let businesses = businesses {

            if let avatarImageURL = businesses.imageURL {
                avatarImageView.setImageWith(avatarImageURL)
            }
            
            restaurantNameLabel.text = businesses.name
            distanceLabel.text = businesses.distance
            
            if let ratingURL = businesses.ratingImageURL {
                ratingImageView.setImageWith(ratingURL)
            }
            
            reviewsCountLabel.text = businesses.reviewCount?.stringValue
            addressLabel.text = businesses.address
            cuisineLabel.text = businesses.categories
        }
    }
    
    override func awakeFromNib() {
        avatarImageView.layer.cornerRadius = 5
        avatarImageView.clipsToBounds = true
    }
}
