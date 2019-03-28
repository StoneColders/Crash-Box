//
//  MapViewController.swift
//  Crash Box
//
//  Created by Sarvad shetty on 3/28/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    //MARK: - Variables
    private let locationManager = CLLocationManager()
    private let dataProvider = GoogleDataProvider()
    private let searchRadius: Double = 1000
    var searchedTypes = ["hospital","police"]
    
    //MARK: - IBOutlets
    @IBOutlet weak var mapView: GMSMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        locationSetup()
        mapViewDelegateSetup()
    }
    
    //MARK: - Functions
    func locationSetup(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.setMinZoom(4.6, maxZoom: 20)
    }
}

//MARK: - Extensions
extension MapViewController: CLLocationManagerDelegate {

    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        if toLocation != nil {
            mapView.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 16)
        }
    }
    
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation]) {
        let location = locationManager.location?.coordinate
        cameraMoveToLocation(toLocation: location)
        fetchNearbyPlaces(coordinate: location!)
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
           print("\(lines.joined(separator: "\n"))")

        }
    }
    
    private func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        dataProvider.fetchPlacesNearCoordinate(coordinate, radius:searchRadius, types: searchedTypes) { places in
            places.forEach {
                let marker = PlaceMarker(place: $0)
                marker.map = self.mapView
            }
        }
    }
}

// MARK: - GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
    
    func mapViewDelegateSetup(){
        mapView.delegate = self
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if (gesture) {
            mapView.selectedMarker = nil
        }
    }

    
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        guard let placeMarker = marker as? PlaceMarker else {
            return nil
        }

//        guard let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView else {
//            return nil
//        }
//        infoView.nameLabel.text = placeMarker.place.name
//
//        if let photo = placeMarker.place.photo {
//            infoView.placePhoto.image = photo
//        } else {
//            infoView.placePhoto.image = UIImage(named: "generic")
//        }

//        return infoView
        
        let infoView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        infoView.backgroundColor = UIColor.red
        return infoView
    }
}
