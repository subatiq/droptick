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
        ScrollView {
            VStack(spacing: 0) {
                ForEach(self.viewModel.todos(), id: \.id) { todo in
                    TaskCell(todo: todo, onToggleCompletedTask: {
                        self.viewModel.dataManager.delete(todo: todo)
                    })
                    .padding(.bottom, 2)
                }
            }
            .rotationEffect(Angle(degrees: 180))
                .background(Color.backgroundColor)
        }
        .rotationEffect(Angle(degrees: 180))
        .navigationTitle(Text(title ?? ""))
        .background(Color.backgroundColor)
        .padding(.leading, 8)
        .padding(.trailing, 8)
        .onAppear {
            self.viewModel.fetchTodos()
        }
        .onReceive(viewModel.objectWillChange) { _ in
            self.viewModel.fetchTodos()
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView(viewModel: TaskListViewModel(dataManager: MockDataManager()))
    }
}
