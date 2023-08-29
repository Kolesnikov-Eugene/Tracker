//
//  HomeViewConrtoller.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 29.08.2023.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private var addBarButtonItem: UIBarButtonItem?
    private let titleLabel: UILabel = {
        let label = UILabel()

        label.text = "Трекеры"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.frame.size.width = 254
        label.frame.size.height = 41
        label.font = UIFont.systemFont(ofSize: 34, weight: .regular)

        return label
    }()
    let datePicker: UIDatePicker = {
            let picker = UIDatePicker()
            picker.preferredDatePickerStyle = .compact
            picker.datePickerMode = .date
            return picker
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavBar()
        addSubviews()
        applyConstraints()
    }
        
    
    init() {
        super.init(nibName: nil, bundle: nil)
//        addNavBar()
//        addSubviews()
//        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        view.addSubview(titleLabel)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func addNavBar() {
        //        navigationController?.navigationBar.prefersLargeTitles = true
        //        navigationItem.title = "Трекеры"
        if let navBar = navigationController?.navigationBar {
            //            let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNextEmoji))
            //            navBar.topItem?.setRightBarButton(rightButton, animated: false)
            
            addBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(addNextEmoji))
            navBar.topItem?.setLeftBarButton(addBarButtonItem, animated: false)
            
            let datePickerItem = UIBarButtonItem(customView: datePicker)
            navigationItem.rightBarButtonItem = datePickerItem
        }
    }
    
    @objc func addNextEmoji() {
        let addTracker = AddTrackerViewController()
        present(addTracker, animated: true)
    }
}

