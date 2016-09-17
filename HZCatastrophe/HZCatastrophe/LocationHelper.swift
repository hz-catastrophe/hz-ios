//
//  LocationHelper.swift
//  HZCatastrophe
//
//  Created by Dylan Marriott on 17/09/16.
//  Copyright © 2016 Dylan Marriott. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class LocationHelper: NSObject, CLLocationManagerDelegate {

  static let sharedHelper = LocationHelper()
  var currentLocation: CLLocation?
  fileprivate let locationManager = CLLocationManager()

  func setup() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.distanceFilter = 100
    locationManager.requestWhenInUseAuthorization()
  }

  @objc func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedAlways || status == .authorizedWhenInUse {
      manager.startUpdatingLocation()
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    self.currentLocation = locations.last
    NotificationCenter.default.post(name: Notification.Name(rawValue: "locationChanged"), object: nil)
  }
}
