//
//  MultiSelectionView.swift
//  HZCatastrophe
//
//  Created by Dylan Marriott on 17/09/16.
//  Copyright © 2016 Dylan Marriott. All rights reserved.
//

import Foundation
import UIKit

class MultiSelectionItem {
  let name: String
  let icon: UIImage
  init(name: String, icon: UIImage) {
    self.name = name
    self.icon = icon
  }
}

class MultiSelectionItemView: UIView {

  let item: MultiSelectionItem
  fileprivate var _🔥 = false
  fileprivate let titleLabel = UILabel()
  fileprivate let imageView = UIImageView()

  init(item: MultiSelectionItem) {
    self.item = item
    super.init(frame: CGRect.zero)
    self.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
    self.layer.cornerRadius = 6
    self.titleLabel.text = item.name
    self.titleLabel.font = UIFont.systemFont(ofSize: 14)
    self.titleLabel.textColor = UIColor(white: 0.2, alpha: 1.0)
    self.addSubview(self.titleLabel)
    self.imageView.image = item.icon.withRenderingMode(.alwaysTemplate)
    self.imageView.tintColor = UIColor(white: 0.4, alpha: 1.0)
    self.addSubview(self.imageView)

    self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MultiSelectionItemView._👊)))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    self.titleLabel.frame = CGRect(x: 56, y: 0, width: self.frame.width - 20, height: self.frame.height)
    self.imageView.frame = CGRect(x: 20, y: 15, width: 20, height: 20)
  }

  func _👊() {
    _🔥 = !_🔥
    self.backgroundColor = _🔥 ? UIColor.HZMainColor() : UIColor(white: 0.95, alpha: 1.0)
    self.titleLabel.textColor = _🔥 ? UIColor.white : UIColor(white: 0.2, alpha: 1.0)
    self.imageView.tintColor = _🔥 ? UIColor.white : UIColor(white: 0.4, alpha: 1.0)
  }
}

class MultiSelectionView: UIView {

  fileprivate var itemViews = [MultiSelectionItemView]()

  init(items: [MultiSelectionItem]) {
    super.init(frame: CGRect.zero)
    for item in items { self.itemViews.append(MultiSelectionItemView(item: item)) }
    for itemView in self.itemViews { self.addSubview(itemView) }
    self.clipsToBounds = true
    self.layoutSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    let itemHeight: CGFloat = 50
    for (idx, itemView) in self.itemViews.enumerated() {
      itemView.frame = CGRect(x: 0, y: CGFloat(idx) * (itemHeight + 6), width: self.frame.width, height: itemHeight)
      itemView.layoutSubviews()
    }
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    return CGSize(width: size.width, height: self.itemViews.last!.frame.maxY)
  }

  func selectedItems() -> [String] {
    return self.itemViews.filter { return $0._🔥 }.map { return $0.item.name }
  }
}
