//
//  SupplementaryView.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 30.08.2023.
//

import UIKit

final class SupplementaryView: UICollectionReusableView {
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
//            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
//            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(with trackerCategory: TrackerCategoryProtocol) {
        titleLabel.textColor = Colors.shared.screensTextColor
        titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        titleLabel.text = trackerCategory.category
    }
    
    func configureHeaderForHabitView(with titleType: TrackerCellType) {
        titleLabel.text = titleType.rawValue == 0 ? "Emoji" : "Цвет"
        titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        titleLabel.textColor = Colors.shared.screensTextColor
    }
    
    
}
