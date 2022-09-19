//
//  MockDataManager.swift
//  TodoApp
//
//  Created by Afees Lawal on 06/08/2020.
//

import Foundation
import Combine

class MockDataManager: DataManager {
    var onUpdate: (() -> Void)?

    let  objectWillChange = PassthroughSubject<(), Never>()

    static let shared = MockDataManager()

    var todos: [Todo]

    var sampleCheckedTodo: Todo {
        return fetchTodoList().filter { $0.isCompleted }.randomElement() ?? fetchTodoList()[0]
    }

    var sampleTodo: Todo {
        return fetchTodoList().filter { !$0.isCompleted }.randomElement() ?? fetchTodoList()[0]
    }

    init() {
        todos = [
            Todo(id: UUID(), title: "Good day", duration: 100, createdAt: .now, isCompleted: false),
            Todo(id: UUID(), title: "Fetch water from well", duration: 100, createdAt: .now, isCompleted: false),
            Todo(id: UUID(), title: "Go outside", duration: 100, createdAt: .now, isCompleted: false),
            Todo(id: UUID(), title: "Morning workout", duration: 100, createdAt: .now, isCompleted: false),
            Todo(id: UUID(), title: "Sign documents", duration: 100, createdAt: .now, isCompleted: false),
            Todo(id: UUID(), title: "Check email", duration: 100, createdAt: .now, isCompleted: true),
        ]
    }

    func fetchTodoList() -> [Todo] {
        todos
    }

    func add(todo: Todo) {
        todos.append(Todo(title: todo.title, duration: todo.duration, createdAt: .now))
        onUpdate?()
    }
    
    func update(todo: Todo, originalTodo: Todo) {
        print("NOT IMPLEMENTED")
    }

    func toggleIsCompleted(for todo: Todo) {
        if let index = todos.firstIndex(where: { $0 == todo }) {
            todos[index].isCompleted.toggle()
        }
        onUpdate?()
    }
    
    func delete(todo: Todo) {
        if let index = todos.firstIndex(where: { $0 == todo }) {
            todos.remove(at: index)
        }
        
        onUpdate?()
    }

    
}

extension String {
    static func randomString(length: Int = .random(in: 5...8)) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
