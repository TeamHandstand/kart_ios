//
//  KartLocationManager.swift
//  Kart
//
//  Created by Sam Goldstein on 12/9/16.
//  Copyright © 2016 Sam Goldstein. All rights reserved.
//

import Foundation
import CoreLocation

final class KartLocationManager: CLLocationManager {
  static let sharedInstance = KartLocationManager()
  
  //This prevents others from using the default '()' initializer for this class.
  fileprivate override init() {
    super.init()
    allowsBackgroundLocationUpdates = true
    activityType = .fitness
    pausesLocationUpdatesAutomatically = false //true
    desiredAccuracy = kCLLocationAccuracyBest // kCLLocationAccuracyNearestTenMeters
  }
  
  override func startUpdatingLocation() {
    super.startUpdatingLocation()
    startMonitoringSignificantLocationChanges()
  }
  
  override func stopUpdatingLocation() {
    super.stopUpdatingLocation()
    stopMonitoringSignificantLocationChanges()
  }
  
  func kartRequestPermission() {
    requestAlwaysAuthorization()
  }
  
  
}
