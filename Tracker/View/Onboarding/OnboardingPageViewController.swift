//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 10.10.2023.
//

import UIKit

final class OnboardingPageViewController: UIPageViewController {
    private var firstViewController: UIViewController
    private var secondViewController: UIViewController
    private var pages: [UIViewController]
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.addTarget(self, action: #selector(pageControlTapped), for: .valueChanged)
        
        return pageControl
    }()
    
    init(firstViewController: UIViewController, secondViewController: UIViewController) {
        self.firstViewController = firstViewController
        self.secondViewController = secondViewController
        self.pages = [firstViewController, secondViewController]
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true)
        }
        
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func pageControlTapped(_ sender: Any) {
        guard let pageControl = sender as? UIPageControl else { return }
        let selectedPage = pageControl.currentPage
        let controller = pages[selectedPage]
        setViewControllers([controller], direction: .forward, animated: true)
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        var previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            previousIndex = pages.count - 1
            return pages[previousIndex]
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        var nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            nextIndex = 0
            return pages[nextIndex]
        }
        
        return pages[nextIndex]
    }
}

//MARK: - UIPageViewControllerDelegate
extension OnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
