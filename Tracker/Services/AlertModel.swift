//
//  AlertModel.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 23.10.2023.
//

import Foundation

struct AlertModel {
    let message: String
    let okButtonText: String
    let cancelButtonText: String
    let completion: () -> ()
}
