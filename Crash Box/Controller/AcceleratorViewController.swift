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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        accelerometerValuesInG()
    }
    
    //MARK: - Core Motion functions
    func accelerometerValuesInG(){
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            if let accelData = data{
                var x = accelData.acceleration.x
                var y = accelData.acceleration.y
                var z = accelData.acceleration.z
                
//                print("x is \(accelData.acceleration.x)")
//                x = x * 10
//                y = y * 10
//                z = z * 10
                
                let g = (x * x) + (y * y) + (z * z)
                let underRoot = g.squareRoot()
                print("under root \(underRoot)")
                
                
            }
        }
    }
}
