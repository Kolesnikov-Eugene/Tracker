//
//  Colors.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 23.10.2023.
//


import UIKit

final class Colors {
    static let shared = Colors()
    let viewBackgroundColor = UIColor.systemBackground
    let buttonDisabledColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
        } else {
            return UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
        }
    }
    let buttonEnabledColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
        } else {
            return .white
        }
    }
    let buttonsTextColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor.white
        } else {
            return UIColor.black
        }
    }
    let screensTextColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor.black
        } else {
            return UIColor.white
        }
    }
    let buttonsBackgroundColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor.black
        } else {
            return UIColor.white
        }
    }
    let tableViewsBackgroundColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        } else {
            return UIColor(red: 0.254, green: 0.254, blue: 0.254, alpha: 0.85)
        }
    }
    let tabBarBorderColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor.lightGray
        } else {
            return UIColor.clear  
        }
    }
}
