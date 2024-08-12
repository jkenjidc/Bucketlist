//
//  ContentView-ViewModel.swift
//  Bucketlist
//
//  Created by Kenji Dela Cruz on 8/12/24.
//

import Foundation
import MapKit
import CoreLocation
import SwiftUI
import LocalAuthentication

extension ContentView {
    @Observable
    class ViewModel {
        let startPosition = MapCameraPosition.region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)))
        
        private(set) var locations: [Location]
        var selectedPlace: Location?
        var isUnlocked = false
        var inStandardMode = true
        var authError = false
        var authErrorMessage = "Unable to authenticate"
        
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save () {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data")
            }
        }
        
        func addLocation (at point: CLLocationCoordinate2D) {
            let newLocation =  Location(id: UUID(), name: "New Location", description: "", latitude: point.latitude, longtitude: point.longitude)
            locations.append(newLocation)
            save()
        }
        
        func updateLocation(location: Location) {
            guard let selectedPlace else { return }
            
            if let index = locations.firstIndex(of: selectedPlace){
                locations[index] = location
                save()
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {sucess, authenticationError in
                    if sucess {
                        self.isUnlocked = true
                    } else {
                        self.authError = true
                    }
                }
            } else {
                self.authError = true
                authErrorMessage = "No valid authentication method"
            }
        }
    }
}
