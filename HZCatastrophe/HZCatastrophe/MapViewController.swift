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
import LKAlertController

class MapViewController: UIViewController, MKMapViewDelegate {

  var skills = [String]()
  private var items: [[String:Any]] = []
  private var mv: MKMapView!

  override func viewDidLoad() {
    super.viewDidLoad()

    self.mv = MKMapView(frame: self.view.bounds)
    self.mv.region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(47.389844, 8.515625), 1200, 1200)
    self.mv.showsUserLocation = true
    self.mv.delegate = self
    self.view.addSubview(self.mv)


    /*
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
     */

    let alert = Alert(title: "Loading, please wait...")
    alert.show()
    SocketManager.sharedManager.list { (response: [[String:AnyObject]]) -> (Void) in
      alert.getAlertController().dismiss(animated: true, completion: {
        self.performSelector(onMainThread: #selector(self.updateMap(items:)), with: response, waitUntilDone: true)
        //self.mapView.showAnnotations(self.mapView.annotations, animated: true)
      })
    }
  }

  func updateMap(items: [[String:Any]]) {
    let filtered = items.filter {
      for skill in self.skills {
        if ($0["needs"] as! [String]).contains(skill.lowercased()) {
          return true
        }
      }
      return false
    }
    var its = [CustomAnnotation]()
    for item in filtered {
      let location = item["location"] as! [String:Double]
      let pin = CustomAnnotation(coordinate: CLLocationCoordinate2DMake(location["lat"]!, location["lng"]!), title: item["name"] as? String, subtitle: nil)
      pin.item = item as! [String:AnyObject]
      its.append(pin)
    }
    self.mv.addAnnotations(its)
  }


  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    let p = MKPointAnnotation()
    p.coordinate = CLLocationCoordinate2DMake(47, 8)
    self.mv.addAnnotation(p)
  }

  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if (annotation.isKind(of: MKUserLocation.self)) {
      return nil
    }

    let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "loc")
    view.canShowCallout = true
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named:"d")?.withRenderingMode(.alwaysTemplate), for: .normal)
    button.tintColor = UIColor(white: 0.2, alpha: 1.0)
    button.frame = CGRect(x: 0, y: 0, width: 26, height: 26)
    view.rightCalloutAccessoryView = button
    return view
  }

  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    let a = view.annotation as! CustomAnnotation
    Alert(title: "Help Requested", message: "\(a.item["name"] as! String) needs your help.").addAction("Cancel", style: .cancel, handler: nil).addAction("On my way", style: .default, preferredAction: true) { (action: UIAlertAction!) in
      SocketManager.sharedManager.accept(id: a.item["id"] as! NSNumber) {
        Alert(title: "Awesome!", message: "Please update your status when you arrive.").showOkay()
      }
    }.show()
  }
}

class CustomAnnotation: NSObject, MKAnnotation {
  var coordinate: CLLocationCoordinate2D
  var title: String?
  var subtitle: String?
  var item: [String:AnyObject]!
  init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
    self.coordinate = coordinate
    self.title = title
    self.subtitle = subtitle
    super.init()
  }
}
