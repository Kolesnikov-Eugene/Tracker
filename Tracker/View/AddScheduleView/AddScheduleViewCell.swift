//
//  AddScheduleViewCell.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 11.09.2023.
//

import UIKit

final class AddScheduleViewCell: UITableViewCell {
    
    var switchState: Bool?
    var callBackSwitchState: ((Bool) -> (Void))?
    private lazy var dayOfWeekLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
        
        return label
    }()
    private lazy var addDayToScheduleSwitch: UISwitch = {
        let button = UISwitch()
        
        button.onTintColor = UIColor(red: 0.22, green: 0.45, blue: 0.91, alpha: 1)
        button.addTarget(self, action: #selector(switchDidChangeValue), for: .valueChanged)
        
        return button
    }()
    private let stringSeparator: UIView = {
        let view = UIView()

        view.backgroundColor = .lightGray

        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        applyConstraints()
        contentView.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func addSubviews() {
        contentView.addSubview(dayOfWeekLabel)
        contentView.addSubview(addDayToScheduleSwitch)
        contentView.addSubview(stringSeparator)
    }
    
    private func applyConstraints() {
        dayOfWeekLabel.translatesAutoresizingMaskIntoConstraints = false
        addDayToScheduleSwitch.translatesAutoresizingMaskIntoConstraints = false
        stringSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dayOfWeekLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
            dayOfWeekLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -22),
            dayOfWeekLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            addDayToScheduleSwitch.topAnchor.constraint(equalTo: dayOfWeekLabel.topAnchor),
            addDayToScheduleSwitch.bottomAnchor.constraint(equalTo: dayOfWeekLabel.bottomAnchor),
            addDayToScheduleSwitch.heightAnchor.constraint(equalToConstant: 31),
            addDayToScheduleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            stringSeparator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stringSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stringSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stringSeparator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    @objc private func switchDidChangeValue(_ sender: UISwitch) {
        callBackSwitchState?(sender.isOn)
    }
    
    func configureCell(at index: Int, with titleLabel: String) {
        switch index {
        case 0:
            contentView.layer.masksToBounds = true
            contentView.layer.cornerRadius = 16
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case 6:
            contentView.layer.masksToBounds = true
            contentView.layer.cornerRadius = 16
            contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            stringSeparator.backgroundColor = .clear
        default:
            stringSeparator.backgroundColor = .lightGray
        }
        dayOfWeekLabel.text = titleLabel
    }
    func switchCelladdDayToScheduleSwitch() {
        addDayToScheduleSwitch.isOn = true
    }
}
