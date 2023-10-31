//
//  AddTrackerViewController.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 30.08.2023.
//

import UIKit

final class AddTrackerViewController: UIViewController {
    private let addTrackerView = AddTrackerView()
    weak var delegate: NewHabitDelegate?
    
    init(delegate: NewHabitDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        addTrackerView.delegate = self
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
        self.view = addTrackerView
    }
}

extension AddTrackerViewController: AddTrackerViewDelegate {
    func addHabit() {
        let newHabitViewController = NewHabitViewController(typeTracker: .habit)
        navigationController?.pushViewController(newHabitViewController, animated: true)
    }
    
    func addIrregularEvent() {
        let newHabitViewController = NewHabitViewController(typeTracker: .irregularIvent)
        navigationController?.pushViewController(newHabitViewController, animated: true)
    }
}
