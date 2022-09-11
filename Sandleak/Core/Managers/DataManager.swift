//
//  DataManager.swift
//  TodoApp
//
//  Created by Afees Lawal on 05/08/2020.
//

import Foundation

protocol DataManager {
    var onUpdate: (() -> Void)? { get set }
    func fetchTodoList() -> [Todo]
    func add(todo: Todo)
    func delete(todo: Todo)
    func toggleIsCompleted(for todo: Todo)
}
