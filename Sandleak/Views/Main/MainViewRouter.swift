//
//  MainViewRouter.swift
//  TodoApp
//
//  Created by Afees Lawal on 04/08/2020.
//

import SwiftUI

class MainViewRouter: ObservableObject {

    enum Route {
        case home
        case newTask
    }

    @Published var currentRoutes: Route = .home
}
