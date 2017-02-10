//
//  KartMotionManager.swift
//  Kart
//
//  Created by Sam Goldstein on 1/9/17.
//  Copyright © 2017 Sam Goldstein. All rights reserved.
//

import Foundation
import CoreMotion

final class KartMotionManager: CMMotionManager {
  static let sharedInstance = KartMotionManager()
  
  fileprivate override init() {
    super.init()
    accelerometerUpdateInterval = 0.01
    
  }
}
