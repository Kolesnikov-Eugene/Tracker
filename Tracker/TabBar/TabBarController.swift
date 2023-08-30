//
//  TabBarController.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 29.08.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    init() {
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        let homeViewController = HomeViewController()
        let statisticViewController = StatisticViewController()
        let homeViewNavigationController = UINavigationController(rootViewController: homeViewController)
        homeViewNavigationController.interactivePopGestureRecognizer?.isEnabled = false
        
        homeViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "trackers"),
            selectedImage: nil
        )
        
        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "statistics"),
            selectedImage: nil)
        
        tabBar.unselectedItemTintColor = .gray
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.size.width, height: 0.5))
        lineView.backgroundColor = .lightGray
        tabBar.addSubview(lineView)
        
        self.viewControllers = [homeViewNavigationController, statisticViewController]
    }
}




