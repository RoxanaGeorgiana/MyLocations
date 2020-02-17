//
//  LocationManager.swift
//  MyLocations
//
//  Created by Puf, Roxana on 16/02/2020.
//  Copyright © 2020 Puf, Roxana. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let sharedManager = LocationManager()
    private var locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    
    private override init () {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()

        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined) {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0]
    }   
}
