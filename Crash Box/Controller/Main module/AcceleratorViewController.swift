//
//  AcceleratorViewController.swift
//  Crash Box
//
//  Created by Sarvad shetty on 10/13/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation
import Lottie
import MessageUI
import Firebase

class AcceleratorViewController: UIViewController {
    
    //MARK: - Variables
    var motionManager = CMMotionManager()
    var speedTracker: SpeedTracker! = SpeedTracker()
    var speedoMeter = AccelerometerSpeedometer()
    var areaNotifier: AreaNotifier!
    var displayLink:CADisplayLink?
    let locationManager2 = CLLocationManager()
    var currLocation:CLLocation!
    var currenLocManager:CLLocationManager = CLLocationManager()
    var speed:Double = 0;
    
    //MARK: - IBOutlets
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedoViewOutlet: UIView!
    @IBOutlet weak var animationView: LOTAnimationView!
    @IBOutlet weak var animationView2: LOTAnimationView!
    
    //MARK: - Main functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationView2.isHidden = true
        formatAndUpdateLabels(currentSpeed: speedTracker.currentSpeed, maxSpeed: speedTracker.maxSpeed)
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: SpeedTracker.Notifications.CurrentSpeedNotification.rawValue), object: speedTracker, queue: OperationQueue.main, using: { (notification) in
                guard let currentSpeedNumber = notification.userInfo?[SpeedTracker.Notifications.CurrentSpeed] as? NSNumber,
                    let maxSpeedNumber = notification.userInfo?[SpeedTracker.Notifications.MaxSpeed] as? NSNumber else {
                        fatalError()
                }
                self.formatAndUpdateLabels(currentSpeed: currentSpeedNumber.doubleValue, maxSpeed: maxSpeedNumber.doubleValue)
            })
        setupSpeedoView()
        self.locationManager2.requestAlwaysAuthorization()
              
              // Your coordinates go here (lat, lon)
              let geofenceRegionCenter = CLLocationCoordinate2D(
                  latitude: 12.9710456,
                  longitude: 79.1635128
              )
        
              let geofenceRegion = CLCircularRegion(
                  center: geofenceRegionCenter,
                  radius: 100,
                  identifier: "UniqueIdentifier"
              )
              
              geofenceRegion.notifyOnEntry = true
              geofenceRegion.notifyOnExit = true
              self.locationManager2.startMonitoring(for: geofenceRegion)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startTrackingOrShowLocationAlert()
        accelerometerValuesInG()
    }
    
    //MARK: - Functions
    func testMessage(){
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.recipients = ["8826033466"]
        composeVC.body = "Hello from California!"
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    //MARK: - Core Motion functions
    func accelerometerValuesInG(){
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            if let accelData = data{
                
                let x = accelData.acceleration.x
                let y = accelData.acceleration.y
                let z = accelData.acceleration.z
                let g = (x * x) + (y * y) + (z * z)
                let underRoot = g.squareRoot()
                
                if(underRoot > 5){
                    self.setBeacon()
                }else{
                    self.animationView2.isHidden = true
                }
            }
        }
    }
    
    @objc func update() {
        speedLabel.text = String(format: "%.02f", speed)
    }
    
    func setBeacon(){
        var long:CLLocationDegrees?
        var lat:CLLocationDegrees?
        
        currenLocManager.requestWhenInUseAuthorization()
        
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            currLocation = currenLocManager.location
        }
        
        self.animationView2.isHidden = false
        motionManager.stopAccelerometerUpdates()
        self.animationView2.setAnimation(named: "beacon")
        self.animationView2.play()
        self.animationView2.loopAnimation = true
        
        long = currLocation.coordinate.longitude
        lat = currLocation.coordinate.latitude
        
        print("long \(long!)")
        
        //bring up alert
        let alert = UIAlertController(title: "Alert", message: "Do you want to reach out for help.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
            self.uploadCoord(long: Double(long!), lat: Double(lat!))
            self.animationView2.stop()
            self.animationView2.isHidden = true
        }))
        alert.addAction(UIAlertAction(title: "Contact", style: .default, handler: { (_) in
            print("contact")
            self.uploadCoord(long: Double(long!), lat: Double(lat!))
            self.animationView2.stop()
            self.animationView2.isHidden = true
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        let when = DispatchTime.now() + 10
        DispatchQueue.main.asyncAfter(deadline: when){
          // your code with delay
            alert.dismiss(animated: true) {
                print("contact part 2")
                self.uploadCoord(long: Double(long!), lat: Double(lat!))
                self.animationView2.stop()
                self.animationView2.isHidden = true
            }
        }
    }
    
    func uploadCoord(long:Double,lat:Double) {
        let uid = UserDefaults.standard.string(forKey: "uid")
        let data = [uid:["long":long,"lat":lat]]
        DataService.dataService._BASE_REF.child("clusters").setValue(data)
        
    }
    
    private func formatAndUpdateLabels(currentSpeed: Double, maxSpeed: Double) {
        //updated speedometer data here
        speedLabel.text = "\(Int(currentSpeed))"
        if Int(currentSpeed) == 0{
            #warning("change this")
            animationView.setAnimation(named: "road moving")
            animationView.play()
            animationView.loopAnimation = true
        }else if Int(currentSpeed) > 0{
            animationView.setAnimation(named: "road moving")
            animationView.play()
            animationView.loopAnimation = true
        }else{
            animationView.setAnimation(named: "road still")
            animationView.play()
        }
    }
    
    private func startTrackingOrShowLocationAlert() {
        speedTracker.startTracking()
        
        let locationPermissions = CLLocationManager.authorizationStatus()
        if locationPermissions == .restricted || locationPermissions == .denied {
            let alertController = UIAlertController(title: "Location Services Required", message: "Location services must be enabled for this app, and turned on in Settings, in order to display your speed.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func setupSpeedoView(){
        speedoViewOutlet.layer.cornerRadius = 4
        speedoViewOutlet.layer.borderWidth = 2
        speedoViewOutlet.layer.borderColor = UIColor.init(255, 0, 58, 1).cgColor
        speedoViewOutlet.layer.masksToBounds = false
        speedoViewOutlet.layer.shadowRadius = 3.0
        speedoViewOutlet.layer.shadowColor = UIColor.init(252, 34, 34, 0.69).cgColor
        speedoViewOutlet.layer.shadowOffset = CGSize(width: 0, height: 3)
        speedoViewOutlet.layer.shadowOpacity = 10
    }
}

//MARK: - Extension
extension AcceleratorViewController: MFMessageComposeViewControllerDelegate{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        print("hi")
    }
}
