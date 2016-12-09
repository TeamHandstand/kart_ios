//
//  UserLocationAnnotation.swift
//  Kart
//
//  Created by Sam Goldstein on 12/8/16.
//  Copyright © 2016 Sam Goldstein. All rights reserved.
//

import Foundation
import MapKit

class UserLocationAnnotation: NSObject, MKAnnotation {
  dynamic var myCoordinate: CLLocationCoordinate2D
  var userName: String!
  
  var myTitle: String!
  var mySubtitle: String?
  
  init(userLocation: UserLocation) {
    let coordinate = CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude)
    self.myCoordinate = coordinate
    userName = userLocation.name
  }
  
//  init(myCoordinate: CLLocationCoordinate2D, name: String) {
//    self.myCoordinate = myCoordinate
//    userName = name
//  }
  
  internal var coordinate: CLLocationCoordinate2D {
    get {
      return myCoordinate
    }
    set {
      myCoordinate = newValue
    }
  }
  
  internal var title: String? {
    get {
      return myTitle
    }
    set {
      myTitle = newValue
    }
  }
  
  internal var subtitle: String? {
    get {
      return mySubtitle
    }
    set {
      mySubtitle = newValue
    }
  }
}

class UserLocationAnnotationView: MKAnnotationView {
  
  var circleImageView: UIImageView!
  var nameLabel: UILabel!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

    let img = UIImage(named: "user_map_label_icon")
    circleImageView = UIImageView(image: img)
    addSubview(circleImageView)
    
    nameLabel = UILabel()
    nameLabel.textColor = UIColor.blackColor()
    nameLabel.text = "? ?"
    nameLabel.textAlignment = .Center
    nameLabel.font = UIFont.systemFontOfSize(8)
    
    if let annot = annotation as? UserLocationAnnotation {
      let nameArray = annot.userName.capitalizedString.characters.split{$0 == " "}.map(String.init)
      for i in 0...nameArray.count-1 {
        if i == 0 {
          nameLabel.text = "\(nameArray[i].characters.first!)"
        } else {
          nameLabel.text = nameLabel.text! + "\(nameArray[i].characters.first!)"
        }
      }
    }
    addSubview(nameLabel)
  }
  
  override func layoutSubviews() {
    circleImageView.frame = bounds
    nameLabel.frame = bounds
  }
}