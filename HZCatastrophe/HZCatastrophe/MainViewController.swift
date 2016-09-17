//
//  MainViewController.swift
//  HZCatastrophe
//
//  Created by Dylan Marriott on 16/09/16.
//  Copyright © 2016 Dylan Marriott. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController, MiniTabBarDelegate {

  fileprivate var vcs = [UIViewController]()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.vcs.append(SelectionViewController(mode: 0))
    self.vcs.append(SelectionViewController(mode: 1))

    for vc in self.vcs {
      self.addChildViewController(vc)
      self.view.addSubview(vc.view)
      vc.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 44)
      vc.didMove(toParentViewController: self)
      vc.view.alpha = 0.0
    }

    var items = [MiniTabBarItem]()
    items.append(MiniTabBarItem(title: "Need Help", icon: UIImage(named: "tab1")!))
    items.append(MiniTabBarItem(title: "Provide Help", icon: UIImage(named: "tab2")!))
    let tabBar = MiniTabBar(frame: CGRect(x: 0, y: self.view.frame.height - 44, width: self.view.frame.width, height: 44), items: items)
    tabBar.delegate = self
    tabBar.selectItem(0, animated: false)
    self.view.addSubview(tabBar)

    SocketManager.sharedManager.setup()
    LocationHelper.sharedHelper.setup()
  }

  func tabSelected(_ index: Int) {
    let other = index == 0 ? 1 : 0
    UIView.animate(withDuration: 0.1, animations: { 
      self.vcs[index].view.alpha = 1.0
      self.vcs[other].view.alpha = 0.0
    }) 
  }
}
