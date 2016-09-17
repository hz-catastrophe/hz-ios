//
//  SelectionViewController.swift
//  HZCatastrophe
//
//  Created by Dylan Marriott on 17/09/16.
//  Copyright © 2016 Dylan Marriott. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class SelectionViewController: UIViewController {

  let mode: Int

  private let scrollView = UIScrollView()

  private let titleLabel = UILabel()
  private var locationView: LocationView!
  private let healthSelectionView = UISegmentedControl()
  private var skillsSelection: MultiSelectionView!

  init(mode: Int) {
    self.mode = mode
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.scrollView.frame = self.view.bounds
    self.scrollView.alwaysBounceVertical = true
    self.view.addSubview(self.scrollView)

    let titleWidth = self.view.frame.width - 80
    self.titleLabel.frame = CGRect(x: 40, y: 0, width: titleWidth, height: 0)
    self.titleLabel.font = UIFont.systemFontOfSize(54, weight: UIFontWeightUltraLight)
    self.titleLabel.textColor = UIColor(white: 0.4, alpha: 1.0)
    let string = NSMutableAttributedString(string: (mode == 0 ? "I need help!" : "I can help!"))
    let nsstring = string.string as NSString
    string.addAttribute(NSKernAttributeName, value: 2, range: nsstring.rangeOfString(string.string))
    string.addAttribute(NSForegroundColorAttributeName, value: UIColor.HZMainColor(), range: nsstring.rangeOfString(mode == 0 ? "need" : "can"))
    self.titleLabel.attributedText = string
    self.titleLabel.numberOfLines = 0
    self.titleLabel.lineBreakMode = .ByWordWrapping
    self.titleLabel.sizeToFit()
    self.titleLabel.frame.size.width = titleWidth
    self.titleLabel.frame.size.height = CGFloat(Int(titleLabel.frame.height) + 1)
    self.scrollView.addSubview(self.titleLabel)

    self.locationView = LocationView(frame: CGRect(x: 40, y: 0, width: self.view.frame.width - 80, height: 200))
    self.scrollView.addSubview(self.locationView)

    if mode == 0 {
      self.healthSelectionView.insertSegmentWithTitle("Lightly Injured", atIndex: 0, animated: false)
      self.healthSelectionView.insertSegmentWithTitle("Heavily Injured", atIndex: 1, animated: false)
      self.healthSelectionView.frame = CGRect(x: 40, y: 0, width: self.view.frame.width - 80, height: 50)
      self.healthSelectionView.tintColor = UIColor.HZMainColor()
      self.scrollView.addSubview(self.healthSelectionView)
    }


    self.skillsSelection = MultiSelectionView(items: [MultiSelectionItem(name: "Medic", icon: UIImage(named: "medical")!),
                                                      MultiSelectionItem(name: "Food", icon: UIImage(named: "food")!),
                                                      MultiSelectionItem(name: "Water", icon: UIImage(named: "water")!)])
    self.scrollView.addSubview(self.skillsSelection)


    self.layoutContentView()
  }

  private func layoutContentView() {
    self.titleLabel.frame.origin.y = 42
    self.locationView.frame.origin.y = CGRectGetMaxY(titleLabel.frame) + 20
    self.healthSelectionView.frame.origin.y = CGRectGetMaxY(self.locationView.frame) + 10
    let skillSelectionHeight = self.skillsSelection.sizeThatFits(CGSizeZero).height
    self.skillsSelection.frame = CGRect(x: 40, y: CGRectGetMaxY(self.healthSelectionView.frame) + 10, width: self.view.frame.width - 80, height: skillSelectionHeight)
    self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: CGRectGetMaxY(self.skillsSelection.frame) + 10)
  }

}