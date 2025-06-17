//
//  TravelDetailViewController.swift
//  Triplog
//
//  Created by 배수빈 on 6/14/25.
//

import UIKit

class TravelDetailViewController: UIViewController {
    var trip: Trip?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var companionLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var emojiImageView: UIImageView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var diaryTextView: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        diaryTextView.layer.borderWidth = 1
        diaryTextView.layer.borderColor = UIColor.lightGray.cgColor
        diaryTextView.layer.cornerRadius = 6
        diaryTextView.clipsToBounds = true
        
    }
    
    private func configureUI() {
        guard let trip = trip else { return }
        titleLabel.text = trip.title
        dateLabel.text = trip.dateRange
        companionLabel.text = trip.companion
        tagLabel.text = trip.tags.joined(separator: " ")
        emojiImageView.image = UIImage(named: imageName(for: trip.emoji))
        if let data = trip.imageData {
            photoImageView.image = UIImage(data: data)
        }
        diaryTextView.text = trip.diary
        
        diaryTextView.textColor = .label
        diaryTextView.font = UIFont.systemFont(ofSize: 16)
        diaryTextView.layer.borderWidth = 1
        diaryTextView.layer.borderColor = UIColor.red.cgColor
        
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        guard let trip = trip else { return }
        
        let alert = UIAlertController(title: "삭제 확인", message: "이 여행 기록을 삭제할까요?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            TripManager.shared.deleteTrip(trip)
            NotificationCenter.default.post(name: .didUpdateTrips, object: nil)
            
            // 홈 화면으로 이동
            self.navigationController?.popViewController(animated: true)
        }))
        
        present(alert, animated: true)
    }
    
    private func imageName(for emojiKey: String) -> String {
        switch emojiKey {
        case "love": return "emoji_love"
        case "happy": return "emoji_happy"
        case "neutral": return "emoji_neutral"
        case "sad": return "emoji_sad"
        case "angry": return "emoji_angry"
        default: return "emoji_neutral"
        }
    }
}
