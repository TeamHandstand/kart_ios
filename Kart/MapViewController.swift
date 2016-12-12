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
    
    let findMe = UIButton()
    findMe.setTitle("Me!", forState: .Normal)
    findMe.setTitleColor(UIColor.blackColor(), forState: .Normal)
    findMe.sizeToFit()
    findMe.addTarget(self, action: #selector(MapViewController.buttonPressed), forControlEvents: .TouchUpInside)
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: findMe)
    
    let button = UIButton()
    button.setTitle("Random", forState: .Normal)
    button.setTitleColor(UIColor.blackColor(), forState: .Normal)
    button.sizeToFit()
    button.addTarget(self, action: #selector(MapViewController.moveRandomPlayer), forControlEvents: .TouchUpInside)
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    
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
  func moveRandomPlayer() {
    let userLocation = randomUserLocation()
    
    let obj = ["name": userLocation.name, "latitude": userLocation.latitude, "longitude": userLocation.longitude] as [String : Any]
    
    PubNubManager.sharedInstance.publishMessage(obj, onChannel: "run-channel") { (status) in
      print("here")
    }
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
    var idx = -1
    
    if mappedUserAnnotations.count > 0 {
      for i in 0...mappedUserAnnotations.count-1 {
        if mappedUserAnnotations[i].userName == annotation.userName {
          idx = i
        }
      }
    }
    
    animateAnnotation(idx < 0 ? annotation : mappedUserAnnotations[idx], toAnnotationCoordinate: annotation, arrayIndex: idx)
  }
  
  func animateAnnotation(_ annotation: UserLocationAnnotation, toAnnotationCoordinate finalAnnotation: UserLocationAnnotation, arrayIndex: Int) {
    let animationPoint = mapView.convert(finalAnnotation.coordinate, toPointTo: mapView)
    let annotView = mapView.view(for: annotation)
    
    UIView.animate(withDuration: 0.2, animations: { 
      annotView?.center = animationPoint
      }, completion: { (comp) in
        if arrayIndex >= 0 {
          self.mappedUserAnnotations.remove(at: arrayIndex)
        }
        self.mappedUserAnnotations.append(annotation)
        self.mapView.addAnnotation(annotation)
    }) 
    
//    return annotation
//    
//    var lastAnnotation = annotation
//    for i in 0...coords.count-1 {
//      let coord = coords[i]
//      
//      delay(totalDuration/Double(coords.count)*Double(i), closure: {
//        let userLoc = UserLocation(name: name, latitude: coord.latitude, longitude: coord.longitude)
//        let anno = UserLocationAnnotation(userLocation: userLoc)
//        self.mappedUserAnnotations.removeAtIndex(self.mappedUserAnnotations.indexOf(lastAnnotation)!)
//        self.mapView.removeAnnotation(lastAnnotation)
//        self.mapView.addAnnotation(anno)
//        lastAnnotation = anno
//      })
//    }
//    
//    let lastCoord = coords.last
//    return UserLocationAnnotation(userLocation: UserLocation(name: name, latitude: lastCoord!.latitude, longitude: lastCoord!.longitude))
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
    print(mapView.region)
    
    print("Span")
    print(mapView.region.span)
    
    print("Lat")
    print(mapView.region.span.latitudeDelta)
    
    print("Long")
    print(mapView.region.span.longitudeDelta)
  }
    if let annot = annotation as? UserLocationAnnotation {
      let annotView = UserLocationAnnotationView(annotation: annotation, reuseIdentifier: annot.userName)
      annotView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
      mappedUserAnnotations.append(annot)
      return annotView
    }
    
    return nil
  }
}