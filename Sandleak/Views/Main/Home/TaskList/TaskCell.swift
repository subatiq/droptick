//
//  TaskCell.swift
//  TodoApp
//
//  Created by Afees Lawal on 06/08/2020.
//

import SwiftUI

struct TaskCell: View {

    let todo: Todo

    var onToggleCompletedTask: (() -> Void)?
    var onToggleSetReminder: (() -> Void)?

    var body: some View {
            HStack(alignment: .center) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(todo.title)
                            .strikethrough(todo.isCompleted)
                            .font(.system(size: 16 , weight: .bold))
                            .opacity(0.75)
                    }

                    Spacer()

                    VStack(alignment: .trailing) {
                        HStack {
                            Image(systemName: "hourglass.bottomhalf.filled")
                                .font(.system(size: 14, weight: .bold))
                            VStack {
                                Text(String(format: "%d m", todo.duration))
                                Text(String(format: "(%d%%)", Int(todo.duration * 100 / 1440)))
                                    .opacity(0.8)
                                    .font(.system(size: 14, weight: .bold))
                            }
                        }
                        .foregroundColor(.accent)
                        .font(.system(size: 16, weight: .bold))
                    }
            }
            .frame(height: 60)
        }
        .cornerRadius(10)
        
    }
}

struct TaskCell_Previews: PreviewProvider {
    static var previews: some View {
        TaskCell(todo: MockDataManager.shared.sampleTodo)
            .preferredColorScheme(.dark)
    }
}
