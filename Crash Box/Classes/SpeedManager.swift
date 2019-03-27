//
//  SpeedManager.swift
//  Crash Box
//
//  Created by Sarvad shetty on 3/28/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

//import CoreLocation
//
//typealias Speed = CLLocationSpeed
//
//protocol SpeedManagerDelegate {
//    func speedDidChange(speed: Speed)
//}
//
//class SpeedManager: NSObject, CLLocationManagerDelegate {
//
//    var delegate: SpeedManagerDelegate?
//    private let locationManager: CLLocationManager?
//
//    override init() {
//        locationManager = CLLocationManager.locationServicesEnabled() ? CLLocationManager() : nil
//
//        super.init()
//
//        if let locationManager = self.locationManager {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
//
//            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
//                locationManager.requestAlwaysAuthorization()
//            } else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways {
//                locationManager.startUpdatingLocation()
//            }
//        }
//    }
//
//    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        if status == CLAuthorizationStatus.authorizedAlways {
//            locationManager?.startUpdatingLocation()
//        }
//    }
//
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if locations.count > 0 {
//            let kmph = max(locations[locations.count - 1].speed / 1000 * 3600, 0);
//            delegate?.speedDidChange(speed: kmph);
//        }
//    }
//
//}


import Foundation
import CoreLocation

class SpeedTracker: NSObject, CLLocationManagerDelegate {
    
    enum Notifications: String {
        case CurrentSpeedNotification
        
        static let CurrentSpeed = "SpeedTracker.CurrentSpeed"
        static let MaxSpeed = "SpeedTracker.MaxSpeed"
    }
    
    private(set) var currentSpeed: Double
    private(set) var maxSpeed: Double
    
    private let locationManager: CLLocationManager
    
    override init() {
        print("herererererere")
        locationManager = CLLocationManager()
        currentSpeed = 0.0
        maxSpeed = 0.0
        
        super.init()
        
        restoreSpeeds()
//        startTracking()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func startTracking() {
        print("hereghgfhfgfgfg")
        if CLLocationManager.authorizationStatus() == .notDetermined {
            print("dsajdgaj")
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.startUpdatingLocation()
    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation()
    }
    
    func resetMaxSpeed() {

        DispatchQueue.main.async {
            self.maxSpeed = 0.0
            self.updateSpeed(speedInMetersPerSecond: self.currentSpeed)
        }

    }
    
    private func updateSpeed(speedInMetersPerSecond: Double) {
        
        DispatchQueue.main.async {
            self.currentSpeed = max(0.0, speedInMetersPerSecond)
            self.maxSpeed = max(self.maxSpeed, self.currentSpeed)
            
            let userInfo = [Notifications.CurrentSpeed: NSNumber(value: self.currentSpeed),
                            Notifications.MaxSpeed: NSNumber(value: self.maxSpeed)]
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notifications.CurrentSpeedNotification.rawValue), object: self, userInfo: userInfo)
            self.saveSpeeds()
        }
        
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        print("last location speed \(lastLocation.speed)")
        updateSpeed(speedInMetersPerSecond: lastLocation.speed)
    }
}

// MARK: Persistence
extension SpeedTracker {
    private enum Defaults: String {
        case CurrentSpeed = "SpeedTracker.CurrentSpeed"
        case MaxSpeed = "SpeedTracker.MaxSpeed"
    }
    
    func saveSpeeds() {
        let defaults = UserDefaults.standard

        DispatchQueue.main.async {
            defaults.set(self.currentSpeed, forKey: Defaults.CurrentSpeed.rawValue)
            defaults.set(self.maxSpeed, forKey: Defaults.MaxSpeed.rawValue)
        }
    }
    
    func restoreSpeeds() {
        let defaults = UserDefaults.standard
        
        currentSpeed = defaults.double(forKey: Defaults.CurrentSpeed.rawValue)
        maxSpeed = defaults.double(forKey: Defaults.MaxSpeed.rawValue)
    }
}


func formatForCurrentLocale(speedInMetersPerSecond speed: Double) -> String {
//        let convertedSpeed = round(speed * 3.6)
//        let speedString = String(format: "%.0f", convertedSpeed)
        return "\(speed) km/h"
}
