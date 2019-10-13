//
//  AppDelegate.swift
//  Crash Box
//
//  Created by Sarvad shetty on 10/13/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase


let googleApiKey = "AIzaSyDYehlAYQxuKfX9v1HtRngi4C_nNA5byVw"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var speedTracker: SpeedTracker!
    var locationManager: CLLocationManager?
    var notificationCenter: UNUserNotificationCenter?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        //Tab bar properties
        UITabBar.appearance().barTintColor = tabBarColor
        UITabBar.appearance().tintColor = flashyRed
        UITabBar.appearance().unselectedItemTintColor = flashyRed
        
        self.locationManager = CLLocationManager()
        self.locationManager!.delegate = self
                   
        self.notificationCenter = UNUserNotificationCenter.current()
        self.notificationCenter!.delegate = self
        
        // define what do you need permission to use
        let options: UNAuthorizationOptions = [.alert, .sound]

        // request permission
        notificationCenter!.requestAuthorization(options: options) { (granted, error) in
          if !granted {
              print("Permission not granted")
          }
        }
        if launchOptions?[UIApplication.LaunchOptionsKey.location] != nil {
            print("I woke up thanks to geofencing")
        }
        
        GMSServices.provideAPIKey(googleApiKey)
        return true
    }
    
   

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

//MARK: - Extenions
extension AppDelegate: CLLocationManagerDelegate {
    // called when user Exits a monitored region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            // Do what you want if this information
            self.handleEvent(forRegion: region)
            print("EXITED")
        }
    }
    
    // called when user Enters a monitored region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            // Do what you want if this information
            self.handleEvent(forRegion: region)
            print("ENTERED")
        }
    }
    

    func handleEvent(forRegion region: CLRegion!) {

        // customize your notification content
        let content = UNMutableNotificationContent()
        content.title = "Alert!"
        content.body = "You are entering an accident prone area."
        content.sound = UNNotificationSound.default

        // when the notification will be triggered
        var timeInSeconds: TimeInterval = (10) // 60s * 15 = 15min
        // the actual trigger object
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInSeconds,
                                                        repeats: false)

        // notification unique identifier, for this example, same as the region to avoid duplicate notifications
        let identifier = region.identifier

        // the notification request object
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: trigger)

        // trying to add the notification request to notification center
        notificationCenter!.add(request, withCompletionHandler: { (error) in
            if error != nil {
                print("Error adding notification with identifier: \(identifier)")
            }
        })
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
  
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // when app is onpen and in foregroud
        completionHandler(.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // get the notification identifier to respond accordingly
        let identifier = response.notification.request.identifier
        
        // do what you need to do
      
        // ...
    }
  
}
