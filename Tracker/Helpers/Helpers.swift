//
//  Helpers.swift
//  Tracker
//
//  Created by Eugene Kolesnikov on 06.09.2023.
//

import UIKit

let colorList: [UIColor] = [
    UIColor(red: 0.99, green: 0.3, blue: 0.29, alpha: 1),
    UIColor(red: 1, green: 0.53, blue: 0.12, alpha: 1),
    UIColor(red: 0, green: 0.48, blue: 0.98, alpha: 1),
    UIColor(red: 0.43, green: 0.27, blue: 1, alpha: 1),
    UIColor(red: 0.2, green: 0.81, blue: 0.41, alpha: 1),
    UIColor(red: 0.9, green: 0.43, blue: 0.83, alpha: 1),
    UIColor(red: 0.98, green: 0.83, blue: 0.83, alpha: 1),
    UIColor(red: 0.2, green: 0.65, blue: 1, alpha: 1),
    UIColor(red: 0.27, green: 0.9, blue: 0.62, alpha: 1),
    UIColor(red: 0.21, green: 0.2, blue: 0.49, alpha: 1),
    UIColor(red: 1, green: 0.4, blue: 0.3, alpha: 1),
    UIColor(red: 1, green: 0.6, blue: 0.8, alpha: 1),
    UIColor(red: 0.96, green: 0.77, blue: 0.55, alpha: 1),
    UIColor(red: 0.47, green: 0.58, blue: 0.96, alpha: 1),
    UIColor(red: 0.51, green: 0.17, blue: 0.95, alpha: 1),
    UIColor(red: 0.68, green: 0.34, blue: 0.85, alpha: 1),
    UIColor(red: 0.55, green: 0.45, blue: 0.9, alpha: 1),
    UIColor(red: 0.18, green: 0.82, blue: 0.35, alpha: 1)
]

let emojiArray = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]

let firstOnboardingViewControllerName = "onboarding_first"
let secondOnboardingViewControllerName = "onboarding_second"

let firstOnboardingScreenDescription = "Отслеживайте только то, что хотите"
let secondOnboardingScreenDescription = "Даже если это не литры воды и йога"

let appLaunchedFirstTimeKey = "firstTimeKey"

let addCategoryEmptyStateText =
"""
Привычки и события можно
объединить по смыслу
"""

let alertMessage = "Уверены что хотите удалить трекер?"
let categoryDeletionMessage = "Эта категория точно не нужна?"
let alertDeleteButtonText = "Удалить"
let alertCancelButtonText = "Отменить"

let trackerEditingViewText = "Редактирование привычки"
let pinnedCategoryText = "Закрепленные"
let pinContextMenuLabel = "Закрепить"
let unpinContextMenuLabel = "Открепить"

//HomeView labels
let trackersLabelMainText = NSLocalizedString("homeView.title", comment: "")
let searchFieldLabel = NSLocalizedString("searchField.text", comment: "")
let trackersTabBarLabel = NSLocalizedString("trackersTabBar.text", comment: "")
let statisticTabBarLabel = NSLocalizedString("statisticTabBar.text", comment: "")
let searchFieldCancelButton = NSLocalizedString("searchFieldCancelButton.text", comment: "")
let filterButtonText = NSLocalizedString("filterButton.text", comment: "")
let trackersEmpryStateText = NSLocalizedString("trackersEmptyState.text", comment: "")
let EmptySearchResultText = NSLocalizedString("emptySearchResult.text", comment: "")

//Statistics screen
let statisticsMainLabel = NSLocalizedString("statisticsMainLabel.text", comment: "")
let emptyStatisticsLabel = NSLocalizedString("emptyStatisticsLabel.text", comment: "")
