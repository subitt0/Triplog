//
//  Trip.swift
//  Triplog
//
//  Created by 배수빈 on 6/13/25.
//

import UIKit

struct Trip: Codable {
    var title: String
    var dateRange: String
    var companion: String
    var tags: [String]
    var emoji: String
    var diary: String
    
    var imageData: Data?
    
    var locationName: String
    var latitude: Double? //반환된 위도
    var longitude: Double? //반환된 경도
}
