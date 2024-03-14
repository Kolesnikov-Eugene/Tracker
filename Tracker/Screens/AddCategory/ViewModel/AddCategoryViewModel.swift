//
//  AddCategoryViewModel.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 11.10.2023.
//

import Foundation
import RxSwift
import RxCocoa

protocol AddCategoryDelegate: AnyObject {
    func didRecieveCategory(_ categoryName: String, for oldCategory: String, mode: Editing) throws
}

final class AddCategoryViewModel: AddCategoryViewModelProtocol {
    //MARK: - public properties
    var categoriesList = BehaviorRelay<[TrackerCategoryProtocol]>(value: [])
    var hideEmptyState: Driver<Bool>?
    var category: String

    //MARK: - private properties
    private (set) var categories: [TrackerCategoryProtocol] = []
    private lazy var categoriesManager: CategoriesManagerProtocol? = {
        configureDataManager()
    }()
    
    //MARK: - init
    init(_ category: String) {
        self.category = category
        categories = fetchAllCategoriesFromStore()
        categoriesList.accept(categories)
        
        hideEmptyState = categoriesList
                    .map({ items in
                        return !items.isEmpty
                    })
                    .asDriver(onErrorJustReturn: false)
    }
    
    //MARK: - public methods
    func subscribe() {
        let _ = categoriesManager?.numberOfSectionsOfCategories
    }
    
    func removeCategory() {
        category = ""
    }
    
    func deleteCategory(_ category: String) {
        try? categoriesManager?.deleteCategory(category)
    }
    
    //MARK: - private methods
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
    func didRecieveCategory(_ categoryName: String, for oldCategory: String, mode: Editing) throws {
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
        categoriesList.accept(categories)
    }
}
