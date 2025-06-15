//
//  MapViewController.swift
//  Triplog
//
//  Created by 배수빈 on 6/12/25.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadMapPins),
            name: .didUpdateTrips,
            object: nil
        )
        showAllTripPins()
    }
    
    @objc func reloadMapPins() {
        mapView.removeAnnotations(mapView.annotations) // 기존 핀 삭제
        showAllTripPins()
    }
    
    func showAllTripPins() {
        mapView.removeAnnotations(mapView.annotations)
        
        for trip in TripManager.shared.trips {
            if let lat = trip.latitude, let lon = trip.longitude {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                annotation.title = trip.locationName
                annotation.subtitle = trip.title // 👉 나중에 식별용으로 사용
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation,
              let title = annotation.subtitle else { return }
        
        // subtitle로 Trip 찾기
        if let trip = TripManager.shared.trips.first(where: { $0.title == title }) {
            // TravelDetailViewController로 이동
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let detailVC = storyboard.instantiateViewController(withIdentifier: "TravelDetailVC") as? TravelDetailViewController {
                detailVC.trip = trip
                navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadMapPins()
    }
}
