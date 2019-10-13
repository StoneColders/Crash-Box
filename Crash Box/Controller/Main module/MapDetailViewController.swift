//
//  MapDetailViewController.swift
//  Crash Box
//
//  Created by Sarvad shetty on 10/13/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import JGProgressHUD

class MapDetailViewController: UIViewController {
    
    //MARK: - Variables
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
    @IBAction func requestHelp(_ sender: UIButton) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Making request..."
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 6.0)
        
//        let hud2 = JGProgressHUD(style: .dark)
//        hud2.textLabel.text = "Request accepted"
//        hud2.show(in: self.view)
//        hud2.dismiss(afterDelay: 14.0)
    }
    
    
}
