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

  private let previewImageView = UIImageView()
  private let titleLabel = UILabel()
  private let marker = UIImageView(image: UIImage(named: "location")?.imageWithRenderingMode(.AlwaysTemplate))

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.previewImageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height - 30)
    self.previewImageView.layer.cornerRadius = 8
    self.previewImageView.clipsToBounds = true
    self.previewImageView.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
    self.addSubview(self.previewImageView)

    self.titleLabel.frame = CGRect(x: 0, y: self.frame.height - 30, width: self.frame.width, height: 30)
    self.titleLabel.font = UIFont.systemFontOfSize(13)
    self.titleLabel.textColor = UIColor(white: 0.2, alpha: 1.0)
    self.titleLabel.text = "Loading location..."
    self.addSubview(self.titleLabel)

    self.marker.frame.size = CGSize(width: 50, height: 50)
    self.marker.center = self.previewImageView.center
    self.marker.frame.origin.y -= self.marker.frame.size.height / 2
    self.marker.tintColor = UIColor.HZMainColor()
    self.marker.alpha = 0.0
    self.addSubview(self.marker)

    NSNotificationCenter.defaultCenter().addObserverForName("locationChanged", object: nil, queue: NSOperationQueue.mainQueue()) { (notification: NSNotification) in
      self.reloadView()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }

  func reloadView() {
    if let currentLocation = LocationHelper.sharedHelper.currentLocation {
      self.titleLabel.text = "Location: \(currentLocation.coordinate.latitude) / \(currentLocation.coordinate.longitude)"
      let options = MKMapSnapshotOptions()
      let region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 400, 400)
      options.region = region
      options.size = previewImageView.frame.size
      options.scale = UIScreen.mainScreen().scale
      let mapSnapshot = MKMapSnapshotter(options: options)
      mapSnapshot.startWithCompletionHandler({ (snapshot: MKMapSnapshot?, error: NSError?) in
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