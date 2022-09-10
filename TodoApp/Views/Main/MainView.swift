//
//  MainView.swift
//  TodoApp
//
//  Created by Afees Lawal on 04/08/2020.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

struct MainView: View {

    @State var currentRoute: MainViewRouter.Route = .home
    @State var showNewTaskView = false

    var viewModel: TaskListViewModel
    var newTaskModel: NewTaskViewModel
//    var dataManager = TodoDataManager()
    init() {
        let dataManager = TodoDataManager()
        self.viewModel = TaskListViewModel(dataManager: dataManager)
        self.newTaskModel = NewTaskViewModel(dataManager: dataManager)
    }
    

    var body: some View {
            GeometryReader { geometry in
                VStack {
                    TimeStats(viewModel: viewModel)
                    if (!showNewTaskView) {
                        HomeView(viewModel: viewModel)
                        MainTabBar(size: geometry.size, currentRoute: $currentRoute) {
                            self.showNewTaskView.toggle()
                        }
                    }
                    else {
                        NewTaskView(onComplete: {
                            showNewTaskView = false
                            hideKeyboard()
                        },
                        viewModel: newTaskModel)
                    }
                }.padding(.bottom, 20)
            }
            .background(Color.backgroundColor)
    }
    
    func updateTimeStats() -> Void {
        // FIXME: This is some stupid ass shit
//        print("DSFSDF")
//        timeStatsModel.update(dataManager: dataManager)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .preferredColorScheme(.dark)
    }
}
