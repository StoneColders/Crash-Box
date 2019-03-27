//
//  SpeedManager.swift
//  Crash Box
//
//  Created by Sarvad shetty on 3/28/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import CoreLocation

typealias Speed = CLLocationSpeed

protocol SpeedManagerDelegate {
    func speedDidChange(speed: Speed)
}

class SpeedManager: NSObject, CLLocationManagerDelegate {
    
    var delegate: SpeedManagerDelegate?
    private let locationManager: CLLocationManager?
    
    override init() {
        locationManager = CLLocationManager.locationServicesEnabled() ? CLLocationManager() : nil
        
        super.init()
        
        if let locationManager = self.locationManager {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            
            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
                locationManager.requestAlwaysAuthorization()
            } else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways {
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedAlways {
            locationManager?.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            let kmph = max(locations[locations.count - 1].speed / 1000 * 3600, 0);
            delegate?.speedDidChange(speed: kmph);
        }
    }
    
}
