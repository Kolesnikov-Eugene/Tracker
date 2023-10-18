//
//  AddTrackerViewController.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 30.08.2023.
//

import UIKit

final class AddTrackerViewController: UIViewController {
    private lazy var addHabitButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Привычка", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(addHabit), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    private lazy var addIrregularEventButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Нерегулярные события", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(addIrregularHabit), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    weak var delegate: NewHabitDelegate?
    
    init(delegate: NewHabitDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        navigationItem.title = "Создание трекера"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        
        view.backgroundColor = .white
        
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(addHabitButton)
        stackView.addArrangedSubview(addIrregularEventButton)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 136)
        ])
    }
    
    @objc private func addHabit() {
        let newHabitViewController = NewHabitViewController(typeTracker: .habit)
        navigationController?.pushViewController(newHabitViewController, animated: true)
    }
    
    @objc private func addIrregularHabit() {
        let newHabitViewController = NewHabitViewController(typeTracker: .irregularIvent)
        navigationController?.pushViewController(newHabitViewController, animated: true)
    }
}
