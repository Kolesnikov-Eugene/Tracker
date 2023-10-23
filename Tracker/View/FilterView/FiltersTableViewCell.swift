//
//  FiltersTableViewCell.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 23.10.2023.
//

import UIKit

final class FiltersTableViewCell: UITableViewCell {
    private lazy var filterLabel: UILabel = {
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = Colors.shared.tableViewsBackgroundColor
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(filterLabel)
        contentView.addSubview(checkmarkImageView)
        contentView.addSubview(stringSeparator)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            filterLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
            filterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -22),
            filterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            stringSeparator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stringSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stringSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stringSeparator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    func configureCell(at index: Int, with titleLabel: String, rows: Int) {
        switch index {
        case 0:
            contentView.layer.masksToBounds = true
            contentView.layer.cornerRadius = 16
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case rows - 1:
            contentView.layer.masksToBounds = true
            contentView.layer.cornerRadius = 16
            contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            stringSeparator.backgroundColor = .clear
        default:
            stringSeparator.backgroundColor = .lightGray
        }
        filterLabel.text = titleLabel
    }
    
    func switchCellState() {
        checkmarkImageView.image = cellIsSelected ? UIImage(named: "checkmark") : nil
    }
    
    func fetchFilterName() -> String {
        filterLabel.text ?? ""
    }
}
