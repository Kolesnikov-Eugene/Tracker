//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 29.08.2023.
//

import Foundation

protocol TrackerCategoryProtocol {
    var category: String { get }
    var trackerArray: [TrackerProtocol] { get }
}

struct TrackerCategory: TrackerCategoryProtocol {
    let category: String
    let trackerArray: [TrackerProtocol]
}
