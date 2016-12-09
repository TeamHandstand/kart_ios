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