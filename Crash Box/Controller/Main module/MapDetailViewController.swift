//
//  MapDetailViewController.swift
//  Crash Box
//
//  Created by Sarvad shetty on 3/28/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapDetailViewController: UIViewController {
    
    //MARK: - Varaibles
    var image:UIImage?
    var name:String?
    var long:CLLocationDegrees?
    var lat:CLLocationDegrees?
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var imageVw: UIImageView!
    @IBOutlet weak var nameOfPremise: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var requestHelpOutlet: UIButton!
    
    
    //MARK: - Main
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    //MARK: - Function
    
    func setup(){
        requestHelpOutlet.layer.borderWidth = 1
        requestHelpOutlet.layer.borderColor = UIColor.init(255, 0, 58, 1.0).cgColor
        
        if image != nil{
            imageVw.image = image
        }else{
            imageVw.image = UIImage(named: "defHos")
        }
        
        nameOfPremise.text = "\(name!)"
        
        locManager.requestWhenInUseAuthorization()
        
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            
            currentLocation = locManager.location
            
            let location1 = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            let location2 = CLLocation(latitude: lat!, longitude: long!)
            
            let distance : CLLocationDistance = location2.distance(from: location1)
            
            distanceLabel.text = "\(Int(distance/1000)) km"
            
        }
        
    }
    
    //MARK: - IBAction
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func requestHelp(_ sender: UIButton) {
    }
    
    
}
