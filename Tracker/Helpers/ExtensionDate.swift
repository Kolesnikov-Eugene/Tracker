//
//  ExtensionDate.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 15.09.2023.
//

import Foundation

extension Date {

    var onlyDate: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM yyyy"
            return dateFormatter.string(from: self)
        }
    }

}
