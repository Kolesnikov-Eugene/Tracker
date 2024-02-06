//
//  StatisticTableViewCell.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 20.10.2023.
//

import UIKit

final class StatisticTableViewCell: UITableViewCell {
    
    private var gradientView: UIView!
    private let counterLabel: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        addGradient()
    }
    
    func configureCell(with label: String, and description: String) {
        counterLabel.text = label
        descriptionLabel.text = description
    }
    
    func configureCell(with model: StatisticsModel) {
        counterLabel.text = String(model.value)
        descriptionLabel.text = model.statName
    }
    
    private func setupUI() {
        configureContentView()
        
        addSubviews()
        applyConstraints()
    }
    
    private func configureContentView() {
        contentView.backgroundColor = .clear
    }
    
    private func addSubviews() {
        contentView.addSubview(counterLabel)
        contentView.addSubview(descriptionLabel)
        
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 102),
            
            counterLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            counterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            counterLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            counterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -35),
            
            descriptionLabel.topAnchor.constraint(equalTo: counterLabel.bottomAnchor, constant: 7),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            descriptionLabel.leadingAnchor.constraint(equalTo: counterLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: counterLabel.trailingAnchor)
        ])
    }
    
    private func addGradient() {
        gradientView = UIView(frame: CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height))
        gradientView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0))
        gradientView.clipsToBounds = true
        gradientView.layer.cornerRadius = 16
        contentView.addSubview(gradientView)
        
        let gradient = CAGradientLayer()
        
        let colorLeft = UIColor(named: "gradient_left")?.cgColor ?? UIColor.clear.cgColor
        let colorMiddle = UIColor(named: "gradient_middle")?.cgColor ?? UIColor.clear.cgColor
        let colorRight = UIColor(named: "gradient_right")?.cgColor ?? UIColor.clear.cgColor
        
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        gradient.frame =  CGRect(origin: .zero, size: gradientView.frame.size)
        gradient.colors = [colorLeft, colorMiddle, colorRight]
        
        let shape = CAShapeLayer()
        shape.lineWidth = 2
        shape.path = UIBezierPath(roundedRect: gradientView.bounds, cornerRadius: gradientView.layer.cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        gradientView.layer.addSublayer(gradient)
    }
}
