//
//  Theme.swift
//  Pet Finder
//
//  Created by lianzhandong on 2018/5/2.
//  Copyright © 2018年 Ray Wenderlich. All rights reserved.
//

import UIKit
enum Theme: Int {
  case `default`, dark, graphical
  private enum Keys {
    static let selectedTheme = "SelectedTheme"
  }
  static var current: Theme {
    let stortedTheme = UserDefaults.standard.integer(forKey: Keys.selectedTheme)
    return Theme(rawValue: stortedTheme) ?? .default
  }
  
  var mainColor: UIColor {
    switch self {
    case .default:
      return UIColor(red: 87.0/255.0, green: 188.0/255.0, blue: 95.0/255.0, alpha: 1.0)
    case .dark:
      return UIColor(red: 255.0/255.0, green: 115.0/255.0, blue: 50.0/255.0, alpha: 1.0)
    case .graphical:
      return UIColor(red: 10.0/255.0, green: 10.0/255.0, blue: 10.0/255.0, alpha: 1.0)
    }
  }
  var barStyle: UIBarStyle {
    switch self {
    case .default, .graphical:
      return .default
    case .dark:
      return .black
    }
  }
  var navigationBackgroundImage: UIImage? {
    return self == .graphical ? UIImage(named: "navBackground") : nil
  }
  var tabBarBackgroundImage: UIImage? {
    return self == .graphical ? UIImage(named: "tabBarBackground") : nil
  }
  
  var backgroundColor: UIColor {
    switch self {
    case .default, .graphical:
      return UIColor.white
    case .dark:
      return UIColor(white: 0.4, alpha: 1.0)
    }
  }
  var textColor: UIColor {
    switch self {
    case .default, .graphical:
      return UIColor.black
    case .dark:
      return UIColor.white
    }
  }
  
  func apply() {
    UserDefaults.standard.set(rawValue, forKey: Keys.selectedTheme)
    UserDefaults.standard.synchronize()
    UIApplication.shared.delegate?.window??.tintColor = mainColor
    
    let bar = UINavigationBar.appearance()
    bar.barStyle = barStyle
    bar.setBackgroundImage(navigationBackgroundImage, for: .default)
    bar.backIndicatorImage = UIImage(named: "backArrow")
    bar.backIndicatorTransitionMaskImage = UIImage(named: "backArrow")
    
    let tabBar = UITabBar.appearance()
    tabBar.barStyle = barStyle
    tabBar.backgroundImage = tabBarBackgroundImage
    
    let tabIndicator = UIImage(named: "tabBarSelectionIndicator")?.withRenderingMode(.alwaysTemplate)
    let tabResizableIndicator = tabIndicator?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 2.0, bottom: 0, right: 2.0))
    tabBar.selectionIndicatorImage = tabResizableIndicator
    
    
    let controlBackground = UIImage(named: "controlBackground")?.withRenderingMode(.alwaysTemplate).resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
    let controlSelectedBackground = UIImage(named: "controlSelectedBackground")?.withRenderingMode(.alwaysTemplate).resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
    let segment = UISegmentedControl.appearance()
    segment.setBackgroundImage(controlBackground, for: .normal, barMetrics: .default)
    segment.setBackgroundImage(controlSelectedBackground, for: .selected, barMetrics: .default)
    
    let stepper = UIStepper.appearance()
    stepper.setBackgroundImage(controlBackground, for: .normal)
    stepper.setBackgroundImage(controlBackground, for: .disabled)
    stepper.setBackgroundImage(controlBackground, for: .highlighted)
    stepper.setDecrementImage(UIImage(named: "fewerPaws"), for: .normal)
    stepper.setIncrementImage(UIImage(named: "morePaws"), for: .normal)
    
    let slider = UISlider.appearance()
    slider.setThumbImage(UIImage(named: "sliderThumb"), for: .normal)
    slider.setMaximumTrackImage(UIImage(named: "maximumTrack")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6)), for: .normal)
    slider.setMinimumTrackImage(UIImage(named: "minimumTrack")?.withRenderingMode(.alwaysTemplate).resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)), for: .normal)
    
    let onoff = UISwitch.appearance()
    onoff.onTintColor = mainColor.withAlphaComponent(0.3)
    onoff.thumbTintColor = mainColor
    
    let cell = UITableViewCell.appearance()
    cell.backgroundColor = backgroundColor
    let lbl = UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self])
    lbl.textColor = textColor
  }
}


















































