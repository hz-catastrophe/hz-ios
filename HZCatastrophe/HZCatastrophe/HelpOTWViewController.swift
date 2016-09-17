//
//  HelpOTWViewController.swift
//  HZCatastrophe
//
//  Created by Dylan Marriott on 17/09/16.
//  Copyright © 2016 Dylan Marriott. All rights reserved.
//

import Foundation
import UIKit

class HelpOTWViewController: UIViewController {

  fileprivate let titleLabel = UILabel()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    let titleWidth = self.view.frame.width - 80
    self.titleLabel.frame = CGRect(x: 40, y: 55, width: titleWidth, height: 0)
    self.titleLabel.font = UIFont.systemFont(ofSize: 54, weight: UIFontWeightUltraLight)
    self.titleLabel.textColor = UIColor(white: 0.4, alpha: 1.0)
    let string = NSMutableAttributedString(string: "Hang tight, help is on the way!")
    let nsstring = string.string as NSString
    string.addAttribute(NSKernAttributeName, value: 2, range: nsstring.range(of: string.string))
    string.addAttribute(NSForegroundColorAttributeName, value: UIColor.HZMainColor(), range: nsstring.range(of: "help"))
    self.titleLabel.attributedText = string
    self.titleLabel.numberOfLines = 0
    self.titleLabel.lineBreakMode = .byWordWrapping
    self.titleLabel.sizeToFit()
    self.titleLabel.frame.size.width = titleWidth
    self.titleLabel.frame.size.height = CGFloat(Int(titleLabel.frame.height) + 1)
    self.view.addSubview(self.titleLabel)

  }
}
