//
//  MainPageViewController.swift
//  Triplog
//
//  Created by 배수빈 on 6/12/25.
//

import UIKit

class MainPageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var trips: [Trip] {
        return TripManager.shared.trips
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        //super.viewDidLoad()
        TripManager.shared.loadTrips()
        
        print("✅ MainPageViewController loaded")
        
        addButton.setTitleColor(.systemGray2, for: .normal)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleTripAdded(_:)),
            name: .didAddTrip,
            object: nil
        )
        print("collectionView: \(collectionView != nil ? "연결됨 ✅" : "nil ❌")")
        print("delegate: \(collectionView.delegate != nil ? "✅" : "❌")")
        print("dataSource: \(collectionView.dataSource != nil ? "✅" : "❌")")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("🔥 아이템 개수: \(trips.count) 반환")
        
        return trips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let trip = trips[indexPath.item]
        
        // 🔍 콘솔에 Trip 정보 출력
        print("🧾 Trip \(indexPath.item):")
        print("- 제목: \(trip.title)")
        print("- 날짜: \(trip.dateRange)")
        print("- 동행인: \(trip.companion)")
        print("- 태그: \(trip.tags)")
        print("- 이모지: \(trip.emoji)")
        print("- 이미지 있음? \(trip.imageData != nil ? "✅" : "❌")")
        print("- 일기: \(trip.diary)")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TripCardCell", for: indexPath) as! TripCardCell
        cell.configure(with: trip)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "TravelDetailVC") as? TravelDetailViewController {
            detailVC.trip = TripManager.shared.trips[indexPath.item]
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addVC = storyboard.instantiateViewController(withIdentifier: "AddTravelVC") as! AddTravelViewController
        navigationController?.pushViewController(addVC, animated: true)
        print("버튼 눌림 ✅")
    }
    
    @objc func handleTripAdded(_ notification: Notification) {
        guard let trip = notification.object as? Trip else { return }
        TripManager.shared.addTrip(trip)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 100)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("📢 화면 보임, trips: \(trips.count)")
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
}


