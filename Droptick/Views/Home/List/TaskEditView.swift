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
            VStack(alignment: .leading) {
                Text(task.name)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 30, weight: .black))
                    .padding(.bottom, 15)
                HStack {
                    VStack(alignment: .leading) {
                        Text("Total spent".uppercased())
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.gray)
                        Text(formatToHoursAndMinutes(totalSeconds: task.duration * 60))
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 40, weight: .black))
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("% of the day".uppercased())
                            .multilineTextAlignment(.trailing)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.gray)
                        Text("\(task.duration * 100 / 1440)%")
                            .multilineTextAlignment(.trailing)
                            .font(.system(size: 40, weight: .black))
                    }
                }
                
            }
            .padding(20)
            Divider()
            
            Text("Edit records")
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
