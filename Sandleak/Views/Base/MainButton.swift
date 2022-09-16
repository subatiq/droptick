//
//  TaskCell.swift
//  TodoApp
//
//  Created by Afees Lawal on 06/08/2020.
//

import SwiftUI

struct MainButton: View {
    @State var text: String
    @State var currentRoute: MainViewRouter.Route = .home
    @Binding var routeController: MainViewRouter.Route
    let action: (() -> Void)
    @State private var tapped = false
    @State private var labelDisplayed = true
    @State var currentWidth: CGFloat = .infinity

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .foregroundColor(.yellow.opacity(0.2))
                .scaleEffect(tapped ? 1.5 : 1)
                .opacity(tapped ? 1 : 0)
                .frame(width: currentWidth, height: 60)
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .foregroundColor(getBackgroundColor(route: currentRoute))
                .frame(width: currentWidth, height: 60)
            VStack {
                if labelDisplayed {
                    if (currentRoute == .home) {
                        Text(text.uppercased())
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black.opacity(labelDisplayed ? 0.9 : 0))
                            
                    }
                    else if (currentRoute == .newTask) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.gray.opacity(0.3))
                            
                    }
                }
            }
            .animation(nil, value: UUID())
        }
        .scaleEffect(tapped ? 1.1 : 1)
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                tapped = true
                labelDisplayed = false
                if currentRoute == .home {
                    currentRoute = .newTask
                }
                else if currentRoute == .newTask {
                    currentRoute = .home
                }
                
                routeController = currentRoute
                
                currentWidth = getWidth(route: currentRoute)
            }
            

            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                tapped = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                labelDisplayed = true
            }
            
        }
        
    }
    func getWidth(route: MainViewRouter.Route) -> CGFloat {
        switch route {
            case .home:
                return .infinity
            case .newTask:
                return 60
        }
    }
    
    func getBackgroundColor(route: MainViewRouter.Route) -> Color {
        switch route {
            case .home:
                if tapped {
                    return .white
                }
                else {
                    return .accent.opacity(tapped ? 0.9 : 1)
                }
            case .newTask:
                return .gray.opacity(0.05)
            
        }
    }
}

struct MainButton_Previews: PreviewProvider {
    static var previews: some View {
        MainButton(text: "Test", routeController: .constant(.home), action: {})
    }
}
