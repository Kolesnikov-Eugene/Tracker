//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 23.10.2023.
//

import UIKit

final class FiltersViewController: UIViewController {
    
    private var filterText: String
    private let reuseCellIdentifier = "FilterCell"
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    weak var delegate: FilterPickerDelegate?
    
    init(delegate: FilterPickerDelegate, filterText: Filter) {
        self.delegate = delegate
        self.filterText = filterText.representFilterText()
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.backgroundColor = Colors.shared.viewBackgroundColor
        
        navigationItem.title = "Фильтры"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -40),
            tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(1000)),
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FiltersTableViewCell.self, forCellReuseIdentifier: reuseCellIdentifier)
    }
}

//MARK: - UITableViewDataSource
extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Filter.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellIdentifier, for: indexPath) as? FiltersTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        let filter = Filter(rawValue: indexPath.row)
        
        let filterLabel = filter?.representFilterText() ?? ""
        
        cell.configureCell(at: indexPath.row, with: filterLabel, rows: Filter.allCases.count)
        
        if filterText == filterLabel {
            cell.cellIsSelected = true
            cell.switchCellState()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

//MARK: -  UITableViewDelegate
extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FiltersTableViewCell else { return }
        
        cell.cellIsSelected = !cell.cellIsSelected
        
        cell.switchCellState()
        
        let filter = Filter(rawValue: indexPath.row) ?? Filter.all
        
        delegate?.didRecieveFilter(filter)
        dismiss(animated: true)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell else { return }
        
        cell.cellIsSelected = false
        cell.switchCellState()
        
        filterText = ""
    }
}
