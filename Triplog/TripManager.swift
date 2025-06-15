//
//  TripManager.swift
//  Triplog
//
//  Created by 배수빈 on 6/13/25.
//

import Foundation

class TripManager {
    static let shared = TripManager()
    
    private(set) var trips: [Trip] = []
    
    private let saveURL: URL = {
        let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return doc.appendingPathComponent("trips.json")
    }()
    
    func saveTrips() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(trips) {
            try? data.write(to: saveURL)
        }
    }
    
    func loadTrips() {
        let decoder = JSONDecoder()
        if let data = try? Data(contentsOf: saveURL),
           let decoded = try? decoder.decode([Trip].self, from: data) {
            trips = decoded
        }
    }
    
    func addTrip(_ trip: Trip) {
        trips.append(trip)
        saveTrips()
    }
    
    func deleteTrip(_ trip: Trip) {
        trips.removeAll { $0.title == trip.title && $0.dateRange == trip.dateRange }
        saveTrips()
    }
}
