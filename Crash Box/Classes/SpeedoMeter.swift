//
//  SpeedoMeter.swift
//  Crash Box
//
//  Created by Sarvad shetty on 10/13/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import CoreMotion

class AccelerometerSpeedometer {
    
    //MARK: - Variables
    var motionManager = CMMotionManager()
    
    //MARK: - Initilaizers
    init() {
           setupMotionManager()
       }
    
    //MARK: - Functions
    func getMotionManager() -> CMMotionManager { return motionManager }
    
    func setupMotionManager() {
        if (motionManager.isAccelerometerAvailable) {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates()
        } else {
            print("Accelerometer not availible on this device")
        }
    }
    
    func getAccelerationValues() -> (x:Double, y:Double, z:Double) {
        let accel = motionManager.accelerometerData?.acceleration
        return (x: accel!.x, y: accel!.y, z: accel!.z)
    }
    
}
