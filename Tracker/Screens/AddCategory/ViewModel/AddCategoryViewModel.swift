//
//  AddCategoryViewModel.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 11.10.2023.
//

import Foundation

protocol AddCategoryViewModelProtocol: AnyObject {
    var onChange: ((String) -> Void)? { get set }
    var categories: [TrackerCategoryProtocol] { get }
    func deleteCategory(_ category: String)
    func subscribe()
}

protocol AddCategoryDelegate: AnyObject {
    func didRecieveCategory(_ categoryName: String, for oldCategory: String, mode: Editing) throws
}

final class AddCategoryViewModel: AddCategoryViewModelProtocol {
    private var category: String = ""
    private(set) var categories: [TrackerCategoryProtocol] = [] {
        didSet {
            onChange?(category)
        }
    }
    private lazy var categoriesManager: CategoriesManagerProtocol? = {
        configureDataManager()
    }()
    var onChange: ((String) -> Void)?
    
    init() {
        categories = fetchAllCategoriesFromStore()
    }
    
    func subscribe() {
        let _ = categoriesManager?.numberOfSectionsOfCategories
    }
    
    func deleteCategory(_ category: String) {
        try? categoriesManager?.deleteCategory(category)
    }
    
    private func configureDataManager() -> CategoriesManagerProtocol? {
        let dataStore = DataStore()
        do {
            try categoriesManager = CategoriesManager(dataStore, delegate: self)
            return categoriesManager
        } catch {
            print("error")
            return nil
        }
    }
    
    private func fetchAllCategoriesFromStore() -> [TrackerCategoryProtocol] {
        guard let categories = try? categoriesManager?.fetchAllCategories() else { return [] }
        return categories
    }
}

//MARK: - AddCategoryDelegate
extension AddCategoryViewModel: AddCategoryDelegate {
    func didRecieveCategory(_ categoryName: String, for oldCategory:String, mode: Editing) throws {
        category = categoryName
        switch mode {
        case .add:
            try categoriesManager?.addCategory(categoryName)
        case .rename:
            try categoriesManager?.renameCategory(categoryName, for: oldCategory)
        }
    }
}

//MARK: - CategoriesManagerDelegate
extension AddCategoryViewModel: CategoriesManagerDelegate {
    func didUpdate() {
        categories = fetchAllCategoriesFromStore()
    }
}
