//
//  CreateTask.swift
//  Droptick
//
//  Created by Владимир Семенов on 11/12/22.
//

import SwiftUI


struct EditTask: View {
    @ObservedObject var timeTracker: TimeTrackerViewModel
    let task: TaskDisplay
    
    @State private var name: String
    @State private var duration: Int
    
    init(task: TaskDisplay, timeTracker: TimeTrackerViewModel) {
        self.task = task
        self._name = State(wrappedValue: self.task.name)
        self._duration = State(wrappedValue: self.task.duration)
        self.timeTracker = timeTracker
    }

    var body: some View {
        VStack {
//            HStack {
//                Spacer()
//                Button() {
//                    print("Delete")
//                }
//                label: {
//                    Image(systemName: "trash.fill")
//                        .foregroundColor(.accentColor)
//                        .frame(width: 60, height: 60)
//                }
//                .background(Color.accentColor.opacity(0.1))
//                .cornerRadius(20)
//            }
//            Spacer()
//            TextField(
//                name,
//                text: $name
//            )
//            .multilineTextAlignment(.center)
//            .font(.system(size: 25, weight: .bold))
//            .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
//            .background(.clear)
//            .cornerRadius(15)
//            .frame(height: 60)
//            HourAndMinutesField(minutes: $duration, completed: .constant(false), focusOnAppearance: false)
//            Spacer()
            
            Text("Edit \(task.name) records")
                .font(.system(size: 22, weight: .bold))
                .padding(.top, 20)
            FullEditTaskListView(task: self.task, timeTracker: timeTracker)
            
        }
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
    }
}


struct FullEditTaskListView: View {
    let task: TaskDisplay
    var timeTracker: TimeTrackerViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(self.timeTracker.getAllTasks(for: self.task.updatedAt).filter({$0.name == self.task.name}), id: \.publicID) {fullTask in
                    FullTaskCell(task: fullTask) {
                        timeTracker.delete(task: fullTask)
                    }
                }
                    
                }
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        }
    }
