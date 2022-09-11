//
//  TaskListViewModel.swift
//  TodoApp
//
//  Created by Afees Lawal on 13/08/2020.
//

import Foundation
import SwiftUI
import Combine

protocol TaskListViewModelProtocol {
    var sectionedTodos: [Todo] { get }
    func fetchTodos()
    func todos() -> [Todo]
    func totalDuration() -> Int
    func delete(todo: Todo)
    func toggleIsCompleted(for todo: Todo)
}

final class TaskListViewModel: ObservableObject, TaskListViewModelProtocol {

    @Published var sectionedTodos:  [Todo] = []

    let objectWillChange = PassthroughSubject<Void, Never>()

    var dataManager: DataManager

    init(dataManager: DataManager) {
        self.dataManager = dataManager
        fetchTodos()

        self.dataManager.onUpdate = { [weak self] in
            print(3)
            self?.objectWillChange.send()
            print(4)
        }
    }

    func fetchTodos() {
        sectionedTodos = dataManager.fetchTodoList()
    }

    func todos() -> [Todo] {
        fetchTodos()
        return sectionedTodos
    }
    
    func totalDuration() -> Int {
        fetchTodos()
        return sectionedTodos.map {Int($0.duration)}.reduce(0, +)
    }
    
    func delete(todo: Todo) {
        dataManager.delete(todo: todo)
        fetchTodos()
        
    }

    func toggleIsCompleted(for todo: Todo) {
        dataManager.toggleIsCompleted(for: todo)
        fetchTodos()
    }
}

