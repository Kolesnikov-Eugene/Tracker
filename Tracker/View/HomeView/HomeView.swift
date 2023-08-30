//
//  HomeView.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 29.08.2023.
//

import UIKit

final class HomeView: UIView {
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .black
        label.text = "Hello"
        
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLabel() {
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Hello"
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

//use later to refactor

//    private let titleLabel: UILabel = {
//        let label = UILabel()
//
//        label.text = "Трекеры"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.frame.size.width = 254
//        label.frame.size.height = 41
//        label.font = UIFont.systemFont(ofSize: 34, weight: .regular)
//
//        return label
//    }()

//    private func addSubviews() {
//        view.addSubview(titleLabel)
//    }
    
//    private func applyConstraints() {
//        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
//            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
//        ])
//    }

