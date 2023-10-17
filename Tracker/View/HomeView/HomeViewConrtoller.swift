//
//  HomeViewConrtoller.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 29.08.2023.
//

import UIKit

protocol NewHabitDelegate: AnyObject {
    func didCreateNewTracker(_ tracker: Tracker, for category: String)
}

protocol HomeViewCellDelegate: AnyObject {
    func didTapDoneStatus(_ cell: HomeViewCollectionViewCell)
}

final class HomeViewController: UIViewController {
    
    private var viewModel: HomeViewProtocol!
    private let reuseIdentifier = "TrackerViewCell"
    private var addBarButtonItem: UIBarButtonItem?
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.calendar.firstWeekday = 2
        picker.locale = Locale(identifier: "ru_RU")
        picker.addTarget(self, action: #selector(datePickerDidChangeDate), for: .valueChanged)
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        return picker
    }()
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.setValue("Отменить", forKey: "cancelButtonText")
        searchController.searchBar.delegate = self
        
        return searchController
    }()
    private let emptyStateView: UIImageView = {
        let view = UIImageView()
        
        view.frame.size.width = 80
        view.frame.size.height = 80
        view.image = UIImage(named: "empty_home_view")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private lazy var leftBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        
        button.image = UIImage(named: "add_tracker")?.withRenderingMode(.alwaysOriginal)
        button.style = .plain
        button.target = self
        button.action = #selector(addTrackerButtonTapped)
        button.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavBar()
        
        collectionView.register(HomeViewCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(
            SupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header"
        )
        collectionView.register(
            SupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: "footer"
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        
        addSubviews()
        applyConstraints()
        
        switchEmptyStateView()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel = HomeViewViewModel()
        viewModel.onState = { [weak self] in
            guard let self = self else { return }
            
            self.collectionView.reloadData()
            self.view.layoutIfNeeded()
        }
        
        viewModel.onSwitchToEmptyState = { [weak self] in
            guard let self = self else { return }
            
            self.switchToEmptyState()
        }
        
        viewModel.onSwitchToEmptySearchResult = { [weak self] in
            guard let self = self else { return }
            
            self.switchToEmptySearchResult()
        }
        
        viewModel.onSwitchEmptyStateView = { [weak self] in
            guard let self = self else { return }
            
            self.switchEmptyStateView()
        }
    }
    
    private func addSubviews() {
        view.addSubview(collectionView)
        view.addSubview(emptyStateView)
        view.addSubview(emptyStateLabel)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            datePicker.widthAnchor.constraint(equalToConstant: 100),
            
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.widthAnchor.constraint(equalToConstant: 80),
            emptyStateView.heightAnchor.constraint(equalToConstant: 80),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateView.bottomAnchor, constant: 8),
            emptyStateLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor)
        ])
    }
    
    private func configureNavBar() {
        if let navBar = navigationController?.navigationBar {
            navBar.prefersLargeTitles = true
            navigationItem.title = "Трекеры"
            navBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34, weight: .bold)]
            
            let datePickerItem = UIBarButtonItem(customView: datePicker)
            navigationItem.rightBarButtonItem = datePickerItem
            navigationItem.leftBarButtonItem = leftBarButton
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    private func switchEmptyStateView() {
        emptyStateView.isHidden = !viewModel.visibleCategories.isEmpty
        emptyStateLabel.isHidden = !viewModel.visibleCategories.isEmpty
    }
    
    private func switchToEmptyState() {
        emptyStateView.image = UIImage(named: "empty_home_view")
        emptyStateLabel.text = "Что будем отслеживать?"
    }
    
    private func switchToEmptySearchResult() {
        emptyStateView.image = UIImage(named: "empty_search_result")
        emptyStateLabel.text = "Ничего не найдено"
    }
    
    @objc private func datePickerDidChangeDate(_ sender: UIDatePicker) {
        viewModel.datePickerDidChangeDate(sender.date)
    }
    
    @objc func addTrackerButtonTapped() {
        let addTracker = AddTrackerViewController(delegate: self)
        let addTrackerNavigationCOntroller = UINavigationController(rootViewController: addTracker)
        
        present(addTrackerNavigationCOntroller, animated: true)
    }
}

//MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchQuery = searchBar.text else { return }
        viewModel.searchFilterDidChangeState(searchQuery)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchDidCancel()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchQuery = searchBar.text else { return }
        if !searchText.isEmpty {
            viewModel.searchTextDidChange(searchQuery)
        }
    }
}

//MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.subscribe(section)
        return viewModel.visibleCategories[section].trackerArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? HomeViewCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.prepareForReuse()
        cell.delegate = self
        
        let currentTracker = viewModel.visibleCategories[indexPath.section].trackerArray[indexPath.row]
        
        let counter = viewModel.getTrackerCompletionCounter(for: currentTracker)
     
        cell.buttonChecked = viewModel.trackerIsCompleted(currentTracker.id)
        
        cell.configureCell(with: currentTracker, counter: counter)
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView
    {
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header",
            for: indexPath
        ) as! SupplementaryView
        
        headerView.configureView(with: viewModel.visibleCategories[indexPath.section])
        
        return headerView
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 167, height: 148)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 16
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 9
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        let indexPath = IndexPath(row: 0, section: section)
        
        let headerView = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: indexPath
        )
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: collectionView.frame.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
}

//MARK: - NewHabitDelegate
extension HomeViewController: NewHabitDelegate {
    func didCreateNewTracker(_ tracker: Tracker, for category: String) {
        viewModel.createNewTracker(tracker, category: category)
    }
}

//MARK: - HomeViewCellDelegate
extension HomeViewController: HomeViewCellDelegate {
    func didTapDoneStatus(_ cell: HomeViewCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        viewModel.didTapDoneStatus(at: indexPath)
    }
}
