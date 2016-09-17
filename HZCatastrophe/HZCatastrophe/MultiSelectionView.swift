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

  private let titleLabel = UILabel()
  private let imageView = UIImageView()

  init(item: MultiSelectionItem) {
    super.init(frame: CGRectZero)
    self.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
    self.layer.cornerRadius = 6
    self.titleLabel.text = item.name
    self.titleLabel.font = UIFont.systemFontOfSize(14)
    self.titleLabel.textColor = UIColor(white: 0.2, alpha: 1.0)
    self.addSubview(self.titleLabel)
    self.imageView.image = item.icon.imageWithRenderingMode(.AlwaysTemplate)
    self.imageView.tintColor = UIColor(white: 0.4, alpha: 1.0)
    self.addSubview(self.imageView)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    self.titleLabel.frame = CGRect(x: 56, y: 0, width: self.frame.width - 20, height: self.frame.height)
    self.imageView.frame = CGRect(x: 20, y: 15, width: 20, height: 20)
  }
}

class MultiSelectionView: UIView {

  private var itemViews = [MultiSelectionItemView]()

  init(items: [MultiSelectionItem]) {
    super.init(frame: CGRectZero)
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
    for (idx, itemView) in self.itemViews.enumerate() {
      itemView.frame = CGRect(x: 0, y: CGFloat(idx) * (itemHeight + 8), width: self.frame.width, height: itemHeight)
      itemView.layoutSubviews()
    }
  }

  override func sizeThatFits(size: CGSize) -> CGSize {
    return CGSize(width: size.width, height: CGRectGetMaxY(self.itemViews.last!.frame))
  }
}