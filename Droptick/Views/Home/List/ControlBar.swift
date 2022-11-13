//
//  NewTaskBar.swift
//  Droptick
//
//  Created by Владимир Семенов on 11/12/22.
//

import SwiftUI


struct MainTabBar: View {
    @Binding var currentRoute: Route
    
    var body: some View {
        Button() {
            currentRoute = Route.newTask
        } label: {
            Text("Add task".uppercased())
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(AddTaskButton())
    }
}
