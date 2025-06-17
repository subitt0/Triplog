//
//  AddTravelViewController.swift
//  Triplog
//
//  Created by 배수빈 on 6/12/25.
//

import UIKit
import CoreLocation

class AddTravelViewController: UIViewController {
    
    //이모지
    @IBOutlet weak var emoji_love: UIButton!
    @IBOutlet weak var emoji_happy: UIButton!
    @IBOutlet weak var emoji_neutral: UIButton!
    @IBOutlet weak var emoji_sad: UIButton!
    @IBOutlet weak var emoji_angry: UIButton!
    
    //제목
    @IBOutlet weak var titleTextField: UITextField!
    
    //날짜
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    //동행자
    @IBOutlet weak var familyButton: UIButton!
    @IBOutlet weak var friendButton: UIButton!
    @IBOutlet weak var aloneButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    
    //태그
    @IBOutlet weak var tagTextField1: UITextField!
    @IBOutlet weak var tagTextField2: UITextField!
    @IBOutlet weak var tagTextField3: UITextField!
    
    //사진 추가
    @IBOutlet weak var addPhotoButton: UIButton!
    
    //일기
    @IBOutlet weak var diaryTextView: UITextView!
    
    //위치
    @IBOutlet weak var locationTextField: UITextField!
    
    
    //저장버튼
    @IBOutlet weak var saveButton: UIButton!
    
    var selectedCompanion: String = ""
    var selectedEmoji: String = ""
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //모든 이모지 버튼 목록
        let emojiButtons = [emoji_love, emoji_happy, emoji_neutral, emoji_sad, emoji_angry]
        
        for button in emojiButtons {
            button?.backgroundColor = .white
            button?.tintColor = .clear
        }
        
        let tagTextFields = [tagTextField1, tagTextField2, tagTextField3]
        
        for tagTextField in tagTextFields {
            tagTextField?.layer.borderWidth = 1
            tagTextField?.layer.borderColor = UIColor.lightGray.cgColor
            tagTextField?.layer.cornerRadius = 6
            tagTextField?.clipsToBounds = true
        }
        
        let companionButtons = [familyButton, aloneButton, friendButton, otherButton]
        
        for button in companionButtons {
            button?.layer.borderWidth = 1
            button?.layer.borderColor = UIColor.lightGray.cgColor
            button?.layer.cornerRadius = 6
            button?.clipsToBounds = true
        }
        
        saveButton.backgroundColor = UIColor(red: 210/255, green: 195/255, blue: 171/255, alpha: 1.0)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 8
        
        diaryTextView.layer.borderWidth = 1
        diaryTextView.layer.borderColor = UIColor.lightGray.cgColor
        diaryTextView.layer.cornerRadius = 6
        diaryTextView.clipsToBounds = true
    }
    
    @IBAction func companionButtonTapped(_ sender: UIButton) {
        switch sender {
        case familyButton:
            selectedCompanion = "가족과"
        case friendButton:
            selectedCompanion = "친구와"
        case aloneButton:
            selectedCompanion = "혼자서"
        case otherButton:
            selectedCompanion = "기타"
        default:
            selectedCompanion = ""
        }
        
        [familyButton, friendButton, aloneButton, otherButton].forEach { $0?.backgroundColor = .clear }
        sender.backgroundColor = UIColor(red: 210/255, green: 195/255, blue: 171/255, alpha: 1.0)
        sender.clipsToBounds = true
    }
    
    @IBAction func emojiButtonTapped(_ sender: UIButton) {
        switch sender {
        case emoji_love:
            selectedEmoji = "love"
        case emoji_happy:
            selectedEmoji = "happy"
        case emoji_neutral:
            selectedEmoji = "neutral"
        case emoji_sad:
            selectedEmoji = "sad"
        case emoji_angry:
            selectedEmoji = "angry"
        default:
            selectedEmoji = ""
        }
        
        [emoji_love, emoji_happy, emoji_neutral, emoji_sad, emoji_angry].forEach {
            $0?.layer.borderWidth = 0
        }
        sender.layer.borderWidth = 2
        sender.layer.borderColor = UIColor.systemGray.cgColor
        sender.clipsToBounds = true
    }
    
    @IBAction func addPhotoButtonTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        //필수 항목 검사
        guard let title = titleTextField.text, !title.isEmpty,
              let location = locationTextField.text, !location.isEmpty,
              !selectedCompanion.isEmpty,
              !selectedEmoji.isEmpty else {
            showAlert(title: "필수 항목 누락", message: "제목, 동행인, 감정이모지, 위치는 필수 항목입니다.")
            return
        }
        
        //위치 형식 안내 메시지
        if location.count < 3 {
            showAlert(title: "위치 입력 오류", message: "위치는 3글자 이상 입력해주세요.")
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let start = formatter.string(from: startDatePicker.date)
        let end = formatter.string(from: endDatePicker.date)
        let dateRange = "\(start) - \(end)"
        
        let tags = [tagTextField1.text, tagTextField2.text, tagTextField3.text]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            guard let placemark = placemarks?.first,
                  let locationObj = placemark.location else {
                self.showAlert(title: "위치 인식 실패", message: "입력한 위치를 찾을 수 없습니다. 좀 더 구체적으로 입력해주세요.")
                return
            }
            
            var newTrip = Trip(
                title: title,
                dateRange: dateRange,
                companion: self.selectedCompanion,
                tags: tags,
                emoji: self.selectedEmoji,
                diary: self.diaryTextView.text ?? "",
                imageData: nil,
                locationName: location,
                latitude: locationObj.coordinate.latitude,
                longitude: locationObj.coordinate.longitude
            )
            
            if let selectedImage = self.selectedImage,
               let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
                newTrip.imageData = imageData
            }
            
            TripManager.shared.addTrip(newTrip)
            NotificationCenter.default.post(name: .didUpdateTrips, object: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
}

extension AddTravelViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            addPhotoButton.setTitle(nil, for: .normal)
            addPhotoButton.setImage(image, for: .normal) // 버튼 위에 이미지 미리 보여주기
            addPhotoButton.imageView?.contentMode = .scaleAspectFill
            addPhotoButton.clipsToBounds = true
        }
        picker.dismiss(animated: true)
    }
}
