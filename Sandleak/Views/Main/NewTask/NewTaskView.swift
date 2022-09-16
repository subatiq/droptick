//
//  NewTaskView.swift
//  TodoApp
//
//  Created by Afees Lawal on 09/08/2020.
//

import SwiftUI


enum CreationStep {
    case TITLE, DURATION
}

class TaskCreationStep: ObservableObject {
    @Published var currentStep: Int = 0
    let maxStep: Int
    
    init(maxStep: Int = 2) {
        self.maxStep = maxStep
    }
    
    func increment() {
        if self.currentStep < self.maxStep {
            self.currentStep += 1
        }
    }
    
    func isCompleted() -> Bool {
        return self.currentStep >= self.maxStep - 1
    }
}

struct NewTaskView: View {

    @Environment(\.presentationMode) private var presentationMode
    
    let onComplete: (() -> Void)

    @ObservedObject var viewModel: NewTaskViewModel
    @ObservedObject var creationStep = TaskCreationStep(maxStep: 2)
    @ObservedObject private var textFieldManager = TextFieldManager(characterLimit: 50)
    @ObservedObject private var costPickerManager = DurationPickerManager()
    
    @State private var nameEntered = false
    
    var canCreateTask: Bool {
        return costPickerManager.userInput > 0 && textFieldManager.userInput.count > 0 && nameEntered
    }

    var body: some View {
        VStack {
            Spacer()
            
            VStack(alignment: .leading) {
                VStack {
                    TaskTitleView(userInput: $textFieldManager.userInput, duration: .constant(0), submitted: $nameEntered)
                }
                    
                if nameEntered {
                    TaskCostView(taskTitle: textFieldManager.userInput, userInput: $costPickerManager.userInput, viewModel: viewModel)
                }
            }

            Spacer()
            
            if self.canCreateTask {
                HStack {
                    VStack {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .frame(width: 60, height: 60)
                                .foregroundColor(.gray.opacity(0.1))
                            CloseButton(action: {
                                onComplete()
                            })
                            .frame(width: 60, height: 60)
                            
                        }
                        
                    }
                    RegularButton(
                        text: "Create",
                        action: {
                            createTask()
                            onComplete()
                        })
                    
                }
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            }
            else {
                CloseButton(action: {
                    onComplete()
                })
            }
        }
        .onTapGesture {
            UIApplication.shared
                .sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        }
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
            UITableView.appearance().backgroundColor = .clear
        }
        .animation(nil, value: UUID())
    }

    func createTask() {
        let title = textFieldManager.userInput
        let duration = costPickerManager.userInput

        let todo = Todo(title: title, duration: duration, createdAt: Date.now)
        viewModel.updateTask(todo: todo)
        presentationMode.wrappedValue.dismiss()
    }
}

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskView(onComplete: {}, viewModel: NewTaskViewModel(dataManager: MockDataManager.shared))
            .preferredColorScheme(.dark)
    }
}
