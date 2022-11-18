//
//  TaskLifecycleTests.swift
//  DroptickTests
//
//  Created by Владимир Семенов on 11/17/22.
//

import XCTest
@testable import Droptick

final class TaskLifecycleTests: XCTestCase {
    func testTaskCreatesWithEnteredNameAndDuration() {
        struct TestCase {
            let name: String
            let duration: Int
        }

        let cases = [
            TestCase(name: "Test", duration: 10),
            TestCase(name: "Тест кириллицы", duration: 1000000),
            TestCase(name: "a", duration: 1)
        ]
        
        
        let repo = FakeTimeTrackerRepository()
        let viewModel = TimeTrackerViewModel(model: TimeTracker(), repo: repo)
        
        for testcase in cases {
            viewModel.addTask(name: testcase.name, duration: testcase.duration)
            
            let lastAdded = viewModel.getSimpleDisplayTasksList()[0]
            XCTAssertEqual(lastAdded.name, testcase.name)
            XCTAssertEqual(lastAdded.duration, testcase.duration)
        }
    }
}
