//
//  AppDelegate.swift
//  HZCatastrophe
//
//  Created by Dylan Marriott on 16/09/16.
//  Copyright © 2016 Dylan Marriott. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.backgroundColor = UIColor.white
    self.window?.makeKeyAndVisible()
    self.window?.rootViewController = MainViewController()

    return true
  }

}

