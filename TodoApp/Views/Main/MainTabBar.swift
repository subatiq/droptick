//
//  MainTabBar.swift
//  TodoApp
//
//  Created by Afees Lawal on 05/08/2020.
//

import SwiftUI

struct MainTabBar: View {

    let size: CGSize

    @ObservedObject var viewRouter = MainViewRouter()
    
    @Binding var currentRoute: MainViewRouter.Route

    var onNewTaskTapped: (() -> Void)?

    var body: some View {
        HStack {
            RegularButton(text: "Add", action: {
                self.onNewTaskTapped?()
            })
        }
        .frame(width: size.width, height: size.height / 10, alignment: .bottom)
        .background(Color.backgroundColor.opacity(0.3))
    }
}

struct MainTabBar_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            MainTabBar(size: geo.size, currentRoute: .constant(.home))
        }
        .preferredColorScheme(.dark)
    }
}
