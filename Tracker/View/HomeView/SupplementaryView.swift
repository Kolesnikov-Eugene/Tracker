//
//  SupplementaryView.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 30.08.2023.
//

import UIKit

final class SupplementaryView: UICollectionReusableView {
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(with trackerModel: Tracker) {
        titleLabel.textColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 19)
        titleLabel.text = trackerModel.category
    }
    
    func configureHeaderForHabitView(with titleType: TrackerCellType) {
        titleLabel.text = titleType.rawValue == 0 ? "Emoji" : "Цвет"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 19)
        titleLabel.textColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
    }
}