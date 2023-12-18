//
//  EmojiAndColorsArrayViewCell.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 08.09.2023.
//

import UIKit

final class EmojiAndColorsArrayViewCell: UICollectionViewCell {
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private lazy var colorView: UIView = {
        let view = UIView()
        
        let multiplier: CGFloat = 4 / 5
        
        view.isHidden = true
        view.frame.size.width = contentView.frame.width * multiplier
        view.frame.size.height = contentView.frame.height * multiplier
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(emojiLabel)
        contentView.addSubview(colorView)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            emojiLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emojiLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            emojiLabel.widthAnchor.constraint(equalToConstant: 38),
//            emojiLabel.heightAnchor.constraint(equalToConstant: 32),
            
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 4 / 5),
            colorView.heightAnchor.constraint(equalTo: colorView.widthAnchor)
        ])
    }
    
    func configureBackgroundForSelectedCell(with selectedCell: EmojiAndColorCellModel) {
        switch selectedCell.type {
        case .emoji:
            contentView.layer.cornerRadius = 16
            contentView.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 1)
        case .color:
            let borderColor = selectedCell.color!.withAlphaComponent(0.3)
            
            contentView.layer.borderWidth = 3
            contentView.layer.cornerRadius = 8
            contentView.layer.borderColor = borderColor.cgColor
        }
    }
    
    func configure(with model: EmojiAndColorCellModel) {
        switch model.type {
        case .emoji:
            emojiLabel.isHidden = false
            emojiLabel.text = model.emoji
        case .color:
            colorView.isHidden = false
            colorView.backgroundColor = model.color
        }
    }
    
    func deselectCell() {
        contentView.backgroundColor = .clear
        contentView.layer.borderWidth = 0
    }
}
