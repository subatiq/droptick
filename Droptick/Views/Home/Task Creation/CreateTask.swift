//
//  CreateTask.swift
//  Droptick
//
//  Created by Владимир Семенов on 11/12/22.
//

import SwiftUI


struct CreateTask: View {
    @Binding var currentRoute: Route
    @ObservedObject var timeTracker: TimeTrackerViewModel
    
    @State private var name: String = ""
    @State private var duration: Int = 0
    @State private var durationEntered: Bool = false
    @State private var nameEntered: Bool = false
    
    @FocusState private var nameInputFocused: Bool

    var body: some View {
        VStack {
            Spacer()
            
            if !nameEntered {
                Text("What have you done?")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color.gray)
            }
            TextField(
                "",
                text: $name
            )
            .multilineTextAlignment(.center)
            .font(.system(size: 30, weight: .black))
            .focused($nameInputFocused)
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
            .background(nameEntered ? .clear : .gray.opacity(0.12))
            .cornerRadius(15)
            .frame(height: 60)
            .onSubmit {
                nameEntered = true
            }
            
            if nameEntered {
                if !durationEntered {
                    Text("How long did it take?")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color.gray)
                }
                HourAndMinutesField(minutes: $duration, completed: $durationEntered)
            }
            Spacer()
            HStack {
                Button() {
                    currentRoute = Route.home
                    UIApplication.shared
                        .sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                }
                label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                        .frame(width: 60, height: 60)
                }
                .background(.gray.opacity(0.12))
                .cornerRadius(20)
                
                if nameEntered && (duration > 0 || (timeTracker.getTotalTimeUntracked() / 60) > 0) {
                    Button()
                    {
                        timeTracker.addTask(name: name, duration: canCreateTask() ? duration : timeTracker.getTotalTimeUntracked() / 60)
                        currentRoute = .home
                    }
                    label: {
                        Text("Spend \(canCreateTask() ? formatToHoursAndMinutes(totalSeconds: duration * 60) : formatToHoursAndMinutes(totalSeconds: timeTracker.getTotalTimeUntracked()))".uppercased())
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(AddTaskButton())
                }
            }
        }
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        .onAppear {
            nameInputFocused = true
        }
    }
    
    func canCreateTask() -> Bool {
        return self.nameEntered && self.durationEntered
    }
}
