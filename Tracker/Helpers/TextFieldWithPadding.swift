//
//  TextFieldWithPadding.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 07.09.2023.
//

import UIKit

final class TextFieldWithPadding: UITextField {
    private var paddingTop: CGFloat
    private var paddingBottom: CGFloat
    private var paddingLeft: CGFloat
    private var paddingRight: CGFloat
    
    init(paddingTop: CGFloat, paddingBottom: CGFloat, paddingLeft: CGFloat, paddingRight: CGFloat) {
        self.paddingTop = paddingTop
        self.paddingBottom = paddingBottom
        self.paddingLeft = paddingLeft
        self.paddingRight = paddingRight
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: UIEdgeInsets(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: UIEdgeInsets(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight))
    }
}
