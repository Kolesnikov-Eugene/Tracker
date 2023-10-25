//
//  AlertPresenter.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 23.10.2023.
//

import UIKit

final class AlertPresenter {
    func show(in vc: UIViewController, model: AlertModel) {
        let alert = UIAlertController(
            title: nil,
            message: model.message,
            preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: model.okButtonText, style: .destructive) { _ in
            model.completion()
        }
        
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: model.cancelButtonText, style: .cancel)
        
        alert.addAction(cancelAction)
        
        vc.present(alert, animated: true)
    }
}
