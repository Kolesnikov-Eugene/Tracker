//
//  SeparatorView.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 07.09.2023.
//

import UIKit

final class SeparatorView: UIView {
    
    init() {
        super.init(frame: .zero)
        configureView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        backgroundColor = .gray
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height:0.5)
    }
}
