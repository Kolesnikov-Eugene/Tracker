//
//  HomeViewCollectionViewCell.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 30.08.2023.
//

import UIKit

final class HomeViewCollectionViewCell: UICollectionViewCell {
    
    private let trackerInfoView: UIView = {
        let view = UIView()
        
        view.frame.size.width = 167
        view.frame.size.height = 90
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.cornerRadius = 16
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private let emojiView: UILabel = {
        let view = UILabel()
        
        view.frame.size.width = 24
        view.frame.size.height = 24
        view.layer.masksToBounds = false
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.cornerRadius = view.frame.width / 2
        view.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
        view.contentMode = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.frame = CGRect(x: 0, y: 0, width: 143, height: 34)
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        
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
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private let scheduleLabel: UILabel = {
        let label = UILabel()
        
        label.frame.size.height = 34
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = Colors.shared.screensTextColor
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.frame.size.width = 34
        button.frame.size.height = 34
        button.layer.masksToBounds = false
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.cornerRadius = button.frame.width / 2
        button.addTarget(self, action: #selector(addToDoneButtonTapped), for: .touchUpInside)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.spacing = 8
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    private let buttonView: UIView = {
        let view = UIView()
        
        view.frame.size.width = 34
        view.frame.size.height = 34
        view.layer.masksToBounds = false
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.cornerRadius = view.frame.width / 2
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private let pinImageView: UIImageView = {
        let view = UIImageView()
        
        view.backgroundColor = .clear
        view.image = UIImage(named: "pin_image")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    weak var delegate: HomeViewCellDelegate?
    var buttonChecked = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        applyConstraints()
        contentView.backgroundColor = .clear
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func addToDoneButtonTapped() {
        delegate?.didTapDoneStatus(self)
    }
    
    func previewView() -> UIView {
        trackerInfoView
    }
    
    private func addSubviews() {
        trackerInfoView.addSubview(emojiView)
        trackerInfoView.addSubview(titleLabel)
        trackerInfoView.addSubview(pinImageView)
        bottomCellView.addSubview(scheduleLabel)
        bottomCellView.addSubview(buttonView)
        buttonView.addSubview(doneButton)
        mainStackView.addArrangedSubview(trackerInfoView)
        mainStackView.addArrangedSubview(bottomCellView)
        contentView.addSubview(mainStackView)
    }
    
    private func applyConstraints() {
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
            
            pinImageView.trailingAnchor.constraint(equalTo: trackerInfoView.trailingAnchor, constant: -4),
            pinImageView.topAnchor.constraint(equalTo: trackerInfoView.topAnchor, constant: 12),
            pinImageView.heightAnchor.constraint(equalToConstant: 24),
            pinImageView.widthAnchor.constraint(equalToConstant: 24),
            
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            trackerInfoView.widthAnchor.constraint(equalToConstant: 167),
            trackerInfoView.heightAnchor.constraint(equalToConstant: 90),
            
            scheduleLabel.topAnchor.constraint(equalTo: bottomCellView.topAnchor),
            scheduleLabel.leadingAnchor.constraint(equalTo: bottomCellView.leadingAnchor, constant: 12),
            scheduleLabel.bottomAnchor.constraint(equalTo: bottomCellView.bottomAnchor, constant: -16),
            
            buttonView.widthAnchor.constraint(equalToConstant: 34),
            buttonView.heightAnchor.constraint(equalToConstant: 34),
            buttonView.trailingAnchor.constraint(equalTo: bottomCellView.trailingAnchor, constant: -12),
            buttonView.topAnchor.constraint(equalTo: bottomCellView.topAnchor),
            
            doneButton.widthAnchor.constraint(equalToConstant: 34),
            doneButton.heightAnchor.constraint(equalToConstant: 34),
            doneButton.trailingAnchor.constraint(equalTo: bottomCellView.trailingAnchor, constant: -12),
            doneButton.topAnchor.constraint(equalTo: bottomCellView.topAnchor)
        ])
    }
    
    func configureCell(with trackerModel: TrackerProtocol, counter: Int) {
        self.titleLabel.text = trackerModel.description
        trackerInfoView.backgroundColor = trackerModel.color
        emojiView.text = trackerModel.emoji
        scheduleLabel.text = String.localizedStringWithFormat(
            NSLocalizedString("numberOfDays",
                              comment: "Number of remaining tasks"), counter)
        buttonView.backgroundColor = Colors.shared.viewBackgroundColor
        
        let image = !buttonChecked ? UIImage(named: "tracker_unchecked")?.withRenderingMode(.alwaysTemplate) :
        UIImage(named: "checkmark")?.withTintColor(Colors.shared.viewBackgroundColor, renderingMode: .alwaysTemplate)
        doneButton.setImage(image, for: .normal)
        
        if buttonChecked {
            buttonView.backgroundColor = trackerModel.color.withAlphaComponent(0.3)
            doneButton.tintColor = Colors.shared.viewBackgroundColor
        } else {
            doneButton.tintColor = trackerModel.color
        }
    }
    
//    func configureCell(with trackerModel: TrackerProtocol, counter: Int) {
//        self.titleLabel.text = trackerModel.description
//        trackerInfoView.backgroundColor = trackerModel.color
//        emojiView.text = trackerModel.emoji
//        scheduleLabel.text = String.localizedStringWithFormat(
//            NSLocalizedString("numberOfDays",
//                              comment: "Number of remaining tasks"), counter)
//        buttonView.backgroundColor = .white
//        
//        let image = !buttonChecked ? UIImage(named: "tracker_unchecked")?.withRenderingMode(.alwaysTemplate) :
//        UIImage(named: "checkmark")?.withTintColor(.white, renderingMode: .alwaysTemplate)
//        doneButton.setImage(image, for: .normal)
//        
//        if buttonChecked {
//            buttonView.backgroundColor = trackerModel.color.withAlphaComponent(0.3)
//            doneButton.tintColor = .white
//        } else {
//            doneButton.tintColor = trackerModel.color
//        }
//    }
    
    func changePinState(trackerIsPinned: Bool) {
        pinImageView.isHidden = !trackerIsPinned
    }
}
