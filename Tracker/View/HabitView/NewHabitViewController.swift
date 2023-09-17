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

final class NewHabitViewController: UIViewController {
    
    private let categories = ["Срочно", "Скучно", "Уборка", "Прогулка", "Важное", "Учеба"] //FOR Testing delete later
    private let typeTracker: TypeTracker
    private var tracker: Tracker? = nil
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
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        
        view.isScrollEnabled = true
        
        return view
    }()
    private lazy var contentView: UIView = {
        let view = UIView()

        return view
    }()
    private let trackerNameTextField: TextFieldWithPadding = {
        let view = TextFieldWithPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 16, paddingRight: 41)
        
        view.layer.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3).cgColor
        view.frame.size.height = 75
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.clear.cgColor
        view.placeholder = "Введите название трекера"
        view.clearButtonMode = .whileEditing
        
        return view
    }()
    private let exceedingCharacterLimitErrorField: UILabel = {
        let field = UILabel()
        
        field.textColor = UIColor(red: 0.961, green: 0.42, blue: 0.424, alpha: 1)
        field.font = UIFont.systemFont(ofSize: 17)
        field.text = "Ограничение 38 символов"
        field.isHidden = true
        field.textAlignment = .center
        
        return field
    }()
    private lazy var categoryButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Категория", for: .normal)
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .center
        button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 0.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.tintColor = .black
        button.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        
        return button
    }()
    private lazy var scheduleButton: UIButton = {
        let button = UIButton(type: .system)

        button.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        button.addTarget(self, action: #selector(scheduleButtonTapped), for: .touchUpInside)
        
        return button
    }()
    private let scheduleButtonLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Расписание"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        
        return label
    }()
    private let scheduleButtonLabelForSelectedDays: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
        label.isHidden = true
        
        return label
    }()
    private let arrayPictureViewForCategoryButton: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(named: "array_for_button")
        
        return view
    }()
    private let arrayPictureViewForScheduleButton: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(named: "array_for_button")
        
        return view
    }()
    private let categoryStackView: UIStackView = {
        let stackView = UIStackView()

        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.layer.masksToBounds = true
        stackView.layer.cornerRadius = 16

        return stackView
    }()
    private let stringSeparator: UIView = {
        let view = UIView()

        view.backgroundColor = .lightGray

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
        
        return collection
    }()
    private let bottomButtonsStackView: UIStackView = {
        let view = UIStackView()
        
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 8
        
        return view
    }()
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Отменить", for: .normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.tintColor = UIColor(red: 0.961, green: 0.42, blue: 0.424, alpha: 1)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.layer.borderColor = UIColor(red: 0.961, green: 0.42, blue: 0.424, alpha: 1).cgColor
        button.layer.borderWidth = 1
        
        return button
    }()
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Создать", for: .normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.tintColor = .white
        button.backgroundColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.isEnabled = true //todo
        
        return button
    }()
    
    init(typeTracker: TypeTracker) {
        self.typeTracker = typeTracker
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        navigationItem.title = typeTracker.typeTrackerName
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        navigationItem.setHidesBackButton(true, animated: false)
        view.backgroundColor = .white

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
        scheduleButton.addSubview(arrayPictureViewForScheduleButton)
        scheduleButton.addSubview(scheduleButtonLabel)
        scheduleButton.addSubview(scheduleButtonLabelForSelectedDays)
        
        contentView.addSubview(categoryStackView)
        
        bottomButtonsStackView.addArrangedSubview(cancelButton)
        bottomButtonsStackView.addArrangedSubview(createButton)
        
        contentView.addSubview(collectionView)
    }
    
    private func applyConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        trackerNameTextField.translatesAutoresizingMaskIntoConstraints = false
        categoryStackView.translatesAutoresizingMaskIntoConstraints = false
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        scheduleButton.translatesAutoresizingMaskIntoConstraints = false
        stringSeparator.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        arrayPictureViewForCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        arrayPictureViewForScheduleButton.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        bottomButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
        exceedingCharacterLimitErrorField.translatesAutoresizingMaskIntoConstraints = false
        scheduleButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        scheduleButtonLabelForSelectedDays.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            trackerNameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
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
    
    private func switchCreateButton() {
        createButton.backgroundColor = checkIfAllFieldsFilledOut() ?
        UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1) : UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
    }
    
    private func checkIfAllFieldsFilledOut() -> Bool {
        let scheduleFull = typeTracker == .habit ? schedule : [.monday] // Заглушка для проверки нерегулярного события
        
        guard let selectedEmoji = selectedEmoji,
              let selectedColor = selectedColor,
              let text = trackerNameTextField.text,
              let category = categories.randomElement(),
              text.count > 0 ,
              !scheduleFull.isEmpty
        else {
            return false
        }
        tracker = Tracker(
            id: UUID(),
            date: Date(),
            type: typeTracker,
            counter: 0,
            category: category,
            emoji: selectedEmoji,
            color: selectedColor,
            description: text,
            schedule: schedule,
            trackerIsDoneAt: []
        )
        return true
    }
    
    @objc private func categoryButtonTapped() {
        //TODO present categoryView
    }
    
    @objc private func scheduleButtonTapped() {
        navigationController?.pushViewController(AddScheduleViewController(delegate: self, selectedDays: schedule), animated: true)
    }
    
    @objc private func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func createButtonTapped() {
        if checkIfAllFieldsFilledOut() {
            dismiss(animated: true) { [weak self] in
                guard let self = self,
                      let tracker = tracker,
                      let parent = navigationController?.viewControllers.first as? AddTrackerViewController
                else {
                    return
                }
                parent.delegate?.didCreateNewTracker(tracker)
            }
        }
    }
    
    @objc private func dismissKeyboard() {
        scrollView.endEditing(true)
        switchCreateButton()
    }
}

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

extension NewHabitViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellIdentifier, for: indexPath) as? EmojiAndColorsArrayViewCell else {
            return UICollectionViewCell()
        }
        let section = indexPath.section
        
        if section == 0 {
            let model = EmojiAndColorCellModel(
                emoji: emojiArray[indexPath.row],
                color: nil,
                type: .emoji)
            cell.configure(with: model)
        } else {
            let model = EmojiAndColorCellModel(
                emoji: nil,
                color: colorList[indexPath.row],
                type: .color)
            cell.configure(with: model)
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
        
        let titleType = TrackerCellType(rawValue: indexPath.section)
        
        headerView.configureHeaderForHabitView(with: titleType!)
        
        return headerView
    }
}

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
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: collectionView.frame.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.indexPathsForSelectedItems != nil {
            deselectSelectedItemsInSection(indexPath: indexPath, collectionView: collectionView)
        }
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiAndColorsArrayViewCell else { return }
        
        let cellModel: EmojiAndColorCellModel
        if indexPath.section == 0 {
            selectedEmoji = emojiArray[indexPath.row]
            cellModel = EmojiAndColorCellModel(emoji: selectedEmoji, color: nil, type: .emoji)
        } else {
            selectedColor = colorList[indexPath.row]
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

extension NewHabitViewController: AddScheduleDelegate {
    func didRecieveSchedule(for selectedDays: [Schedule]) {
        self.schedule = selectedDays.sorted()
        
        scheduleButtonLabelForSelectedDays.text = schedule.map({ $0.representShortDayName() }).joined(separator: ", ")
        scheduleButtonLabelNewTopConstraint.isActive = !selectedDays.isEmpty
        scheduleButtonLabelForSelectedDays.isHidden = selectedDays.isEmpty
        
        switchCreateButton()
    }
}
