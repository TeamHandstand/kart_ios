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
  
  @IBOutlet weak var xLabel: UILabel!
  @IBOutlet weak var yLabel: UILabel!
  @IBOutlet weak var zLabel: UILabel!
  
  @IBOutlet weak var arrowImage: UIImageView!
  override func viewDidLoad() {
    super.viewDidLoad()
    let tapper = UITapGestureRecognizer(target: self, action: #selector(SecondViewController.tapperTapped))
    view.addGestureRecognizer(tapper)
    
    firstNameTextField.text = UserDefaults.standard.string(forKey: KartUserDefaultsFirstName)
    lastNameTextField.text = UserDefaults.standard.string(forKey: KartUserDefaultsLastName)
    
    KartMotionManager.sharedInstance.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
      self.xLabel.text = "X: \(data?.acceleration.x)" // == 0 when flat camera down
      self.yLabel.text = "Y: \(data?.acceleration.y)" // == 0 when flat camera down
      self.zLabel.text = "Z: \(data?.acceleration.z)" // == -1 when flat camera down
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.addObserver(self, selector: #selector(SecondViewController.newLocationReceived), name: NSNotification.Name(rawValue: KartNotificationNewUserLocationGenerated), object: nil)
  }
  
  func tapperTapped() {
    UserDefaults.standard.set(firstNameTextField.text, forKey: KartUserDefaultsFirstName)
    UserDefaults.standard.set(lastNameTextField.text, forKey: KartUserDefaultsLastName)
    view.endEditing(false)
  }
  
  @IBAction func switchChanged(_ sender: AnyObject) {
    if trackingSwitch.isOn {
      KartLocationManager.sharedInstance.startUpdatingLocation()
      trackingLabel.text = "Tracking Location"
    } else {
      KartLocationManager.sharedInstance.stopUpdatingLocation()
      trackingLabel.text = "Not Tracking"
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    NotificationCenter.default.removeObserver(self)
    
    UserDefaults.standard.set(firstNameTextField.text, forKey: KartUserDefaultsFirstName)
    UserDefaults.standard.set(lastNameTextField.text, forKey: KartUserDefaultsLastName)
  }
  
  func newLocationReceived() {
    haloAnimateWithColor(UIColor.blue, pulses: 1, duration: 0.5)
  }
  
  func haloAnimateWithColor(_ color: UIColor, pulses: Int, duration: Double) {
    let nextPulses = pulses-1;
    
    let haloView = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 15, height: 15)))
    haloView.center = CGPoint(x: trackingSwitch.center.x , y: arrowImage.center.y)
    haloView.layer.cornerRadius = haloView.frame.size.height/2.0;
    haloView.layer.masksToBounds = true
    haloView.layer.borderWidth = 0.5
    haloView.layer.borderColor = color.cgColor
    haloView.backgroundColor = color.withAlphaComponent(0.6)
    view.addSubview(haloView)
    
    UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: { 
      haloView.alpha = 0
      haloView.transform = CGAffineTransform(scaleX: 3, y: 3);
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
