//
//  LocationManager.swift
//  MusicRoom
//
//  Created by Etienne TRANCHIER on 12/18/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: CLLocationManager {
    static let sharedInstance = LocationManager()
    
    func setup() {
        self.delegate = self
        self.desiredAccuracy = kCLLocationAccuracyBest
        self.requestAlwaysAuthorization()
        self.requestLocation()
        self.startUpdatingLocation()
    }
}

extension LocationManager : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            manager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
        print(error.localizedDescription)
    }
}
