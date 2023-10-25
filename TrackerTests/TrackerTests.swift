//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Eugene Kolesnikov on 24.10.2023.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testViewController() {
        let vc = HomeViewController()
//        vc.view.backgroundColor = .black //uncomment to fail test
        assertSnapshot(matching: vc, as: .image)
    }
}
