//
//  TripCardCell.swift
//  Triplog
//
//  Created by 배수빈 on 6/13/25.
//

import UIKit

class TripCardCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var companionLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var emojiImageView: UIImageView!
    
    func configure(with trip: Trip) {
        if let data = trip.imageData {
            imageView.image = UIImage(data: data)
        }
        titleLabel.text = trip.title
        dateLabel.text = trip.dateRange
        companionLabel.text = trip.companion
        tagLabel.text = trip.tags.joined(separator: " ")
        emojiImageView.image = UIImage(named: "emoji_\(trip.emoji)")
    }
    
}
