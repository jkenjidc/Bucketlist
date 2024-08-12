//
//  Location.swift
//  Bucketlist
//
//  Created by Kenji Dela Cruz on 8/9/24.
//

import Foundation
import MapKit

struct Location: Codable, Equatable, Identifiable {
    var id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longtitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
    }
    
    #if DEBUG
    static let example = Location(id: UUID(), name: "Buckingham Palace", description: "Trial test yir", latitude: 51.501, longtitude: -0.141)
    #endif
    
    static func ==(lhs: Location, rhs:Location) -> Bool {
        lhs.id == rhs.id
    }
}
