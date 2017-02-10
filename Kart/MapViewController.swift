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
  override func setNeedsDisplayIn(_ mapRect: MKMapRect) {
    print("setNeedsDisplayInMapRect")
    return super.setNeedsDisplayIn(mapRect)
  }
  
  override func mapRect(for rect: CGRect) -> MKMapRect {
    print("mapRectForRect")
    return super.mapRect(for: rect)
  }
  
  override func rect(for mapRect: MKMapRect) -> CGRect {
    print("rectForMapRect")
    return super.rect(for: mapRect)
  }
  
  override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
    super.draw(mapRect, zoomScale: zoomScale, in: context)
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
    findMe.setTitle("Me!", for: UIControlState())
    findMe.setTitleColor(UIColor.black, for: UIControlState())
    findMe.sizeToFit()
    findMe.addTarget(self, action: #selector(MapViewController.buttonPressed), for: .touchUpInside)
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: findMe)
    
    let button = UIButton()
    button.setTitle("Random", for: UIControlState())
    button.setTitleColor(UIColor.black, for: UIControlState())
    button.sizeToFit()
    button.addTarget(self, action: #selector(MapViewController.moveRandomPlayer), for: .touchUpInside)
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    
    mapView.centerCoordinate = CLLocationCoordinate2D(latitude: 37.770780, longitude: -122.433248)
    mapView.setRegion(MKCoordinateRegionMakeWithDistance(mapView.centerCoordinate, 9000, 9000), animated: false)
    
    NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.newUserLocationReceived(_:)), name: NSNotification.Name(rawValue: KartNotificationNewUserLocationReceived), object: nil)
  }
  
  func convertPointToMapView(_ point: MKMapPoint) -> CGPoint {
    return mapView.convert(MKCoordinateForMapPoint(point), toPointTo: mapView)
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
    if (mapView.userTrackingMode == .none) {
      mapView.userTrackingMode = .follow
    } else {
      mapView.userTrackingMode = .none
    }
  }
  
  func moveRandomPlayer() {
    let userLocation = randomUserLocation()
    
    let obj = ["name": userLocation.name, "latitude": userLocation.latitude, "longitude": userLocation.longitude] as [String : Any]
    
//    PubNubManager.sharedInstance.publishMessage(obj, onChannel: "run-channel") { (status) in
      
//    }
  }
  
  func newUserLocationReceived(_ note: Notification) {
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
  
  func animateAnnotation(_ previousAnnotation: UserLocationAnnotation, toAnnotationCoordinate finalAnnotation: UserLocationAnnotation, arrayIndex: Int) {
    if animatingAnnotation {
      print("****** MISSED AN ANIMATION")
      return
    }
    animatingAnnotation = true
    let animationPoint = mapView.convert(finalAnnotation.coordinate, toPointTo: mapView)
    let annotView = mapView.view(for: previousAnnotation)
    
    //If animation time too long, might miss coordinate animations
    UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions(), animations: {
      annotView?.center = animationPoint
      }) { (comp) in
        if arrayIndex >= 0 {
          self.mappedUserAnnotations.remove(at: arrayIndex)
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
  func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
    //TODO: zoom baby
    
  }
  
  func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
    self.mapView.setRegion(mapView.region, animated: true)
  }
  
  func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    self.mapView.setRegion(mapView.region, animated: true)
  }
  
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    return myRenderer
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if let annot = annotation as? UserLocationAnnotation {
      var annotView: MKAnnotationView
      annotView = mapView.dequeueReusableAnnotationView(withIdentifier: annot.userName) ?? UserLocationAnnotationView(annotation: annotation, reuseIdentifier: annot.userName)
      annotView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
      mappedUserAnnotations.append(annot)
      return annotView
    }
    
    return nil
  }
}
