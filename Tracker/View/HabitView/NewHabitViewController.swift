//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 07.09.2023.
//

import UIKit

protocol AddScheduleDelegate: AnyObject {
    func didRecieveSchedule(for selectedDays: [Schedule])
}

protocol CategoryPickerDelegate: AnyObject {
    func didRecieveCategory(_ category: String)
}

final class NewHabitViewController: UIViewController {
    
    private var editingModeIsOn: Bool
    private var selectedCategory: String = ""
    private let typeTracker: TypeTracker
    private var tracker: TrackerProtocol? = nil
    private var selectedEmoji: String? = nil
    private var selectedColor: UIColor? = nil
    private var schedule: [Schedule] = []
    private let reuseCellIdentifier = "EmojiAndColorCell"
    private let headerID = "header"
    private lazy var sctackTopConstraintWhenErrorLabelShown: NSLayoutConstraint = {
        categoryStackView.topAnchor.constraint(equalTo: trackerNameTextField.bottomAnchor, constant: 24)
    }()
    private lazy var sctackTopConstraintWhenErrorLabelIsHidden: NSLayoutConstraint = {
        categoryStackView.topAnchor.constraint(equalTo: trackerNameTextField.bottomAnchor, constant: 62)
    }()
    private lazy var scheduleButtonLabelNewTopConstraint: NSLayoutConstraint = {
        scheduleButtonLabel.topAnchor.constraint(equalTo: scheduleButton.topAnchor, constant: 15)
    }()
    private lazy var categoryButtonLabelNewTopConstraint: NSLayoutConstraint = {
        categoryButtonLabel.topAnchor.constraint(equalTo: categoryButton.topAnchor, constant: 15)
    }()
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        
        view.isScrollEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private lazy var contentView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private let counterLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = Colors.shared.screensTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private let trackerNameTextField: TextFieldWithPadding = {
        let view = TextFieldWithPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 16, paddingRight: 41)
        
