//
//  TodoMO+Extension.swift
//  TodoApp
//
//  Created by Afees Lawal on 05/08/2020.
//

import Foundation

extension TodoMO {
    func todoModel() -> Todo {
        Todo(
            id: uuid ?? UUID(),
            title: title ?? "Unknown",
            duration: duration,
            isCompleted: isCompleted
        )
    }
}
