//
//  MapViewController.swift
//  Crash Box
//
//  Created by Sarvad shetty on 10/13/19.
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
    
    //MARK: - IBActions
    @IBAction func refreshButton(_ sender: UIButton) {
        fetchNearbyPlaces(coordinate: mapView.camera.target)
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
        
        guard let mdetail = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MapDetailViewController") as? MapDetailViewController else {
            fatalError("couldnt mssgs")
        }
        
        if let photo = placeMarker.place.photo {
            mdetail.image = photo
        }else{
            mdetail.image = nil
        }
        
        let name = placeMarker.place.name
        mdetail.name = name
        mdetail.long = placeMarker.place.coordinate.longitude
        mdetail.lat = placeMarker.place.coordinate.latitude
        
        print("coordinate: \(placeMarker.place.coordinate)")
        self.present(mdetail, animated: true, completion: nil)

        return UIView()
    }
}
