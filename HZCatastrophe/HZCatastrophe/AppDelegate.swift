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


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    self.window?.backgroundColor = UIColor.whiteColor()
    self.window?.makeKeyAndVisible()
    self.window?.rootViewController = MainViewController()

    return true
  }

}

