//
//  IntegerExtension.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 18.09.2023.
//

import Foundation

extension Int {
    var counterRepresentation: String {
        switch self % 10 {
        case 0, 5...9:
            return "дней"
        case 1:
            return 11...19 ~= self ? "дней" : "день"
        case 2...4:
            return 12...14 ~= self ? "дней" : "дня"
        default:
            return "дня"
        }
    }
}
