//
//  TaskListTests.swift
//  DroptickTests
//
//  Created by Владимир Семенов on 11/16/22.
//

import XCTest
@testable import Droptick


func midnightDiff(unit: Calendar.Component, amount: Int) -> Date {
    return Calendar.current.date(
        byAdding: unit,
        value: amount,
        to: Date().startOfCurrentDay)!
}


final class TaskListTests: XCTestCase {
    func testMainListShowsOnlyTasksForToday() throws {
        struct TestCase {
            let tasks: [TimeTracker.Task]
            let expected: Int
        }

        let cases = [
            TestCase(
                tasks: [
                    TimeTracker.Task(name: "test1", duration: 10),
                    TimeTracker.Task(name: "test2", duration: 20)
                ],
                expected: 2
            ),
            TestCase(
                tasks: [
                    TimeTracker.Task(name: "test0", duration: 10, createdAt: midnightDiff(unit: .second, amount: -1)),
                    TimeTracker.Task(name: "test1", duration: 10, createdAt: midnightDiff(unit: .hour, amount: -1)),
                    TimeTracker.Task(name: "test2", duration: 20)
                ],
                expected: 1
            ),
            TestCase(
                tasks: [
                    TimeTracker.Task(name: "test0", duration: 10, createdAt: midnightDiff(unit: .hour, amount: -1)),
                    TimeTracker.Task(name: "test1", duration: 10, createdAt: midnightDiff(unit: .hour, amount: -1)),
                    TimeTracker.Task(name: "test2", duration: 20)
                ],
                expected: 1
            )
        ]
        
        
        for testcase in cases {
            let model = TimeTracker(tasks: testcase.tasks)
            let repo = FakeTimeTrackerRepository()
            repo.tasks = testcase.tasks
            let viewModel = TimeTrackerViewModel(model: model, repo: repo)

            let displayed = viewModel.getSimpleDisplayTasksList()
            
            XCTAssertEqual(displayed.count, testcase.expected)
        }
    }
    
    func testMainListShowsTasksGroupedByName() throws {
        struct TestCase {
            let tasks: [TimeTracker.Task]
            let expected_count: Int
            let expected_total_duration: Int
        }

        let cases = [
            TestCase(
                tasks: [
                    TimeTracker.Task(name: "test1", duration: 10),
                    TimeTracker.Task(name: "test2", duration: 20)
                ],
                expected_count: 2,
                expected_total_duration: 30
            ),
            TestCase(
                tasks: [
                    TimeTracker.Task(name: "test2", duration: 20),
                    TimeTracker.Task(name: "test2", duration: 20),
                    TimeTracker.Task(name: "test2", duration: 20)
                ],
                expected_count: 1,
                expected_total_duration: 60
            ),
            TestCase(
                tasks: [
                    TimeTracker.Task(name: "test0", duration: 10),
                    TimeTracker.Task(name: "test1", duration: 10),
                    TimeTracker.Task(name: "test2", duration: 20)
                ],
                expected_count: 3,
                expected_total_duration: 40
            ),
            TestCase(
                tasks: [
                    TimeTracker.Task(name: "test1 ", duration: 10),
                    TimeTracker.Task(name: "test1", duration: 10),
                    TimeTracker.Task(name: " test1  ", duration: 20)
                ],
                expected_count: 1,
                expected_total_duration: 40
            )
        ]
        
        
        for testcase in cases {
            let model = TimeTracker(tasks: testcase.tasks)
            let repo = FakeTimeTrackerRepository()
            repo.tasks = testcase.tasks
            let viewModel = TimeTrackerViewModel(model: model, repo: repo)

            let displayed = viewModel.getSimpleDisplayTasksList()
            
            XCTAssertEqual(displayed.count, testcase.expected_count)
            XCTAssertEqual(displayed.map{$0.duration}.reduce(0, +), testcase.expected_total_duration)
        }
    }
}
