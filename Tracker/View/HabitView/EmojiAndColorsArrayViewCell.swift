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
        
//        let multiplier: CGFloat = 4 / 5
//        let fontSize = contentView.frame.width * multiplier
        
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32)
        label.frame.size.width = 52
        label.frame.size.height = 52
        
        return label
    }()
    private lazy var colorView: UIView = {
        let view = UIView()
        
        let multiplier: CGFloat = 4 / 5
        
        view.isHidden = true
        view.frame.size.width = contentView.frame.width * multiplier
        view.frame.size.height = contentView.frame.height * multiplier
        view.layer.cornerRadius = 8
        
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
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            emojiLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emojiLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            emojiLabel.heightAnchor.constraint(equalToConstant: 52),
//            emojiLabel.widthAnchor.constraint(equalToConstant: 52),
            
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
//            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 4 / 5),
            colorView.heightAnchor.constraint(equalTo: colorView.widthAnchor)
        ])
    }
    
    private func configureColorCell(with model: Tracker) {
        
    }
    
    func configure(with model: EmojiAndColorCellModel) {
        switch model.type {
        case .emoji:
//            contentView.addSubview(emojiLabel)
            emojiLabel.isHidden = false
            emojiLabel.text = model.emoji
        case .color:
//            contentView.addSubview(colorView)
            colorView.isHidden = false
            colorView.backgroundColor = model.color
        }
    }
}
