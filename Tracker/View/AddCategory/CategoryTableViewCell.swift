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
        label.textColor = Colors.shared.screensTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private lazy var checkmarkImageView: UIImageView = {
        let view = UIImageView()
        
        view.isHidden = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private let stringSeparator: UIView = {
        let view = UIView()
        
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    var cellIsSelected = false
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        contentView.layer.cornerRadius = 16
        checkmarkImageView.image = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = Colors.shared.tableViewsBackgroundColor
        contentView.layer.cornerRadius = 16
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
            if index == 0 {
                roundUpperSideOfContentView()
            } else if index + 1 == rowNumber  {
                roundBottomOfContentView()
            } else {
                configureMiddleCell()
            }
        default:
            stringSeparator.backgroundColor = .lightGray
            contentView.layer.cornerRadius = 0
        }
        categoryLabel.text = label
    }
    
    private func configureMiddleCell() {
        stringSeparator.backgroundColor = .lightGray
        contentView.layer.cornerRadius = 0
    }
    
    private func roundUpperSideOfContentView() {
        contentView.layer.cornerRadius = 16
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        stringSeparator.backgroundColor = .lightGray
    }
    private func roundBottomOfContentView() {
        contentView.layer.cornerRadius = 16
        contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        stringSeparator.backgroundColor = .clear
    }
    
    func switchCellState() {
        checkmarkImageView.image = cellIsSelected ? UIImage(named: "checkmark") : nil
    }
    
    func fetchCategoryName() -> String {
        categoryLabel.text ?? ""
    }
}
