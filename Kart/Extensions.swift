//
//  Extensions.swift
//  Kart
//
//  Created by Sam Goldstein on 12/8/16.
//  Copyright © 2016 Sam Goldstein. All rights reserved.
//

import Foundation

extension Array {
  var randomElement: Element {
    return self[Int(arc4random_uniform(UInt32(count)))]
  }
}

extension NSObject {
  func delay(delay:Double, closure:()->()) {
    dispatch_after(
      dispatch_time(DISPATCH_TIME_NOW,Int64(delay * Double(NSEC_PER_SEC))),
      dispatch_get_main_queue(),
      closure)
  }
}
