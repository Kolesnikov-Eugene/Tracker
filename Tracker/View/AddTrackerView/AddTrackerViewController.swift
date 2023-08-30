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
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Привычка", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(addHabit), for: .touchUpInside)
        
        return button
    }()
    private lazy var addIrregularEventButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Нерегулярные события", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(addIrregularHabit), for: .touchUpInside)
        
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Создание трекера"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        
        view.backgroundColor = .white
        
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(addHabitButton)
        view.addSubview(addIrregularEventButton)
    }
    
    private func applyConstraints() {
        
    }
    
    @objc private func addHabit() {
        
    }
    
    @objc private func addIrregularHabit() {
        
    }
}
