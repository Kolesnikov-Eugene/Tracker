//
//  AddCategoryViewModelProtocol.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 14.03.2024.
//

import Foundation
import RxCocoa

protocol AddCategoryViewModelProtocol: AnyObject {
    var category: String { get set }
    var categories: [TrackerCategoryProtocol] { get }
    var categoriesList: BehaviorRelay<[TrackerCategoryProtocol]> { get }
    var hideEmptyState: Driver<Bool>? { get }
    func deleteCategory(_ category: String)
    func subscribe()
    func removeCategory()
}
