//
//  LocationView.swift
//  HZCatastrophe
//
//  Created by Dylan Marriott on 17/09/16.
//  Copyright © 2016 Dylan Marriott. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class LocationView: UIView {

  fileprivate let previewImageView = UIImageView()
  fileprivate let titleLabel = UILabel()
  fileprivate let marker = UIImageView(image: UIImage(named: "location")?.withRenderingMode(.alwaysTemplate))

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.previewImageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height - 30)
    self.previewImageView.layer.cornerRadius = 8
    self.previewImageView.clipsToBounds = true
    self.previewImageView.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
    self.addSubview(self.previewImageView)

    self.titleLabel.frame = CGRect(x: 0, y: self.frame.height - 30, width: self.frame.width, height: 30)
    self.titleLabel.font = UIFont.systemFont(ofSize: 13)
    self.titleLabel.textColor = UIColor(white: 0.2, alpha: 1.0)
    self.titleLabel.text = "Loading location..."
    self.addSubview(self.titleLabel)

    self.marker.frame.size = CGSize(width: 50, height: 50)
    self.marker.center = self.previewImageView.center
    self.marker.frame.origin.y -= self.marker.frame.size.height / 2
    self.marker.tintColor = UIColor.HZMainColor()
    self.marker.alpha = 0.0
    self.addSubview(self.marker)

    NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "locationChanged"), object: nil, queue: OperationQueue.main) { (notification: Notification) in
      self.reloadView()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  func reloadView() {
    if let currentLocation = LocationHelper.sharedHelper.currentLocation {
      self.titleLabel.text = "Location: \(currentLocation.coordinate.latitude.roundToPlaces(places: 5)) / \(currentLocation.coordinate.longitude.roundToPlaces(places: 5))"
      let options = MKMapSnapshotOptions()
      let region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 400, 400)
      options.region = region
      options.size = previewImageView.frame.size
      options.scale = UIScreen.main.scale
      let mapSnapshot = MKMapSnapshotter(options: options)
      mapSnapshot.start(completionHandler: { (snapshot: MKMapSnapshot?, error: Error?) in
        if let e = error {
          print("Error loading snapshot: ", e)
          return
        }
        self.marker.alpha = 1.0
        self.previewImageView.image = snapshot?.image
      })
    }
  }
}

extension Double {
  /// Rounds the double to decimal places value
  func roundToPlaces(places:Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
  }
}
