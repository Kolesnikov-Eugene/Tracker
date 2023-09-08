//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 07.09.2023.
//

import UIKit

final class NewHabitViewController: UIViewController {
    
    private let reuseCellIdentifier = "EmojiAndColorCell"
    private let headerID = "header"
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
        
        return view
    }()
    private let exceedingCharacterLimitErrorField: UILabel = {
        let field = UILabel()
        
        field.textColor = UIColor(red: 0.961, green: 0.42, blue: 0.424, alpha: 1)
        field.font = UIFont.systemFont(ofSize: 17)
        field.text = "Ограничение 38 символов"
        field.isHidden = true
        
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
        button.frame.size.height = 75
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return button
    }()
    private lazy var scheduleButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Расписание", for: .normal)
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .center
        button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 0.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.tintColor = .black
        button.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        button.addTarget(self, action: #selector(scheduleButtonTapped), for: .touchUpInside)
        button.frame.size.height = 75
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        return button
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
//        button.layer.borderColor = UIColor(red: 0.961, green: 0.42, blue: 0.424, alpha: 1).cgColor
//        button.layer.borderWidth = 1
        
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
        navigationItem.title = "Новая привычка"
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

    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        view.addSubview(bottomButtonsStackView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(trackerNameTextField)
        
        
        
//        contentView.addSubview(scheduleButton)
//        contentView.addSubview(cancelButton)
//        contentView.addSubview(stringSeparator)
//        contentView.addSubview(arrayPictureViewForCategoryButton)
//        contentView.addSubview(arrayPictureViewForScheduleButton)
        
        
        categoryStackView.addArrangedSubview(categoryButton)
        categoryStackView.addArrangedSubview(stringSeparator)
        categoryStackView.addArrangedSubview(scheduleButton)
        
        categoryButton.addSubview(arrayPictureViewForCategoryButton)
        scheduleButton.addSubview(arrayPictureViewForScheduleButton)
        
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
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomButtonsStackView.topAnchor, constant: -16),
//            scrollView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 3),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            contentView.heightAnchor.constraint(equalToConstant: 720),
            
            trackerNameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            trackerNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            trackerNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            trackerNameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            categoryStackView.topAnchor.constraint(equalTo: trackerNameTextField.bottomAnchor, constant: 24),
            categoryStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            categoryStackView.heightAnchor.constraint(equalToConstant: 150),
            
            arrayPictureViewForCategoryButton.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -16),
            arrayPictureViewForCategoryButton.centerYAnchor.constraint(equalTo: categoryButton.centerYAnchor),
            
            arrayPictureViewForScheduleButton.trailingAnchor.constraint(equalTo: scheduleButton.trailingAnchor, constant: -16),
            arrayPictureViewForScheduleButton.centerYAnchor.constraint(equalTo: scheduleButton.centerYAnchor),
            
            stringSeparator.heightAnchor.constraint(equalToConstant: 0.5),
            stringSeparator.leftAnchor.constraint(equalTo: categoryButton.leftAnchor, constant: 16),
            stringSeparator.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -16),
            stringSeparator.centerYAnchor.constraint(equalTo: categoryStackView.centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: categoryStackView.bottomAnchor, constant: 16),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: categoryStackView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: categoryStackView.trailingAnchor),
            
            bottomButtonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomButtonsStackView.trailingAnchor.constraint(equalTo: categoryStackView.trailingAnchor),
            bottomButtonsStackView.leadingAnchor.constraint(equalTo: categoryStackView.leadingAnchor),
            bottomButtonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func categoryButtonTapped() {
        
    }
    
    @objc private func scheduleButtonTapped() {
        navigationController?.pushViewController(AddScheduleViewController(), animated: true)
    }
    
    @objc private func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func createButtonTapped() {
        
    }
    @objc private func dismissKeyboard() {
        
    }
}

extension NewHabitViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 38
        let currentString = (trackerNameTextField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        
        exceedingCharacterLimitErrorField.isHidden = newString.count < 38
        
        return newString.count <= maxLength
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
        return CGSize(width: 52, height: 52)
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
}
