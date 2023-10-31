//
//  ScreenWideButton.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 28.10.2023.
//

import UIKit

final class ScreenWideButton: UIButton {
    
    required init(title: String, color: UIColor) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(Colors.shared.buttonsTextColor, for: .normal)
        backgroundColor = Colors.shared.buttonsBackgroundColor
        layer.cornerRadius = 16
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
