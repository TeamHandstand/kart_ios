//
//  AppDelegate.swift
//  Kart
//
//  Created by Sam Goldstein on 12/8/16.
//  Copyright © 2016 Sam Goldstein. All rights reserved.
//

import UIKit
//import PubNub
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
//    PubNubManager.sharedInstance
    KartLocationManager.sharedInstance.kartRequestPermission()
    KartLocationManager.sharedInstance.delegate = self
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
}

//MARK: CoreLocation Delegate
extension AppDelegate: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .authorizedAlways:
      KartLocationManager.sharedInstance.kartRequestPermission()
    default:
      showNoLocationPermissionAlert()
    }
    print("auth status did cahnge - \(status)")
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let firstName = UserDefaults.standard.object(forKey: KartUserDefaultsFirstName) as? String, let lastName = UserDefaults.standard.object(forKey: KartUserDefaultsLastName) as? String else {
      print("FAIL: no first or last name stored")
      return
    }
    if (firstName == "" || lastName == "") {
      print("FAIL: empty first of last name stored")
      return
    }
    
    for location in locations {
      let userLocation = UserLocation(name: "\(firstName) \(lastName)", latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
      let obj = ["name": userLocation.name, "latitude": userLocation.latitude, "longitude": userLocation.longitude, "accuracy": location.horizontalAccuracy] as [String : Any]
//      PubNubManager.sharedInstance.publishMessage(obj, onChannel: "run-channel") { (status) in
//        print("Sent 1 location.")
//      }
    }
    
    NotificationCenter.default.post(name: Notification.Name(rawValue: KartNotificationNewUserLocationGenerated), object: nil)
  }
  
  func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
    print("LocationManager Did PAUSE")
  }
  
  func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
    print("LocationManager Did RESUME")
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("\n\n\n\nLocationManager FAILED - \(error)\n\n\n\n\n")
  }
  
  func showNoLocationPermissionAlert() {
    let alert = UIAlertController(title: "Location Disabled", message: "Hey there! In order to compete in The SF Hunt, you'll have to allow us access to your location. We promise to use it for good and not evil. Touch 'Settings' to go to your Settings and turn this on.", preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
      if let url = URL(string: UIApplicationOpenSettingsURLString) {
        UIApplication.shared.openURL(url)
      }
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil))
    window?.rootViewController?.present(alert, animated: true, completion: nil)
  }
}
