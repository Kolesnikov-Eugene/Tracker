//
//  AddScheduleViewController.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 08.09.2023.
//

import UIKit

final class AddScheduleViewController: UIViewController {
    
    private var selectedDays: [Schedule]
    private let reuseCellIdentifier = "ScheduleCell"
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = Colors.shared.buttonsBackgroundColor
        button.setTitleColor(Colors.shared.buttonsTextColor, for: .normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitle("Готово", for: .normal)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    weak var delegate: AddScheduleDelegate?
    
    init(delegate: AddScheduleDelegate, selectedDays: [Schedule]) {
        self.delegate = delegate
        self.selectedDays = selectedDays
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        view.backgroundColor = Colors.shared.viewBackgroundColor
        navigationItem.title = "Расписание"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        navigationItem.setHidesBackButton(true, animated: false)
        
        tableView.dataSource = self
        tableView.register(AddScheduleViewCell.self, forCellReuseIdentifier: reuseCellIdentifier)
        
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(doneButton)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(lessThanOrEqualTo: doneButton.topAnchor, constant: -47),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            
            doneButton.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 4),
            doneButton.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -4),
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func doneButtonTapped() {
        delegate?.didRecieveSchedule(for: selectedDays)
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - UITableViewDataSource
extension AddScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Schedule.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellIdentifier, for: indexPath) as? AddScheduleViewCell,
              let label = Schedule(rawValue: indexPath.row)
        else {
            return UITableViewCell()
        }
        
        cell.configureCell(at: indexPath.row, with: label.representFullDayName())
        
        selectedDays.forEach { day in
            if day.rawValue == indexPath.row {
                cell.switchCelladdDayToScheduleSwitch()
            }
        }
        
        cell.callBackSwitchState = { [weak self] isOn in
            guard let self = self,
                  let day = Schedule(rawValue: indexPath.row)
            else {
                return
            }
            isOn ? selectedDays.append(day) : selectedDays.removeAll(where: { $0 == day })
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
