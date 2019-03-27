//
//  AcceleratorViewController.swift
//  Crash Box
//
//  Created by Sarvad shetty on 3/27/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit
import CoreMotion

class AcceleratorViewController: UIViewController {
    
    //MARK: - Variables
    var motionManager = CMMotionManager()
     var speedTracker: SpeedTracker! = SpeedTracker()
    
    @IBOutlet weak var speedLabel: UILabel!
    
    
    //MARK: - Main functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("speed: \(speedTracker.currentSpeed)")
        print("max: \(speedTracker.maxSpeed)")
        
//        formatAndUpdateLabels(currentSpeed: speedTracker.currentSpeed, maxSpeed: speedTracker.maxSpeed)
        
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: SpeedTracker.Notifications.CurrentSpeedNotification.rawValue), object: speedTracker, queue: OperationQueue.main, using: { (notification) in
                
                guard let currentSpeedNumber = notification.userInfo?[SpeedTracker.Notifications.CurrentSpeed] as? NSNumber,
                    let maxSpeedNumber = notification.userInfo?[SpeedTracker.Notifications.MaxSpeed] as? NSNumber else {
                        fatalError()
                }

                self.formatAndUpdateLabels(currentSpeed: currentSpeedNumber.doubleValue, maxSpeed: maxSpeedNumber.doubleValue)
            })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        accelerometerValuesInG()
    }
    
    //MARK: - Core Motion functions
    func accelerometerValuesInG(){
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            if let accelData = data{
                
                let x = accelData.acceleration.x
                let y = accelData.acceleration.y
                let z = accelData.acceleration.z
//                print("x is \(accelData.acceleration.x)")
//                x = x * 10
//                y = y * 10
//                z = z * 10
                let g = (x * x) + (y * y) + (z * z)
                let underRoot = g.squareRoot()
//                print("Total G value \(underRoot)")
            }
        }
    }
    
    private func formatAndUpdateLabels(currentSpeed currentSpeed: Double, maxSpeed: Double) {
        speedLabel.text = "speed: \(formatForCurrentLocale(speedInMetersPerSecond: currentSpeed))"
    }
}

