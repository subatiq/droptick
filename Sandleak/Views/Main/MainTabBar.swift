//
//  MainTabBar.swift
//  TodoApp
//
//  Created by Afees Lawal on 05/08/2020.
//

import SwiftUI

struct MainTabBar: View {

    let size: CGSize
    @State var lastMark: Date? = nil

    @ObservedObject var viewRouter = MainViewRouter()
    
    @Binding var currentRoute: MainViewRouter.Route

    var onNewTaskTapped: (() -> Void)?

    var body: some View {
        HStack{
            VStack {
                ZStack{
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.second.opacity(0.1))
                    Image(systemName: "bookmark")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.black.opacity(0.8))
                    
                }
                .onTapGesture {
                    lastMark = Date.now
                    UserDefaults.standard.set(lastMark?.ISO8601Format(), forKey: "lastMark")
                }
                if lastMark != nil {
                    Text("\(lastMark?.formatted(date: .omitted, time: .shortened) ?? String())")
                        .font(.system(size: 12))
                        .foregroundColor(.gray.opacity(0.75))
                }
            }
//            .animation(.spring(response: 0.4, dampingFraction: 0.9))
            VStack {
                RegularButton(text: "Add productive* time", action: {
                    self.onNewTaskTapped?()
                })
                Text("*Productive means important to YOU")
                    .font(.system(size: 12))
                    .foregroundColor(.gray.opacity(0.5))
            }
            
        }
        //        .frame(width: size.width, height: size.height / 10, alignment: .bottom)
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        .background(Color.backgroundColor.opacity(0.3))
        .onAppear {
            let newFormatter = ISO8601DateFormatter()
            let stringMark = UserDefaults.standard.string(forKey: "lastMark")
            if stringMark != nil {
                lastMark = newFormatter.date(from: stringMark!)
            }
        }
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
