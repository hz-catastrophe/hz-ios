//
//  SocketManager.swift
//  HZCatastrophe
//
//  Created by Dylan Marriott on 17/09/16.
//  Copyright © 2016 Dylan Marriott. All rights reserved.
//

import Foundation
import SocketIO
import CoreLocation

class SocketManager {

  let sharedManager = SocketManager()
  var socket: SocketIOClient!

  func setup() {
    self.socket = SocketIOClient(socketURL: URL(string: "http://hz.wx.rs:8000")!)
    self.socket.on("connect") {data, ack in
      print("socket connected")
      self.socket.emit("reports reset", [])
    }
    self.socket.connect()
  }

  func add(status: String, location: CLLocation, needs: String?, needs_status: String?, skills: String?, _images: [UIImage]?) {
    let images = _images ?? []

    self.socket.emit("reports add", ["name":"Max Muster",
                                      "source":"ios",
                                      "number":"",
                                      "status":status,
                                      "location":location.coordinatesAsDictionary(),
                                      "needs":needs ?? "",
                                      "needs_status":needs_status ?? "",
                                      "skills":skills,
                                      "photos":images.map({(i: UIImage) -> String in return i.base64() })
                                      ])
  }
}

extension CLLocation {
  func coordinatesAsDictionary() -> [String:Double] {
    return ["lat":self.coordinate.latitude, "lng":self.coordinate.longitude]
  }
}

extension UIImage {
  func base64() -> String {
    return UIImageJPEGRepresentation(self, 0.8)!.base64EncodedString(options: .lineLength64Characters)
  }
}
