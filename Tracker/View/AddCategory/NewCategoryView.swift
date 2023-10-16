//
//  TrackerCategoriesView.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 11.10.2023.
//

import UIKit

enum Editing {
    case add
    case rename
}

final class NewCategoryView: UIViewController {
    private let options: Editing
    private var selectedCategory: String
    private lazy var categoryTextField: TextFieldWithPadding = {
        let view = TextFieldWithPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 16, paddingRight: 41)
        
        view.layer.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3).cgColor
        view.frame.size.height = 75
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.clear.cgColor
        view.placeholder = "Введите название категории"
        view.clearButtonMode = .whileEditing
        view.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        view.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .allEvents)

        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
        button.tintColor = .white
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitle("Готово", for: .normal)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    weak var delegate: AddCategoryDelegate?
    
    init(delegate: AddCategoryDelegate, selectedCategory: String, options: Editing) {
        self.delegate = delegate
        self.selectedCategory = selectedCategory
        self.options = options
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        navigationItem.title = "Новая категория"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        navigationItem.setHidesBackButton(true, animated: false)
        
        addSubviews()
        applyConstraints()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        if !selectedCategory.isEmpty {
            categoryTextField.text = selectedCategory
        }
    }
    
    private func addSubviews() {
        view.addSubview(categoryTextField)
        view.addSubview(doneButton)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            
            categoryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryTextField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    @objc private func doneButtonTapped() {
        guard let newCategory = categoryTextField.text,
        !newCategory.isEmpty,
        !newCategory.starts(with: " ") else {
            return
        }
        try? delegate?.didRecieveCategory(newCategory, for: selectedCategory, options: options)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        switchCreateButton()
    }
    
    private func switchCreateButton() {
        doneButton.backgroundColor = allFieldsFilledOut() ?
        UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1) : UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
    }
    
    private func allFieldsFilledOut() -> Bool {
        guard let result = categoryTextField.text else { return false }
        return !result.isEmpty
    }
}

//MARK: - UITextField Delegate
extension NewCategoryView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switchCreateButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switchCreateButton()
        return true
    }
}
