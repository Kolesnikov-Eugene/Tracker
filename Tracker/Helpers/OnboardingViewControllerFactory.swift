//
//  OnboardingViewControllerFactory.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 18.10.2023.
//

import UIKit

protocol OnboardingFactoryProtocol: AnyObject {
    func createViewController(imageName: String, infoText: String) -> UIViewController
}

final class OnboardingViewControllerFactory: OnboardingFactoryProtocol {
    func createViewController(imageName: String, infoText: String) -> UIViewController {
        OnboardingViewController(imageName: imageName, infoText: infoText)
    }
}
