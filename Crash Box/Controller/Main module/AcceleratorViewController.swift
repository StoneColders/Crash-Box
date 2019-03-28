//
//  AcceleratorViewController.swift
//  Crash Box
//
//  Created by Sarvad shetty on 3/27/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation
import Lottie

class AcceleratorViewController: UIViewController {
    
    //MARK: - Variables
    var motionManager = CMMotionManager()
    var speedTracker: SpeedTracker! = SpeedTracker()
    
    //MARK: - IBOutlets
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedoViewOutlet: UIView!
    @IBOutlet weak var animationView: LOTAnimationView!
    
    
    //MARK: - Main functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatAndUpdateLabels(currentSpeed: speedTracker.currentSpeed, maxSpeed: speedTracker.maxSpeed)
        
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: SpeedTracker.Notifications.CurrentSpeedNotification.rawValue), object: speedTracker, queue: OperationQueue.main, using: { (notification) in
                
                guard let currentSpeedNumber = notification.userInfo?[SpeedTracker.Notifications.CurrentSpeed] as? NSNumber,
                    let maxSpeedNumber = notification.userInfo?[SpeedTracker.Notifications.MaxSpeed] as? NSNumber else {
                        fatalError()
                }

                self.formatAndUpdateLabels(currentSpeed: currentSpeedNumber.doubleValue, maxSpeed: maxSpeedNumber.doubleValue)
            })
        
        setupSpeedoView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        startTrackingOrShowLocationAlert()
//        accelerometerValuesInG()
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
                print("Total G value \(underRoot)")
            }
        }
    }
    
    private func formatAndUpdateLabels(currentSpeed currentSpeed: Double, maxSpeed: Double) {
        //updated speedometer data here
        speedLabel.text = "\(Int(currentSpeed))"
        
        if Int(currentSpeed) == 0{
            animationView.setAnimation(named: "road still")
            animationView.play()
        }else if Int(currentSpeed) > 0{
            animationView.setAnimation(named: "road moving")
            animationView.play()
            animationView.loopAnimation = true
        }else{
            animationView.setAnimation(named: "road still")
            animationView.play()
        }
        
//        let ind = 10
        
//        if Int(ind) == 0{
//            animationView.setAnimation(named: "road still")
//            animationView.play()
//        }else if Int(ind) > 0{
//            animationView.setAnimation(named: "road moving")
//            animationView.play()
//            animationView.loopAnimation = true
//        }else{
//            animationView.setAnimation(named: "road still")
//            animationView.play()
//        }
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

