//
//  NewTaskViewModel.swift
//  TodoApp
//
//  Created by Afees Lawal on 10/08/2020.
//

import Foundation

protocol NewTaskViewModelProtocol {
    func addNewTask(todo: Todo)
    func todos() -> [Todo]
}

final class NewTaskViewModel: ObservableObject {

    let dataManager: DataManager

    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
}

extension NewTaskViewModel: NewTaskViewModelProtocol {
    func addNewTask(todo: Todo) {
        dataManager.add(todo: todo)
    }
    
    func updateTask(todo: Todo) {
        let originalTodo = todos().first{$0.title == todo.title}
        print("HERE", originalTodo)
        if originalTodo == nil {
            addNewTask(todo: todo)
        }
        else {
            dataManager.update(todo: todo, originalTodo: originalTodo!)
        }
    }
    
    func todos() -> [Todo] {
        return dataManager.fetchTodoList().sorted(by: {$0.createdAt > $1.createdAt})
    }
    
    
}
