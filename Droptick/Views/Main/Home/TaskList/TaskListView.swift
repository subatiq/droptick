//
//  TaskListView.swift
//  TodoApp
//
//  Created by Afees Lawal on 06/08/2020.
//

import SwiftUI


struct TaskListView: View {

    @ObservedObject var viewModel: TaskListViewModel
    var title: String? = nil

    private let generator = UINotificationFeedbackGenerator()

    var body: some View {
        List {
            ForEach(self.viewModel.todos(), id: \.id) { todo in
                TaskCell(todo: todo, onToggleCompletedTask: {
                    self.viewModel.dataManager.delete(todo: todo)
                })
            }
            .onDelete(perform: deleteTask)
        }
        
        .listStyle(PlainListStyle())
        .navigationTitle(Text(title ?? ""))
        .background(Color.backgroundColor)
        .onAppear {
            self.viewModel.fetchTodos()
        }
        .onReceive(viewModel.objectWillChange) { _ in
            self.viewModel.fetchTodos()
        }
    }
    
    func deleteTask(indexSet: IndexSet) -> Void {
        let todos = self.viewModel.todos()
        indexSet.forEach { (i) in
            let todo = todos[i]
            self.viewModel.dataManager.delete(todo: todo)
        }
        
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView(viewModel: TaskListViewModel(dataManager: MockDataManager()))
    }
}
