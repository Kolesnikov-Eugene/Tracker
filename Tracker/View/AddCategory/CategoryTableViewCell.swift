//
//  CategoryTableViewCell.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 11.10.2023.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private lazy var checkmarkImageView: UIImageView = {
        let view = UIImageView()
        
        view.isHidden = false //DONt FORGET TO CHANGE
        view.image = UIImage(named: "checkmark")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private let stringSeparator: UIView = {
        let view = UIView()
        
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        contentView.layer.masksToBounds = true
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(categoryLabel)
        contentView.addSubview(checkmarkImageView)
        contentView.addSubview(stringSeparator)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -22),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
//            checkmarkImageView.topAnchor.constraint(equalTo: categoryLabel.topAnchor),
//            checkmarkImageView.bottomAnchor.constraint(equalTo: categoryLabel.bottomAnchor),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            stringSeparator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stringSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stringSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stringSeparator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    func configureCell(at index: Int, and label: String, with rowNumber: Int) {
        switch rowNumber {
        case 1:
            contentView.layer.cornerRadius = 16
            stringSeparator.backgroundColor = .clear
        case 2:
            if index == 0 {
                roundUpperSideOfContentView()
            } else {
                roundBottomOfContentView()
            }
        case 2...Int.max:
            stringSeparator.backgroundColor = .lightGray
            if index == 0 {
                roundUpperSideOfContentView()
            } else if index + 1 == rowNumber  {
                roundBottomOfContentView()
            }
        default:
            stringSeparator.backgroundColor = .lightGray
        }
        categoryLabel.text = label
    }
    
    private func roundUpperSideOfContentView() {
        contentView.layer.cornerRadius = 16
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    private func roundBottomOfContentView() {
        contentView.layer.cornerRadius = 16
        contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        stringSeparator.backgroundColor = .clear
    }
}
