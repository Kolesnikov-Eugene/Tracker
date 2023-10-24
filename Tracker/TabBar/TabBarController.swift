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
        view.backgroundColor = Colors.shared.viewBackgroundColor
        
        let homeViewController = HomeViewController()
        let statisticService = StatisticService()
        let statisticViewController = StatisticViewController(statisticService: statisticService)
        let homeViewNavigationController = UINavigationController(rootViewController: homeViewController)
        homeViewNavigationController.interactivePopGestureRecognizer?.isEnabled = false
        
        homeViewController.tabBarItem = UITabBarItem(
            title: Constants.trackersTabBarLabel,
            image: UIImage(named: "trackers"),
            selectedImage: nil
        )
        
        statisticViewController.tabBarItem = UITabBarItem(
            title: Constants.statisticTabBarLabel,
            image: UIImage(named: "statistics"),
            selectedImage: nil)
        
        tabBar.unselectedItemTintColor = .gray
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.size.width, height: 0.5))
        lineView.backgroundColor = .lightGray
        tabBar.addSubview(lineView)
        
        self.viewControllers = [homeViewNavigationController, statisticViewController]
    }
}
