//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 30.08.2023.
//


import UIKit

final class StatisticViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
    }
}
