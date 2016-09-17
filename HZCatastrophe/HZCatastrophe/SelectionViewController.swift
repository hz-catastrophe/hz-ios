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

class SelectionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  let mode: Int

  private let scrollView = UIScrollView()
  private var photos = [UIImage]()

  private let titleLabel = UILabel()
  private var locationView: LocationView!
  private let healthSelectionView = UISegmentedControl()
  private let skillsLabel = UILabel()
  private var skillsSelection: MultiSelectionView!
  private let photoButton = UIView()
  private let saveButton = UIButton(type: .Custom)

  init(mode: Int) {
    self.mode = mode
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

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

    self.skillsLabel.frame = CGRect(x: 40, y: 0, width: self.view.frame.width - 80, height: 20)
    self.skillsLabel.text = mode == 0 ? "I need:" : "I can provide:"
    self.skillsLabel.font = UIFont.systemFontOfSize(13)
    self.skillsLabel.textColor = UIColor(white: 0.2, alpha: 1.0)
    self.scrollView.addSubview(self.skillsLabel)

    self.skillsSelection = MultiSelectionView(items: [MultiSelectionItem(name: "Medic", icon: UIImage(named: "medical")!),
                                                      MultiSelectionItem(name: "Food", icon: UIImage(named: "food")!),
                                                      MultiSelectionItem(name: "Water", icon: UIImage(named: "water")!)])
    self.scrollView.addSubview(self.skillsSelection)


    self.photoButton.frame = CGRect(x: 40, y: 0, width: self.view.frame.width - 80, height: 100)
    self.photoButton.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
    self.photoButton.layer.cornerRadius = 8
    self.photoButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SelectionViewController.snapPhotos)))
    self.scrollView.addSubview(self.photoButton)

    let icon = UIImageView(image: UIImage(named: "camera")?.imageWithRenderingMode(.AlwaysTemplate))
    icon.tintColor = UIColor(white: 0.4, alpha: 1.0)
    icon.frame = CGRect(x: self.photoButton.frame.width / 2 - 17, y: 21, width: 34, height: 34)
    self.photoButton.addSubview(icon)

    let captureLabel = UILabel()
    captureLabel.text = "Snap some photos"
    captureLabel.font = UIFont.systemFontOfSize(12)
    captureLabel.textColor = UIColor(white: 0.4, alpha: 1.0)
    captureLabel.textAlignment = .Center
    captureLabel.frame = CGRect(x: 0, y: CGRectGetMaxY(icon.frame) + 5, width: self.photoButton.frame.width, height: 16)
    self.photoButton.addSubview(captureLabel)
    

    self.saveButton.frame = CGRect(x: 40, y: 0, width: self.view.frame.width - 80, height: 50)
    self.saveButton.backgroundColor = UIColor.HZMainColor()
    self.saveButton.setTitle(mode == 0 ? "Request Help" : "Provide Help", forState: .Normal)
    self.saveButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    self.saveButton.titleLabel!.font = UIFont.systemFontOfSize(14, weight: UIFontWeightBold)
    self.saveButton.layer.cornerRadius = 8
    self.scrollView.addSubview(self.saveButton)
  }

  override func didMoveToParentViewController(parent: UIViewController?) {
    super.didMoveToParentViewController(parent)
    self.scrollView.frame = self.view.bounds
    self.layoutContentView()
  }

  private func layoutContentView() {
    self.titleLabel.frame.origin.y = 42
    self.locationView.frame.origin.y = CGRectGetMaxY(titleLabel.frame) + 20
    self.healthSelectionView.frame.origin.y = CGRectGetMaxY(self.locationView.frame) + 15
    self.skillsLabel.frame.origin.y = CGRectGetMaxY(self.healthSelectionView.frame) + (self.healthSelectionView.frame.size.height > 0 ? 19 : 0)
    let skillSelectionHeight = self.skillsSelection.sizeThatFits(CGSizeZero).height
    self.skillsSelection.frame = CGRect(x: 40, y: CGRectGetMaxY(self.skillsLabel.frame) + 10, width: self.view.frame.width - 80, height: skillSelectionHeight)

    var y = CGRectGetMaxY(self.skillsSelection.frame)
    if photos.isEmpty {
      self.photoButton.frame.origin.y = y + 26
      y = CGRectGetMaxY(self.photoButton.frame)
    }

    self.saveButton.frame.origin.y = y + 20

    self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: CGRectGetMaxY(self.saveButton.frame) + 20)
  }

  func snapPhotos() {
    let vc = UIImagePickerController()
    vc.allowsEditing = false
    vc.delegate = self
    vc.sourceType = .PhotoLibrary
    //vc.cameraDevice = .Rear
    self.presentViewController(vc, animated: true, completion: nil)
  }

  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    picker.dismissViewControllerAnimated(true) {

    }
  }
}