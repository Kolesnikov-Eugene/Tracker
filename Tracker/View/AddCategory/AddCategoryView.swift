//
//  AddCategoryView.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 11.10.2023.
//

import UIKit

final class AddCategoryView: UIViewController {
    private var viewModel: AddCategoryViewModel!
    private var category: String
    private let reuseCellIdentifier = "CategoryCell"
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    private let emptyStateView: UIImageView = {
        let view = UIImageView()
        
        view.backgroundColor = .clear
        view.frame.size.width = 80
        view.frame.size.height = 80
        view.image = UIImage(named: "empty_home_view")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = .clear
        label.text = addCategoryEmptyStateText
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = .black
        button.tintColor = .white
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitle("Добавить категорию", for: .normal)
        button.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    weak var delegate: CategoryPickerDelegate?
    
    init(delegate: CategoryPickerDelegate, category: String) {
        self.delegate = delegate
        self.category = category
        super.init(nibName: nil, bundle: nil)
        bind()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel = AddCategoryViewModel()
        viewModel.onChange = { [ weak self ] newCategory in
            guard let self = self else { return }
            
            self.switchEmptyState()
            category = newCategory
            
            tableView.reloadData()
            view.layoutIfNeeded()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        navigationItem.title = "Категория"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        navigationItem.setHidesBackButton(true, animated: false)
        
        addSubviews()
        applyConstraints()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: reuseCellIdentifier)
        
        switchEmptyState()
    }
    
    private func addSubviews() {
        let subviews = [emptyStateView, emptyStateLabel, addCategoryButton, tableView]
        subviews.forEach { view.addSubview($0) }
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(lessThanOrEqualTo: addCategoryButton.topAnchor, constant: -40),
            tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(1000)),
            
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.widthAnchor.constraint(equalToConstant: 80),
            emptyStateView.heightAnchor.constraint(equalToConstant: 80),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateView.bottomAnchor, constant: 8),
            emptyStateLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            
            addCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func switchEmptyState() {
        emptyStateView.isHidden = viewModel.categories.count > 0
        emptyStateLabel.isHidden = viewModel.categories.count > 0
        tableView.isHidden = viewModel.categories.count < 0
    }
    
    @objc private func addCategoryButtonTapped() {
        navigationController?.pushViewController(
            NewCategoryView(delegate: viewModel, selectedCategory: "", mode: .add),
            animated: true)
    }
}

//MARK: - UITableView DataSource
extension AddCategoryView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellIdentifier, for: indexPath) as? CategoryTableViewCell
        else {
            return UITableViewCell()
        }
        
        let categoryLabel = viewModel.categories[indexPath.row].category
        
        cell.configureCell(at: indexPath.row, and: categoryLabel, with: viewModel.categories.count)
        
        cell.selectionStyle = .none
        
        if categoryLabel == category {
            cell.cellIsSelected = true
            cell.switchCellState()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

//MARK: - UITableView delegate
extension AddCategoryView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell else { return }
        
        cell.cellIsSelected = !cell.cellIsSelected
        
        cell.switchCellState()
        
        category = cell.fetchCategoryName()
        
        delegate?.didRecieveCategory(category)
        navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell else { return }
        
        cell.cellIsSelected = false
        cell.switchCellState()
        
        category = ""
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell else { return nil }
        let category = cell.fetchCategoryName()
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { action -> UIMenu? in
            let correctAction = UIAction(title: "Редактировать") { action in
                self.navigationController?.pushViewController(
                    NewCategoryView(delegate: self.viewModel, selectedCategory: category, mode: .rename),
                    animated: true)
            }
            let deleteAction = UIAction(title: "Удалить", attributes: .destructive) { action in
                self.viewModel.deleteCategory(category)
            }
            return UIMenu(children: [correctAction, deleteAction])
        }
    }
}
