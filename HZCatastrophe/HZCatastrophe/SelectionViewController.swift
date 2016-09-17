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

  fileprivate let scrollView = UIScrollView()
  fileprivate var photos = [UIImage]()

  fileprivate let titleLabel = UILabel()
  fileprivate var locationView: LocationView!
  fileprivate let healthSelectionView = UISegmentedControl()
  fileprivate let skillsLabel = UILabel()
  fileprivate var skillsSelection: MultiSelectionView!
  fileprivate let photoButton = UIView()
  fileprivate let photoPreview = UIImageView()
  fileprivate let saveButton = UIButton(type: .custom)

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
    self.titleLabel.font = UIFont.systemFont(ofSize: 54, weight: UIFontWeightUltraLight)
    self.titleLabel.textColor = UIColor(white: 0.4, alpha: 1.0)
    let string = NSMutableAttributedString(string: (mode == 0 ? "I need help!" : "I can help!"))
    let nsstring = string.string as NSString
    string.addAttribute(NSKernAttributeName, value: 2, range: nsstring.range(of: string.string))
    string.addAttribute(NSForegroundColorAttributeName, value: UIColor.HZMainColor(), range: nsstring.range(of: mode == 0 ? "need" : "can"))
    self.titleLabel.attributedText = string
    self.titleLabel.numberOfLines = 0
    self.titleLabel.lineBreakMode = .byWordWrapping
    self.titleLabel.sizeToFit()
    self.titleLabel.frame.size.width = titleWidth
    self.titleLabel.frame.size.height = CGFloat(Int(titleLabel.frame.height) + 1)
    self.scrollView.addSubview(self.titleLabel)

    self.locationView = LocationView(frame: CGRect(x: 40, y: 0, width: self.view.frame.width - 80, height: 200))
    self.scrollView.addSubview(self.locationView)

    if mode == 0 {
      self.healthSelectionView.insertSegment(withTitle: "Lightly Injured", at: 0, animated: false)
      self.healthSelectionView.insertSegment(withTitle: "Heavily Injured", at: 1, animated: false)
      self.healthSelectionView.frame = CGRect(x: 40, y: 0, width: self.view.frame.width - 80, height: 50)
      self.healthSelectionView.tintColor = UIColor.HZMainColor()
      self.scrollView.addSubview(self.healthSelectionView)
    }

    self.skillsLabel.frame = CGRect(x: 40, y: 0, width: self.view.frame.width - 80, height: 20)
    self.skillsLabel.text = mode == 0 ? "I need:" : "I can provide:"
    self.skillsLabel.font = UIFont.systemFont(ofSize: 13)
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

    let icon = UIImageView(image: UIImage(named: "camera")?.withRenderingMode(.alwaysTemplate))
    icon.tintColor = UIColor(white: 0.4, alpha: 1.0)
    icon.frame = CGRect(x: self.photoButton.frame.width / 2 - 17, y: 21, width: 34, height: 34)
    self.photoButton.addSubview(icon)

    let captureLabel = UILabel()
    captureLabel.text = "Snap a photo"
    captureLabel.font = UIFont.systemFont(ofSize: 12)
    captureLabel.textColor = UIColor(white: 0.4, alpha: 1.0)
    captureLabel.textAlignment = .center
    captureLabel.frame = CGRect(x: 0, y: icon.frame.maxY + 5, width: self.photoButton.frame.width, height: 16)
    self.photoButton.addSubview(captureLabel)
    

    self.photoPreview.frame = CGRect(x: 40, y: 0, width: self.view.frame.width - 80, height: 0)
    self.photoPreview.layer.cornerRadius = 8
    self.photoPreview.clipsToBounds = true
    self.scrollView.addSubview(self.photoPreview)

    self.saveButton.frame = CGRect(x: 40, y: 0, width: self.view.frame.width - 80, height: 50)
    self.saveButton.backgroundColor = UIColor.HZMainColor()
    self.saveButton.setTitle(mode == 0 ? "Request Help" : "Provide Help", for: UIControlState())
    self.saveButton.setTitleColor(UIColor.white, for: UIControlState())
    self.saveButton.titleLabel!.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightBold)
    self.saveButton.layer.cornerRadius = 8
    self.saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
    self.scrollView.addSubview(self.saveButton)


    let statusBarUnderlay = UIView()
    statusBarUnderlay.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20)
    statusBarUnderlay.backgroundColor = UIColor.white
    self.view.addSubview(statusBarUnderlay)
  }

  override func didMove(toParentViewController parent: UIViewController?) {
    super.didMove(toParentViewController: parent)
    self.scrollView.frame = self.view.bounds
    self.layoutContentView()
  }

  fileprivate func layoutContentView() {
    self.titleLabel.frame.origin.y = 55
    self.locationView.frame.origin.y = titleLabel.frame.maxY + 36
    self.healthSelectionView.frame.origin.y = self.locationView.frame.maxY + 15
    self.skillsLabel.frame.origin.y = self.healthSelectionView.frame.maxY + (self.healthSelectionView.frame.size.height > 0 ? 19 : 0)
    let skillSelectionHeight = self.skillsSelection.sizeThatFits(CGSize.zero).height
    self.skillsSelection.frame = CGRect(x: 40, y: self.skillsLabel.frame.maxY + 10, width: self.view.frame.width - 80, height: skillSelectionHeight)

    self.photoButton.isHidden = !photos.isEmpty
    self.photoPreview.isHidden = photos.isEmpty
    var y = self.skillsSelection.frame.maxY
    if photos.isEmpty {
      self.photoButton.frame.origin.y = y + 26
      y = self.photoButton.frame.maxY
    } else {
      self.photoPreview.frame.origin.y = y + 26
      self.photoPreview.frame.size.height = self.photoPreview.frame.size.width / self.photoPreview.image!.size.width * self.photoPreview.image!.size.height
      y = self.photoPreview.frame.maxY
    }

    self.saveButton.frame.origin.y = y + 20

    self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.saveButton.frame.maxY + 20)
  }

  func snapPhotos() {
    let vc = UIImagePickerController()
    vc.allowsEditing = false
    vc.delegate = self
    vc.sourceType = .camera
    vc.cameraDevice = .rear
    self.present(vc, animated: true, completion: nil)
  }

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    picker.dismiss(animated: true) {
      self.performSelector(inBackground: #selector(self.processImage(_:)), with: image)
    }
  }

  func processImage(_ img: UIImage) {
    let new = UIImage(cgImage: img.cgImage!, scale: img.size.height / 320, orientation: img.imageOrientation)
    self.performSelector(onMainThread: #selector(self.finishedProcessingImage(_:)), with: new, waitUntilDone: false)
  }

  func finishedProcessingImage(_ img: UIImage) {
    self.photos = [img]
    self.photoPreview.image = img
    self.layoutContentView()
    self.perform(#selector(scrollToBottom), with: nil, afterDelay: 0.5)
  }

  func scrollToBottom() {
    assert(Thread.isMainThread)
    if self.scrollView.contentSize.height <= self.scrollView.bounds.height {
      return
    }
    self.scrollView.setContentOffset(CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.height), animated: true)
  }

  func save() {
    
    self.replaceView()
  }

  private func replaceView() {
    self.scrollView.isHidden = true
    if mode == 0 {
      let vc = HelpOTWViewController()
      self.view.addSubview(vc.view)
    } else {
      let vc = MapViewController()
      self.view.addSubview(vc.view)
    }
  }
}
