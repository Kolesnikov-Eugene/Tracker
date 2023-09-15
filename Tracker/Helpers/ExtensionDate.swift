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
//            let calender = Calendar.current
//            var dateComponents = calender.dateComponents([.year, .month, .day], from: self)
//            dateComponents.timeZone = .current
//            return calender.date(from: dateComponents)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM yyyy"
            return dateFormatter.string(from: self)
        }
    }

}
