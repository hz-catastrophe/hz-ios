//
//  MapViewController.swift
//  HZCatastrophe
//
//  Created by Dylan Marriott on 17/09/16.
//  Copyright © 2016 Dylan Marriott. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SwiftMessages

class MapViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let mapView = MKMapView(frame: self.view.bounds)
    self.view.addSubview(mapView)

    let statusBarUnderlay = UIView()
    statusBarUnderlay.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20)
    statusBarUnderlay.backgroundColor = UIColor.white
    self.view.addSubview(statusBarUnderlay)

    let view = MessageView.viewFromNib(layout: .MessageView)
    view.configureTheme(.info)
    view.configureContent(title: "Help requested", body: "Somebody close by could use your help!", iconImage: nil, iconText: "🆘", buttonImage: nil, buttonTitle: "Open") { (button: UIButton) in

    }
    var config = SwiftMessages.defaultConfig
    config.duration = .seconds(seconds: 4)
    SwiftMessages.show(config: config, view: view)
  }

}