        view.backgroundColor = Colors.shared.tableViewsBackgroundColor
        view.frame.size.height = 75
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.clear.cgColor
        view.placeholder = "Введите название трекера"
        view.clearButtonMode = .whileEditing
        view.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private let exceedingCharacterLimitErrorField: UILabel = {
        let field = UILabel()
        
        field.textColor = UIColor(red: 0.961, green: 0.42, blue: 0.424, alpha: 1)
        field.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        field.text = "Ограничение 38 символов"
        field.isHidden = true
        field.textAlignment = .center
        field.translatesAutoresizingMaskIntoConstraints = false
        
        return field
    }()
    private lazy var categoryButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = Colors.shared.tableViewsBackgroundColor
        button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    private let categoryButtonLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = Colors.shared.screensTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private let categoryButtonLabelForSelectedCategory: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private lazy var scheduleButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = Colors.shared.tableViewsBackgroundColor
        button.addTarget(self, action: #selector(scheduleButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    private let scheduleButtonLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Расписание"
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = Colors.shared.screensTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private let scheduleButtonLabelForSelectedDays: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private let arrayPictureViewForCategoryButton: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(named: "array_for_button")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private let arrayPictureViewForScheduleButton: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(named: "array_for_button")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private let categoryStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.backgroundColor = Colors.shared.tableViewsBackgroundColor
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.layer.masksToBounds = true
        stackView.layer.cornerRadius = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    private let stringSeparator: UIView = {
        let view = UIView()
        
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: 52, height: 52)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isScrollEnabled = false
        collection.allowsMultipleSelection = true
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        return collection
    }()
    private let bottomButtonsStackView: UIStackView = {
        let view = UIStackView()
        
        view.backgroundColor = .clear
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Отменить", for: .normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.tintColor = UIColor(red: 0.961, green: 0.42, blue: 0.424, alpha: 1)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.layer.borderColor = UIColor(red: 0.961, green: 0.42, blue: 0.424, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Создать", for: .normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.tintColor = .white
        button.backgroundColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.isEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    weak var delegate: NewHabitDelegate?
    
    init(typeTracker: TypeTracker) {
        self.typeTracker = typeTracker
        self.editingModeIsOn = false
        super.init(nibName: nil, bundle: nil)
        counterLabel.isHidden = true
        setupUI()
    }
    
    init(typeTracker: TypeTracker, trackerEdit: TrackerEdit, delegate: NewHabitDelegate) {
        self.typeTracker = typeTracker
        self.tracker = trackerEdit.tracker
        self.delegate = delegate
        self.editingModeIsOn = true
        super.init(nibName: nil, bundle: nil)
        self.selectedCategory = trackerEdit.category
        self.selectedEmoji = trackerEdit.tracker.emoji
        self.selectedColor = trackerEdit.tracker.color
        self.schedule = trackerEdit.tracker.schedule
        
        counterLabel.isHidden = false
        
        setupUI()
        
        configureEditingMode(with: trackerEdit)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        navigationItem.title = typeTracker.typeTrackerName
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        navigationItem.setHidesBackButton(true, animated: false)
        view.backgroundColor = Colors.shared.viewBackgroundColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)
        
        trackerNameTextField.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(
            EmojiAndColorsArrayViewCell.self,
            forCellWithReuseIdentifier: reuseCellIdentifier
        )
        collectionView.register(
            SupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: headerID
        )
        
        addSubviews()
        applyConstraints()
        sctackTopConstraintWhenErrorLabelShown.isActive = true
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        view.addSubview(bottomButtonsStackView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(counterLabel)
        contentView.addSubview(trackerNameTextField)
        contentView.addSubview(exceedingCharacterLimitErrorField)
        
        switch typeTracker {
        case .habit:
            categoryStackView.addArrangedSubview(categoryButton)
            categoryStackView.addArrangedSubview(stringSeparator)
            categoryStackView.addArrangedSubview(scheduleButton)
        case .irregularIvent:
            categoryStackView.addArrangedSubview(categoryButton)
        }
        
        categoryButton.addSubview(arrayPictureViewForCategoryButton)
        categoryButton.addSubview(categoryButtonLabel)
        categoryButton.addSubview(categoryButtonLabelForSelectedCategory)
        scheduleButton.addSubview(arrayPictureViewForScheduleButton)
        scheduleButton.addSubview(scheduleButtonLabel)
        scheduleButton.addSubview(scheduleButtonLabelForSelectedDays)
        
        contentView.addSubview(categoryStackView)
        
        bottomButtonsStackView.addArrangedSubview(cancelButton)
        bottomButtonsStackView.addArrangedSubview(createButton)
        
        contentView.addSubview(collectionView)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomButtonsStackView.topAnchor, constant: -16),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            contentView.heightAnchor.constraint(equalToConstant: typeTracker == .habit ? 740 : 670),
            
            counterLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            counterLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            counterLabel.heightAnchor.constraint(equalToConstant: 38),
            
            trackerNameTextField.topAnchor.constraint(equalTo: counterLabel.bottomAnchor, constant: counterLabel.isHidden ? -38 : 40),
            trackerNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            trackerNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            trackerNameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            exceedingCharacterLimitErrorField.topAnchor.constraint(equalTo: trackerNameTextField.bottomAnchor, constant: 8),
            exceedingCharacterLimitErrorField.leadingAnchor.constraint(equalTo: trackerNameTextField.leadingAnchor),
            exceedingCharacterLimitErrorField.trailingAnchor.constraint(equalTo: trackerNameTextField.trailingAnchor),
            exceedingCharacterLimitErrorField.heightAnchor.constraint(equalToConstant: 22),
            
            categoryStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            categoryStackView.heightAnchor.constraint(equalToConstant: typeTracker == .habit ? 150 : 75),
            
            categoryButtonLabel.leadingAnchor.constraint(equalTo: trackerNameTextField.leadingAnchor, constant: 16),
            categoryButtonLabel.topAnchor.constraint(equalTo: categoryButton.topAnchor, constant: 26),
            categoryButtonLabel.heightAnchor.constraint(equalToConstant: 22),
            
            categoryButtonLabelForSelectedCategory.leadingAnchor.constraint(equalTo: trackerNameTextField.leadingAnchor, constant: 16),
            categoryButtonLabelForSelectedCategory.topAnchor.constraint(equalTo: categoryButton.topAnchor, constant: 39),
            categoryButtonLabelForSelectedCategory.heightAnchor.constraint(equalToConstant: 22),
            
            collectionView.topAnchor.constraint(equalTo: categoryStackView.bottomAnchor, constant: 16),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: categoryStackView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: categoryStackView.trailingAnchor),
            
            bottomButtonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomButtonsStackView.trailingAnchor.constraint(equalTo: categoryStackView.trailingAnchor),
            bottomButtonsStackView.leadingAnchor.constraint(equalTo: categoryStackView.leadingAnchor),
            bottomButtonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        switch typeTracker {
        case .habit:
            NSLayoutConstraint.activate([
                scheduleButtonLabel.leadingAnchor.constraint(equalTo: trackerNameTextField.leadingAnchor, constant: 16),
                scheduleButtonLabel.topAnchor.constraint(equalTo: scheduleButton.topAnchor, constant: 26),
                scheduleButtonLabel.heightAnchor.constraint(equalToConstant: 22),
                
                scheduleButtonLabelForSelectedDays.leadingAnchor.constraint(equalTo: trackerNameTextField.leadingAnchor, constant: 16),
                scheduleButtonLabelForSelectedDays.topAnchor.constraint(equalTo: scheduleButton.topAnchor, constant: 39),
                scheduleButtonLabelForSelectedDays.heightAnchor.constraint(equalToConstant: 22),
                
                stringSeparator.heightAnchor.constraint(equalToConstant: 0.5),
                stringSeparator.leftAnchor.constraint(equalTo: categoryButton.leftAnchor, constant: 16),
                stringSeparator.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -16),
                stringSeparator.centerYAnchor.constraint(equalTo: categoryStackView.centerYAnchor),
                
                arrayPictureViewForCategoryButton.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -16),
                arrayPictureViewForCategoryButton.centerYAnchor.constraint(equalTo: categoryButton.centerYAnchor),
                
                arrayPictureViewForScheduleButton.trailingAnchor.constraint(equalTo: scheduleButton.trailingAnchor, constant: -16),
                arrayPictureViewForScheduleButton.centerYAnchor.constraint(equalTo: scheduleButton.centerYAnchor),
            ])
        case .irregularIvent:
            NSLayoutConstraint.activate([
                arrayPictureViewForCategoryButton.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -16),
                arrayPictureViewForCategoryButton.centerYAnchor.constraint(equalTo: categoryButton.centerYAnchor),
            ])
        }
    }
    
    private func configureEditingMode(with trackerEdit: TrackerEdit) {
        navigationItem.title = "Редактрирование привычки"
        trackerNameTextField.text = trackerEdit.tracker.description
        createButton.setTitle("Сохранить", for: .normal)
        
        categoryButtonLabelForSelectedCategory.text = trackerEdit.category
        categoryButtonLabelNewTopConstraint.isActive = true
        categoryButtonLabelForSelectedCategory.isHidden = false
        
        scheduleButtonLabelForSelectedDays.text = trackerEdit.tracker.schedule.count == 7 ?
        "Ежедневно" : trackerEdit.tracker.schedule.map({ $0.representShortDayName() }).joined(separator: ", ")
        
        scheduleButtonLabelForSelectedDays.isHidden = false
        scheduleButtonLabelNewTopConstraint.isActive = true
        
        let counter = trackerEdit.counter
        
        counterLabel.text = String.localizedStringWithFormat(
            NSLocalizedString("numberOfDays",
                              comment: "Number of remaining tasks"), counter)
        switchCreateButton()
        view.layoutIfNeeded()
    }
    
    private func switchCreateButton() {
        createButton.backgroundColor = allFieldsFilledOut() ? Colors.shared.buttonEnabledColor : Colors.shared.buttonDisabledColor
        let color = allFieldsFilledOut() ? Colors.shared.buttonsTextColor : .white
        createButton.setTitleColor(color, for: .normal)
    }
    
    private func allFieldsFilledOut() -> Bool {
        if typeTracker == .irregularIvent {
            schedule = Schedule.allCases.map { $0 }
        }
        guard let selectedEmoji = selectedEmoji,
              let selectedColor = selectedColor,
              let text = trackerNameTextField.text,
              !selectedCategory.isEmpty,
              selectedCategory.count > 0,
              !selectedCategory.starts(with: " "),
              text.count > 0 ,
              !schedule.isEmpty
        else {
            return false
        }
        let id = editingModeIsOn ? tracker?.id : UUID()
        
        tracker = Tracker(
            id: id ?? UUID(),
            emoji: selectedEmoji,
            color: selectedColor,
            description: text,
            schedule: schedule
        )
        return true
    }
    
    @objc private func categoryButtonTapped() {
        let addCategoryView = AddCategoryView(delegate: self, category: selectedCategory)
        navigationController?.pushViewController(addCategoryView, animated: true)
    }
    
    @objc private func scheduleButtonTapped() {
        navigationController?.pushViewController(
            AddScheduleViewController(delegate: self, selectedDays: schedule),
            animated: true)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        if allFieldsFilledOut() {
            dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                if editingModeIsOn {
                    guard let tracker = tracker,
                          let delegate = delegate
                    else {
                        return
                    }
                    delegate.didChangeTracker(tracker, for: selectedCategory)
                }
                guard let tracker = tracker,
                      let parent = navigationController?.viewControllers.first as? AddTrackerViewController
                else {
                    return
                }
                parent.delegate?.didCreateNewTracker(tracker, for: selectedCategory)
            }
        }
    }
    
    @objc private func dismissKeyboard() {
        scrollView.endEditing(true)
        switchCreateButton()
    }
}

