//
//  Todo.swift
//  TodoApp
//
//  Created by Afees Lawal on 05/08/2020.
//

import Foundation

struct Todo {
    var id = UUID()
    let title: String
    let duration: Int
    var createdAt: Date
    var isCompleted = false
}

extension Todo: Comparable {
    static func < (lhs: Todo, rhs: Todo) -> Bool {
        return lhs.duration < rhs.duration
    }
}
