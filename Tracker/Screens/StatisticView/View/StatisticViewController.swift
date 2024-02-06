//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 30.08.2023.
//


import UIKit

final class StatisticViewController: UIViewController {
    
    private let statisticService: StatisticServiceProtocol
    private let reuseCellIdentifier = "StatisticCell"
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = Constants.statisticsMainLabel
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.backgroundColor = .clear
        label.textColor = Colors.shared.screensTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private let emptyStateView: UIImageView = {
        let view = UIImageView()
        
        view.backgroundColor = .clear
        view.frame.size.width = 80
        view.frame.size.height = 80
        view.image = UIImage(named: "empty_statistics")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = .clear
        label.text = Constants.emptyStatisticsLabel
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    private var button: UIButton!
    
    init(statisticService: StatisticServiceProtocol) {
        self.statisticService = statisticService
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchScreenState()
        
        view.backgroundColor = Colors.shared.viewBackgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        switchScreenState()
    }
    
    private func setupUI() {
        addSubviews()
        applyConstraints()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StatisticTableViewCell.self, forCellReuseIdentifier: reuseCellIdentifier)
    }
    
    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(emptyStateView)
        view.addSubview(emptyStateLabel)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.widthAnchor.constraint(equalToConstant: 80),
            emptyStateView.heightAnchor.constraint(equalToConstant: 80),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateView.bottomAnchor, constant: 8),
            emptyStateLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 77),
            tableView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 4 * 102),
            tableView.widthAnchor.constraint(greaterThanOrEqualTo: titleLabel.widthAnchor)
        ])
    }
    
    private func switchScreenState() {
        emptyStateView.isHidden = statisticService.statistics.count > 0
        emptyStateLabel.isHidden = statisticService.statistics.count > 0
        tableView.isHidden = statisticService.statistics.count == 0
//        emptyStateView.isHidden = statisticService.fetchCompletedTrackers() > 0
//        emptyStateLabel.isHidden = statisticService.fetchCompletedTrackers() > 0
//        tableView.isHidden = statisticService.fetchCompletedTrackers() == 0
    }
}

//MARK: - UITableViewDataSource
extension StatisticViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        1
        statisticService.statistics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellIdentifier) as? StatisticTableViewCell else {
            return UITableViewCell()
        }
        
        let model = statisticService.statistics[indexPath.row]
        
        cell.configureCell(with: model)
        
//        let counter = String(statisticService.fetchCompletedTrackers())
        
//        cell.configureCell(with: counter, and: "Трекеров завершено")
        
        return cell
    }
}

//MARK: - UITableViewDeegate
extension StatisticViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102
    }
}
