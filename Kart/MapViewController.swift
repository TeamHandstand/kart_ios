//
//  FirstViewController.swift
//  Kart
//
//  Created by Sam Goldstein on 12/8/16.
//  Copyright © 2016 Sam Goldstein. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

  @IBOutlet weak var mapView: MKMapView!
  var mappedUserAnnotations = [UserLocationAnnotation]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    let button = UIButton()
    button.setTitle("Me!", forState: .Normal)
    button.setTitleColor(UIColor.blackColor(), forState: .Normal)
    button.sizeToFit()
    button.addTarget(self, action: #selector(MapViewController.buttonPressed), forControlEvents: .TouchUpInside)
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapViewController.newUserLocationReceived(_:)), name: KartNotificationNewUserLocationReceived, object: nil)
  }
  
  func randomUserLocation() -> UserLocation {
    let names = ["Sam Goldstein", "Josh Zipin", "Gil Levy"]
    let coords = [[37.773085, -122.439120],
                  [37.772135, -122.433970],
                  [37.774680, -122.434828],
                  [37.771661, -122.437918],
                  [37.770032, -122.440107],
                  [37.776206, -122.440536],
                  [37.770134, -122.443969]
    ]
    
    let coord = coords.randomElement
    let name = names.randomElement
    
    return UserLocation(name: name, latitude: coord[0], longitude: coord[1])
  }
  
  func buttonPressed() {
    if (mapView.userTrackingMode == .None) {
      mapView.userTrackingMode = .Follow
    } else {
      mapView.userTrackingMode = .None
    }
    
//    let userLocation = randomUserLocation()
//    
//    let obj = ["name": userLocation.name, "latitude": userLocation.latitude, "longitude": userLocation.longitude]
//    
//    PubNubManager.sharedInstance.publishMessage(obj, onChannel: "run-channel") { (status) in
//      print("here")
//    }
  }
  
  func newUserLocationReceived(note: NSNotification) {
    guard let userDict = note.object as? NSDictionary else {
      return
    }
    
    guard let name = userDict["name"] as? String, let lat = userDict["latitude"] as? NSNumber, let long = userDict["longitude"] as? NSNumber else {
      return
    }
    
    let userLocation = UserLocation(name: name, latitude: lat.doubleValue, longitude: long.doubleValue)
    let annotation = UserLocationAnnotation(userLocation: userLocation)
    
    if mappedUserAnnotations.count > 0 {
      for i in 0...mappedUserAnnotations.count-1 {
        if mappedUserAnnotations[i].userName == annotation.userName {
          mapView.removeAnnotation(mappedUserAnnotations[i])
        }
      }
    }
    
    mappedUserAnnotations.append(annotation)
    mapView.addAnnotation(annotation)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

extension MapViewController: MKMapViewDelegate {
  func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
    //TODO: zoom baby
    
  }
  
  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    if let annot = annotation as? UserLocationAnnotation {
      let annotView = UserLocationAnnotationView(annotation: annotation, reuseIdentifier: annot.userName)
      annotView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
      mappedUserAnnotations.append(annot)
      return annotView
    }
    
    return nil
  }
}