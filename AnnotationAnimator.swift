//
//  AnnotationAnimator.swift
//  Kart
//
//  Created by Sam Goldstein on 12/9/16.
//  Copyright © 2016 Sam Goldstein. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

extension CLLocationCoordinate2D {
  func coordinatePathToPoint(_ endCoordinate: CLLocationCoordinate2D, mapRegion: MKCoordinateRegion) -> [CLLocationCoordinate2D] {
    
    let startCoordinate = self
    
    mapRegion.span.latitudeDelta
    mapRegion.span.longitudeDelta
    
    let latDelta = mapRegion.span.latitudeDelta
    var coordinatesGenerated = 100
    
    if latDelta < 0.02 {
      coordinatesGenerated /= 1
    } else if (latDelta < 0.04) {
      coordinatesGenerated /= 10
    } else if (latDelta < 0.06) {
      coordinatesGenerated /= 50
    } else { //if (latDelta < 0.08) {
      coordinatesGenerated /= 1000
    }
    
    var coordinates = [CLLocationCoordinate2D]()
    
    let latDifference = endCoordinate.latitude-startCoordinate.latitude
    let longDifference = endCoordinate.longitude-startCoordinate.longitude
    
    for i in 0...coordinatesGenerated-1 {
      let incrementalLat = startCoordinate.latitude+(latDifference/Double(coordinatesGenerated)*Double(i))
      let incrementalLong = startCoordinate.longitude+(longDifference/Double(coordinatesGenerated)*Double(i))
      let interpolatedCoordinate = CLLocationCoordinate2D(latitude: incrementalLat, longitude: incrementalLong)
      print("Lat: \(incrementalLat), Long: \(incrementalLong)")
      coordinates.append(interpolatedCoordinate)
    }
    
    return coordinates
  }
}
