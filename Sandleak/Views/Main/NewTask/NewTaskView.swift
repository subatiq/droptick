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
//        GeometryReader { geometry in
        VStack {
            Spacer()
            
            VStack(alignment: .leading) {
                    TaskTitleView(userInput: $textFieldManager.userInput, duration: .constant(0), submitted: $nameEntered)
                if nameEntered {
                    TaskCostView(taskTitle: textFieldManager.userInput, userInput: $costPickerManager.userInput)
                }
            }

                Spacer()
                
                if self.canCreateTask {
                    RegularButton(
                        text: "Create",
                        action: {
                        createTask()
                        onComplete()
                    })

                }
                else {
                    CloseButton(action: {
                        
                        onComplete()
                    })
                }
            
//            else if creationStep.currentStep == 0 {
//                Button(Str.Main.NewTask.nextStep) {
//                    self.creationStep.increment()
//                }
//                .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
//                .foregroundColor(.white)
//                .background(Color.addTaskButtonColor.cornerRadius(5).opacity(0.9))
//            }
        }
        .background(Color.backgroundColor)
        .onTapGesture {
            UIApplication.shared
                .sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        }
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
            UITableView.appearance().backgroundColor = .clear
        }
    }

    func createTask() {
        let title = textFieldManager.userInput
        let duration = costPickerManager.userInput

        let todo = Todo(title: title, duration: duration)
        viewModel.addNewTask(todo: todo)
        presentationMode.wrappedValue.dismiss()
    }
}

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskView(onComplete: {}, viewModel: NewTaskViewModel(dataManager: MockDataManager.shared))
            .preferredColorScheme(.dark)
    }
}