//MARK: - UITextFieldDelegate
extension NewHabitViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 38
        let currentString = (trackerNameTextField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        
        exceedingCharacterLimitErrorField.isHidden = newString.count < 38
        
        if !exceedingCharacterLimitErrorField.isHidden {
            sctackTopConstraintWhenErrorLabelShown.isActive = false
            sctackTopConstraintWhenErrorLabelIsHidden.isActive = true
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            
        } else {
            sctackTopConstraintWhenErrorLabelShown.isActive = true
            sctackTopConstraintWhenErrorLabelIsHidden.isActive = false
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
        switchCreateButton()
        
        return newString.count <= maxLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switchCreateButton()
        return true
    }
}

//MARK: - UICollectionViewDataSource
extension NewHabitViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.emojiArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellIdentifier, for: indexPath) as? EmojiAndColorsArrayViewCell else {
            return UICollectionViewCell()
        }
        let section = indexPath.section
        
        if section == 0 {
            let model = EmojiAndColorCellModel(
                emoji: Constants.emojiArray[indexPath.row],
                color: nil,
                type: .emoji)
            cell.configure(with: model)
            
            guard model.emoji == selectedEmoji else { return cell }
            cell.configureBackgroundForSelectedCell(with: model)
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        } else {
            let model = EmojiAndColorCellModel(
                emoji: nil,
                color: Constants.colorList[indexPath.row],
                type: .color)
            cell.configure(with: model)
            
            guard model.color?.hexString() == selectedColor?.hexString() else { return cell }
            cell.configureBackgroundForSelectedCell(with: model)
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header",
            for: indexPath
        ) as! SupplementaryView
        
        if let titleType = TrackerCellType(rawValue: indexPath.section) {
            headerView.configureHeaderForHabitView(with: titleType)
        }
        return headerView
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension NewHabitViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let geometricParams = GeometricParams(cellCount: 6, leftInset: 16, rightInset: 16, cellSpacing: 5)
        
        let availableWidth = collectionView.frame.width - geometricParams.paddingWidth
        let cellWidth =  availableWidth / CGFloat(geometricParams.cellCount)
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        
        let headerView = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: indexPath
        )
        
        return headerView.systemLayoutSizeFitting(
            CGSize(width: collectionView.frame.width,
                   height: collectionView.frame.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.indexPathsForSelectedItems != nil {
            deselectSelectedItemsInSection(indexPath: indexPath, collectionView: collectionView)
        }
        guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiAndColorsArrayViewCell else { return }
        
        let cellModel: EmojiAndColorCellModel
        if indexPath.section == 0 {
            selectedEmoji = Constants.emojiArray[indexPath.row]
            cellModel = EmojiAndColorCellModel(emoji: selectedEmoji, color: nil, type: .emoji)
        } else {
            selectedColor = Constants.colorList[indexPath.row]
            cellModel = EmojiAndColorCellModel(emoji: nil, color: selectedColor, type: .color)
        }
        cell.configureBackgroundForSelectedCell(with: cellModel)
        switchCreateButton()
    }
    
    private func deselectSelectedItemsInSection(indexPath: IndexPath, collectionView: UICollectionView) {
        collectionView.indexPathsForSelectedItems?.forEach({ selectedIndexPath in
            if selectedIndexPath.section == indexPath.section,
               selectedIndexPath.row != indexPath.row {
                collectionView.deselectItem(at: selectedIndexPath, animated: false)
                let cell = collectionView.cellForItem(at: selectedIndexPath) as? EmojiAndColorsArrayViewCell
                cell?.deselectCell()
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiAndColorsArrayViewCell else { return }
        
        if indexPath.section == 0 {
            selectedEmoji = nil
        } else {
            selectedColor = nil
        }
        
        cell.deselectCell()
        switchCreateButton()
    }
}

//MARK: - AddScheduleDelegate
extension NewHabitViewController: AddScheduleDelegate {
    func didRecieveSchedule(for selectedDays: [Schedule]) {
        self.schedule = selectedDays.sorted()
        
        if schedule.count == 7 {
            scheduleButtonLabelForSelectedDays.text = "Ежедневно"
        } else {
            scheduleButtonLabelForSelectedDays.text = schedule.map({ $0.representShortDayName() }).joined(separator: ", ")
        }
        scheduleButtonLabelNewTopConstraint.isActive = !selectedDays.isEmpty
        scheduleButtonLabelForSelectedDays.isHidden = selectedDays.isEmpty
        
        switchCreateButton()
    }
}

//MARK: - CategoryPickerDelegate
extension NewHabitViewController: CategoryPickerDelegate {
    func didRecieveCategory(_ category: String) {
        self.selectedCategory = category
        
        categoryButtonLabelForSelectedCategory.text = selectedCategory
        
        categoryButtonLabelNewTopConstraint.isActive = !selectedCategory.isEmpty && !selectedCategory.starts(with: " ")
        categoryButtonLabelForSelectedCategory.isHidden = selectedCategory.isEmpty && selectedCategory.starts(with: " ")
        
        switchCreateButton()
    }
}
