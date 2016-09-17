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
  func tabSelected(index: Int)
}

class MiniTabBar: UIView {

  weak var delegate: MiniTabBarDelegate?

  private var itemViews = [MiniTabBarItemView]()
  private var currentSelectedIndex: Int?

  init(frame: CGRect, items: [MiniTabBarItem]) {
    super.init(frame: frame)

    self.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight)) as UIVisualEffectView
    visualEffectView.frame = self.bounds
    self.addSubview(visualEffectView)

    let keyLine = UIView(frame: CGRectMake(0, 0, self.frame.width, 1))
    keyLine.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
    self.addSubview(keyLine)


    let width = CGFloat(100)
    let spacing = Int((frame.size.width - (CGFloat(items.count) * width)) / CGFloat(items.count + 1))

    var i = 0
    for item in items {
      let x = CGFloat(spacing * (i+1)) + (width * CGFloat(i))
      let container = MiniTabBarItemView(frame: CGRectMake(x, 0, width, frame.size.height))

      let titleLabel = UILabel(frame: CGRectMake(0, container.frame.size.height, container.frame.size.width, 14))
      titleLabel.text = item.title
      titleLabel.font = UIFont.systemFontOfSize(12)
      titleLabel.textColor = UIColor.HZMainColor()
      titleLabel.textAlignment = .Center
      container.addSubview(titleLabel)
      container.titleLabel = titleLabel

      let iconView = UIImageView(frame: CGRectMake(container.frame.size.width / 2 - 13, 12, 26, 20))
      iconView.image = item.icon.imageWithRenderingMode(.AlwaysTemplate)
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

  func itemTapped(gesture: UITapGestureRecognizer) {
    let itemView = gesture.view as! MiniTabBarItemView
    let selectedIndex = self.itemViews.indexOf(itemView)!
    self.selectItem(selectedIndex)
  }

  func selectItem(selectedIndex: Int, animated: Bool = true) {
    if (selectedIndex == self.currentSelectedIndex) {
      return
    }
    self.currentSelectedIndex = selectedIndex

    let itemView = self.itemViews[selectedIndex]
    for (index, v) in self.itemViews.enumerate() {
      v.iconView?.tintColor = (index == selectedIndex) ? UIColor.HZMainColor() : UIColor.HZLightColor()
    }

    if (animated) {
      /*
       ICON
       */
      UIView.animateWithDuration(0.1, delay: 0, options: .CurveEaseIn, animations: {
        itemView.iconView?.frame.origin.y = 5
        }, completion: { finished in
          UIView.animateWithDuration(0.4, delay: 0.5, options: .CurveEaseInOut, animations: {
            itemView.iconView?.frame.origin.y = 12
            }, completion: { finished in
          })
      })


      /*
       TEXT
       */
      UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: {
        itemView.titleLabel?.frame.origin.y = 28
        }, completion: { finished in
          UIView.animateWithDuration(0.2, delay: 0.5, options: .CurveEaseInOut, animations: {
            itemView.titleLabel?.frame.origin.y = self.frame.size.height
            }, completion: { finished in
          })
      })
    }
    
    
    self.delegate?.tabSelected(selectedIndex)
  }
}