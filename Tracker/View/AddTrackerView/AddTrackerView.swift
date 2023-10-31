//
//  AddTrackerView.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 28.10.2023.
//

import UIKit

protocol AddTrackerViewDelegate: AnyObject {
    func addHabit()
    func addIrregularEvent()
}

final class AddTrackerView: UIView {
    private let addHabitButton: UIButton = ScreenWideButton(
        title: "Привычка",
        color: Colors.shared.buttonsBackgroundColor
    )
    private let addIrregularEventButton: UIButton = ScreenWideButton(
        title: "Нерегулярное событие",
        color: Colors.shared.buttonsBackgroundColor
    )
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    weak var delegate: AddTrackerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configureButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = Colors.shared.viewBackgroundColor
        
        addSubviews()
        applyConstraints()
    }
    
    private func configureButtons() {
        addHabitButton.addTarget(self, action: #selector(addHabit), for: .touchUpInside)
        addIrregularEventButton.addTarget(self, action: #selector(addIrregularHabit), for: .touchUpInside)
    }
    
    private func addSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubview(addHabitButton)
        stackView.addArrangedSubview(addIrregularEventButton)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 136)
        ])
    }
    
    @objc private func addHabit() {
        delegate?.addHabit()
    }
    
    @objc private func addIrregularHabit() {
        delegate?.addIrregularEvent()
    }
}
