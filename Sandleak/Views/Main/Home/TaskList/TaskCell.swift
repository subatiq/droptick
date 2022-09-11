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
//        GeometryReader { geometry in
            HStack(alignment: .center) {
                HStack {
//                Color.white
//                    .frame(width: 4, height: geometry.size.height)


               

                VStack(alignment: .leading, spacing: 8) {
                    Text(todo.title)
//                        .foregroundColor(todo.isCompleted ? .green : .gray)
                        
                        .strikethrough(todo.isCompleted)
                        .font(.system(size: 16 , weight: .bold))
                        .padding(.leading, 10)
                        .opacity(0.8)
                }

                Spacer()

                VStack(alignment: .trailing) {
                    HStack {
                        Image(systemName: "hourglass.bottomhalf.filled")
                            .font(.system(size: 10, weight: .bold))
                        Text("\(todo.duration)m")
                    }
                    .foregroundColor(.yellow)
                    .font(.system(size: 16, weight: .bold))
                }
                    Image(systemName: "trash")
    //                    .resizable()
                        .frame(width: 40, height: 40)
                        .font(.system(size: 30))
                        .foregroundColor(.gray.opacity(0.4))
                        .onTapGesture {
                            self.onToggleCompletedTask?()
                        }
            }
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                .frame(width: UIScreen.main.bounds.width - 20, height: 60, alignment: Alignment(horizontal: .center, vertical: .center))
        }
        
            
//        }
        .cornerRadius(10)
        .background(Color.rowColor).cornerRadius(5)
        
        
    }
}

struct TaskCell_Previews: PreviewProvider {
    static var previews: some View {
        TaskCell(todo: MockDataManager.shared.sampleTodo)
            .preferredColorScheme(.dark)
    }
}
