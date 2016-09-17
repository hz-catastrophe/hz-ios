//
//  ViewController.swift
//  HZCatastrophe
//
//  Created by Dylan Marriott on 16/09/16.
//  Copyright © 2016 Dylan Marriott. All rights reserved.
//

import UIKit
import SocketIOClientSwift

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.


    //let socket = SocketIOClient(socketURL: NSURL(string: "http://hz.wx.rs:8000")!, options: [.Log(true), .ForcePolling(true)])
    let socket = SocketIOClient(socketURL: NSURL(string: "http://hz.wx.rs:8000")!)

    socket.on("connect") {data, ack in
      print("socket connected")
      socket.emit("my event", ["test":1234])

    }


    socket.on("my response") {data, ack in
      print("got response: ", data)
    }
    
    socket.connect()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

