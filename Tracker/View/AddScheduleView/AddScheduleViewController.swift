//
//  AddScheduleViewController.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 08.09.2023.
//

import UIKit

final class AddScheduleViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        view.backgroundColor = .white
        navigationItem.title = "Расписание"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        navigationItem.setHidesBackButton(true, animated: false)
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        view.addSubview(doneButton)
    }
    private func applyConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
    }
}

extension AddScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Schedule.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell() //TODO
    }
}

extension AddScheduleViewController: UITableViewDelegate {
    
}
