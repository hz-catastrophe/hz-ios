//
//  MiniTabBar.swift
//  HZCatastrophe
//
//  Created by Dylan Marriott on 16/09/16.
//  Copyright © 2016 Dylan Marriott. All rights reserved.
//

import Foundation
import UIKit

class MiniTabBarItem {
  var title: String
  var icon: UIImage
  init(title: String, icon:UIImage) {
    self.title = title
    self.icon = icon
  }
}

class MiniTabBarItemView: UIView {
  var titleLabel: UILabel?
  var iconView: UIImageView?
}

protocol MiniTabBarDelegate: class {
  func tabSelected(_ index: Int)
}

class MiniTabBar: UIView {

  weak var delegate: MiniTabBarDelegate?

  fileprivate var itemViews = [MiniTabBarItemView]()
  fileprivate var currentSelectedIndex: Int?

  init(frame: CGRect, items: [MiniTabBarItem]) {
    super.init(frame: frame)

    self.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight)) as UIVisualEffectView
    visualEffectView.frame = self.bounds
    self.addSubview(visualEffectView)

    let keyLine = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 1))
    keyLine.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
    self.addSubview(keyLine)


    let width = CGFloat(100)
    let spacing = Int((frame.size.width - (CGFloat(items.count) * width)) / CGFloat(items.count + 1))

    var i = 0
    for item in items {
      let x = CGFloat(spacing * (i+1)) + (width * CGFloat(i))
      let container = MiniTabBarItemView(frame: CGRect(x: x, y: 0, width: width, height: frame.size.height))

      let titleLabel = UILabel(frame: CGRect(x: 0, y: container.frame.size.height, width: container.frame.size.width, height: 14))
      titleLabel.text = item.title
      titleLabel.font = UIFont.systemFont(ofSize: 12)
      titleLabel.textColor = UIColor.HZMainColor()
      titleLabel.textAlignment = .center
      container.addSubview(titleLabel)
      container.titleLabel = titleLabel

      let iconView = UIImageView(frame: CGRect(x: container.frame.size.width / 2 - 13, y: 12, width: 26, height: 20))
      iconView.image = item.icon.withRenderingMode(.alwaysTemplate)
      container.addSubview(iconView)
      container.iconView = iconView

      container.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MiniTabBar.itemTapped(_:))))

      self.itemViews.append(container)
      self.addSubview(container)
      i += 1
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func itemTapped(_ gesture: UITapGestureRecognizer) {
    let itemView = gesture.view as! MiniTabBarItemView
    let selectedIndex = self.itemViews.index(of: itemView)!
    self.selectItem(selectedIndex)
  }

  func selectItem(_ selectedIndex: Int, animated: Bool = true) {
    if (selectedIndex == self.currentSelectedIndex) {
      return
    }
    self.currentSelectedIndex = selectedIndex

    let itemView = self.itemViews[selectedIndex]
    for (index, v) in self.itemViews.enumerated() {
      v.iconView?.tintColor = (index == selectedIndex) ? UIColor.HZMainColor() : UIColor.HZLightColor()
    }

    if (animated) {
      /*
       ICON
       */
      UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
        itemView.iconView?.frame.origin.y = 5
        }, completion: { finished in
          UIView.animate(withDuration: 0.4, delay: 0.5, options: UIViewAnimationOptions(), animations: {
            itemView.iconView?.frame.origin.y = 12
            }, completion: { finished in
          })
      })


      /*
       TEXT
       */
      UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
        itemView.titleLabel?.frame.origin.y = 28
        }, completion: { finished in
          UIView.animate(withDuration: 0.2, delay: 0.5, options: UIViewAnimationOptions(), animations: {
            itemView.titleLabel?.frame.origin.y = self.frame.size.height
            }, completion: { finished in
          })
      })
    }
    
    
    self.delegate?.tabSelected(selectedIndex)
  }
}
