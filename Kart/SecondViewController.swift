//
//  SecondViewController.swift
//  Kart
//
//  Created by Sam Goldstein on 12/8/16.
//  Copyright © 2016 Sam Goldstein. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  
  @IBOutlet weak var trackingSwitch: UISwitch!
  @IBOutlet weak var trackingLabel: UILabel!
  
  @IBOutlet weak var arrowImage: UIImageView!
  override func viewDidLoad() {
    super.viewDidLoad()
    let tapper = UITapGestureRecognizer(target: self, action: #selector(SecondViewController.tapperTapped))
    view.addGestureRecognizer(tapper)
    
    firstNameTextField.text = NSUserDefaults.standardUserDefaults().stringForKey(KartUserDefaultsFirstName)
    lastNameTextField.text = NSUserDefaults.standardUserDefaults().stringForKey(KartUserDefaultsLastName)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SecondViewController.newLocationReceived), name: KartNotificationNewUserLocationGenerated, object: nil)
  }
  
  func tapperTapped() {
    NSUserDefaults.standardUserDefaults().setObject(firstNameTextField.text, forKey: KartUserDefaultsFirstName)
    NSUserDefaults.standardUserDefaults().setObject(lastNameTextField.text, forKey: KartUserDefaultsLastName)
    view.endEditing(false)
  }
  
  @IBAction func switchChanged(sender: AnyObject) {
    if trackingSwitch.on {
      KartLocationManager.sharedInstance.startUpdatingLocation()
      trackingLabel.text = "Tracking Location"
    } else {
      KartLocationManager.sharedInstance.stopUpdatingLocation()
      trackingLabel.text = "Not Tracking"
    }
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    NSNotificationCenter.defaultCenter().removeObserver(self)
    
    NSUserDefaults.standardUserDefaults().setObject(firstNameTextField.text, forKey: KartUserDefaultsFirstName)
    NSUserDefaults.standardUserDefaults().setObject(lastNameTextField.text, forKey: KartUserDefaultsLastName)
  }
  
  func newLocationReceived() {
    haloAnimateWithColor(UIColor.blueColor(), pulses: 1, duration: 0.5)
  }
  
  func haloAnimateWithColor(color: UIColor, pulses: Int, duration: Double) {
    let nextPulses = pulses-1;
    
    let haloView = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 15, height: 15)))
    haloView.center = CGPoint(x: trackingSwitch.center.x , y: arrowImage.center.y)
    haloView.layer.cornerRadius = haloView.frame.size.height/2.0;
    haloView.layer.masksToBounds = true
    haloView.layer.borderWidth = 0.5
    haloView.layer.borderColor = color.CGColor
    haloView.backgroundColor = color.colorWithAlphaComponent(0.6)
    view.addSubview(haloView)
    
    UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { 
      haloView.alpha = 0
      haloView.transform = CGAffineTransformMakeScale(3, 3);
      }) { (comp) in
        haloView.removeFromSuperview()
        if nextPulses > 0 {
          self.haloAnimateWithColor(color, pulses: nextPulses, duration: duration)
        }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}