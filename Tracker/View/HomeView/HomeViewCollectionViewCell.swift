//
//  HomeViewCollectionViewCell.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 30.08.2023.
//

import UIKit

final class HomeViewCollectionViewCell: UICollectionViewCell {
    //TODO crete 2 stackViews and recollect items in these views
    private let trackerInfoView: UIView = {
        let view = UIView()
        
        view.frame.size.width = 167
        view.frame.size.height = 90
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.cornerRadius = 16
        
        return view
    }()
    private let emojiView: UILabel = {
        let view = UILabel()
        
//        view.backgroundColor = UIColor.black
        view.frame.size.width = 24
        view.frame.size.height = 24
        view.layer.masksToBounds = false
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.cornerRadius = view.frame.width / 2
        view.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
        view.contentMode = .center
        
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.frame = CGRect(x: 0, y: 0, width: 143, height: 34)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//        var paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineHeightMultiple = 1.26
//        label.attributedText = NSMutableAttributedString(string: "Поливать растения когда захочется", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.numberOfLines = 0
        return label
    }()
    private let bottomCellView: UIView = {
        let view = UIView()
        
        view.frame.size.width = 143
        view.frame.size.height = 34
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.cornerRadius = 16
        
        return view
    }()
    private let scheduleLabel: UILabel = {
        let label = UILabel()
        
//        label.frame.size.width
        label.frame.size.height = 34
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
        
        return label
    }()
    private let doneButton: UIButton = {
        let button = UIButton()
        
        button.frame.size.width = 34
        button.frame.size.height = 34
        button.layer.masksToBounds = false
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.cornerRadius = button.frame.width / 2
//        let image = UIImage(named: "done_tracker_button")?.withTintColor(.white, renderingMode: .alwaysOriginal)
////        button.setBackgroundImage(image, for: .normal)
//        button.setImage(image, for: .normal)
        button.backgroundColor = .white
        
        //TODO change button style to manage the button background color
//        let button = UIButton(type: .system) //
//        button.setImage(UIImage(named: "done_tracker_button")?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        return button
    }()
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.spacing = 8
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        applyConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with trackerModel: Tracker) {
        self.titleLabel.text = trackerModel.description
        trackerInfoView.backgroundColor = trackerModel.color
//        self.contentView.layer.cornerRadius = 16
//        self.contentView.layer.borderWidth = 1.0
//        self.contentView.layer.borderColor = UIColor.clear.cgColor
//        self.contentView.layer.masksToBounds = true
        
        emojiView.text = trackerModel.emoji
        scheduleLabel.text = "1 day"
        let image = UIImage(named: "done_tracker_button")?.withTintColor(trackerModel.color, renderingMode: .alwaysOriginal)
//        button.setBackgroundImage(image, for: .normal)
        doneButton.setImage(image, for: .normal)
//        doneButton.tintColor = trackerModel.color
    }
    
    private func addSubviews() {
        trackerInfoView.addSubview(emojiView)
        trackerInfoView.addSubview(titleLabel)
        bottomCellView.addSubview(scheduleLabel)
        bottomCellView.addSubview(doneButton)
        mainStackView.addArrangedSubview(trackerInfoView)
        mainStackView.addArrangedSubview(bottomCellView)
        contentView.addSubview(mainStackView)
//        contentView.addSubview(titleLabel)
//        contentView.addSubview(emojiView)
//        contentView.addSubview(scheduleLabel)
//        contentView.addSubview(doneButton)
    }
    
    private func applyConstraints() {
        trackerInfoView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        bottomCellView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        scheduleLabel.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emojiView.leadingAnchor.constraint(equalTo: trackerInfoView.leadingAnchor, constant: 12),
            emojiView.topAnchor.constraint(equalTo: trackerInfoView.topAnchor, constant: 12),
            emojiView.heightAnchor.constraint(equalToConstant: 24),
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            titleLabel.topAnchor.constraint(equalTo: emojiView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: emojiView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trackerInfoView.trailingAnchor, constant: -12),
            titleLabel.heightAnchor.constraint(equalToConstant: 34),
            titleLabel.centerYAnchor.constraint(equalTo: trackerInfoView.centerYAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            trackerInfoView.widthAnchor.constraint(equalToConstant: 167),
            trackerInfoView.heightAnchor.constraint(equalToConstant: 90),
            scheduleLabel.topAnchor.constraint(equalTo: bottomCellView.topAnchor),
            scheduleLabel.leadingAnchor.constraint(equalTo: bottomCellView.leadingAnchor, constant: 12),
            scheduleLabel.bottomAnchor.constraint(equalTo: bottomCellView.bottomAnchor, constant: -16),
            doneButton.widthAnchor.constraint(equalToConstant: 34),
            doneButton.heightAnchor.constraint(equalToConstant: 34),
            doneButton.trailingAnchor.constraint(equalTo: bottomCellView.trailingAnchor, constant: -12),
            doneButton.topAnchor.constraint(equalTo: bottomCellView.topAnchor)
        ])
        
//        NSLayoutConstraint.activate([
//            emojiView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
//            emojiView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
//            emojiView.heightAnchor.constraint(equalToConstant: 24),
//            emojiView.widthAnchor.constraint(equalToConstant: 24),
//            titleLabel.topAnchor.constraint(equalTo: emojiView.bottomAnchor, constant: 8),
//            titleLabel.leadingAnchor.constraint(equalTo: emojiView.leadingAnchor),
//            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
//            titleLabel.heightAnchor.constraint(equalToConstant: 34),
//            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 16),
//            doneButton.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
//            doneButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            doneButton.heightAnchor.constraint(equalToConstant: 34),
//            doneButton.widthAnchor.constraint(equalToConstant: 34)
//        ])
    }
}
