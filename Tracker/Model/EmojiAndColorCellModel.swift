//
//  EmojiAndColorCellModel.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 08.09.2023.
//

import UIKit

struct EmojiAndColorCellModel {
    let emoji: String?
    let color: UIColor?
    let type: TrackerCellType
}

enum TrackerCellType: Int {
    case emoji = 0
    case color = 1
}
