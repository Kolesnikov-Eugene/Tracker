//
//  Filter.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 23.10.2023.
//

import Foundation

enum Filter: Int, CaseIterable {
    case all = 0
    case today = 1
    case completed = 2
    case uncompleted = 3
    
    func representFilterText() -> String {
        switch self {
        case .all:
            return "Все трекеры"
        case .today:
            return "Трекеры на сегодня"
        case .completed:
            return "Завершенные"
        case .uncompleted:
            return "Не завершенные"
        }
    }
    
    func createFilterModel(with filterText: String) -> Filter {
        switch filterText {
        case "Все трекеры":
            return Filter(rawValue: 0) ?? Filter(rawValue: 0)!
        case "Трекеры на сегодня":
            return Filter(rawValue: 1) ?? Filter(rawValue: 0)!
        case "Завершенные":
            return Filter(rawValue: 2) ?? Filter(rawValue: 0)!
        case "Не завершенные":
            return Filter(rawValue: 3) ?? Filter(rawValue: 0)!
        default:
            return Filter(rawValue: 0) ?? Filter(rawValue: 0)!
        }
    }
}
