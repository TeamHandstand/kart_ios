//
//  FirstViewController.swift
//  Kart
//
//  Created by Sam Goldstein on 12/8/16.
//  Copyright © 2016 Sam Goldstein. All rights reserved.
//

import UIKit
import MapKit

class  KartOverlayRenderer: MKOverlayRenderer {
  override func setNeedsDisplayInMapRect(mapRect: MKMapRect) {
    print("setNeedsDisplayInMapRect")
    return super.setNeedsDisplayInMapRect(mapRect)
  }
  
  override func mapRectForRect(rect: CGRect) -> MKMapRect {
    print("mapRectForRect")
    return super.mapRectForRect(rect)
  }
  
  override func rectForMapRect(mapRect: MKMapRect) -> CGRect {
    print("rectForMapRect")
    return super.rectForMapRect(mapRect)
  }
  
  override func drawMapRect(mapRect: MKMapRect, zoomScale: MKZoomScale, inContext context: CGContext) {
    super.drawMapRect(mapRect, zoomScale: zoomScale, inContext: context)
    print("drawMapRect")
  }
}

class MapViewController: UIViewController {

  @IBOutlet weak var mapView: MKMapView!
  
  var mappedUserAnnotations = [UserLocationAnnotation]()
  var animatingAnnotation = false
  
  let myRenderer = KartOverlayRenderer()
  
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
    
    mapView.centerCoordinate = CLLocationCoordinate2D(latitude: 37.770780, longitude: -122.433248)
    mapView.setRegion(MKCoordinateRegionMakeWithDistance(mapView.centerCoordinate, 9000, 9000), animated: false)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapViewController.newUserLocationReceived(_:)), name: KartNotificationNewUserLocationReceived, object: nil)
  }
  
  func convertPointToMapView(point: MKMapPoint) -> CGPoint {
    return mapView.convertCoordinate(MKCoordinateForMapPoint(point), toPointToView: mapView)
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
  }
  
  func moveRandomPlayer() {
    let userLocation = randomUserLocation()
    
    let obj = ["name": userLocation.name, "latitude": userLocation.latitude, "longitude": userLocation.longitude]
    
    PubNubManager.sharedInstance.publishMessage(obj, onChannel: "run-channel") { (status) in
      
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
  
  func animateAnnotation(previousAnnotation: UserLocationAnnotation, toAnnotationCoordinate finalAnnotation: UserLocationAnnotation, arrayIndex: Int) {
    if animatingAnnotation {
      print("****** MISSED AN ANIMATION")
      return
    }
    animatingAnnotation = true
    let animationPoint = mapView.convertCoordinate(finalAnnotation.coordinate, toPointToView: mapView)
    let annotView = mapView.viewForAnnotation(previousAnnotation)
    
    //If animation time too long, might miss coordinate animations
    UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: {
      annotView?.center = animationPoint
      }) { (comp) in
        if arrayIndex >= 0 {
          self.mappedUserAnnotations.removeAtIndex(arrayIndex)
          self.mapView.removeAnnotation(previousAnnotation)
        }
        
        self.mappedUserAnnotations.append(finalAnnotation)
        self.mapView.addAnnotation(finalAnnotation)
        self.animatingAnnotation = false
    }
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
  
  func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
    self.mapView.setRegion(mapView.region, animated: true)
  }
  
  func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    self.mapView.setRegion(mapView.region, animated: true)
  }
  
  func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
    return myRenderer
  }
  
  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    if let annot = annotation as? UserLocationAnnotation {
      var annotView: MKAnnotationView
      annotView = mapView.dequeueReusableAnnotationViewWithIdentifier(annot.userName) ?? UserLocationAnnotationView(annotation: annotation, reuseIdentifier: annot.userName)
      annotView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
      mappedUserAnnotations.append(annot)
      return annotView
    }
    
    return nil
  }
}