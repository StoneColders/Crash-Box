//
//  AreaNotifier.swift
//  Crash Box
//
//  Created by Sarvad shetty on 10/13/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import Foundation
import CoreLocation

class AreaNotifier: NSObject, CLLocationManagerDelegate {
    
    //MARK: - Variables
    private let locationManager: CLLocationManager
    
    //MARK: - Initializer
    override init() {
        locationManager = CLLocationManager()
        //location manager needs to be initialised before super init
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
         self.locationManager.requestAlwaysAuthorization()
    }
    
    //MARK: - Functions
    func startTracking() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        //else start updating
//        locationManager.startUpdatingLocation()
        setupIdentifier()
    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation()
    }
    
    func setupIdentifier() {
//        print(locationManager.cc)
        let geoFenceRegionCenter = CLLocationCoordinate2DMake(12.9710456, 79.1635128)
        let geoFenceRegion = CLCircularRegion(center: geoFenceRegionCenter, radius: 25, identifier: "UniqueIdentifier")
        geoFenceRegion.notifyOnEntry = true
        geoFenceRegion.notifyOnExit = true
        
        locationManager.startMonitoring(for: geoFenceRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.last?.coordinate)
    }
}
