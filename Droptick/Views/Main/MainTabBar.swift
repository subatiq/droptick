//
//  MainTabBar.swift
//  TodoApp
//
//  Created by Afees Lawal on 05/08/2020.
//

import SwiftUI


struct MainTabBar: View {
    @State var lastMarker: Date?
    let lastMarkerPlaceholder: String = "Mark time"
    @ObservedObject var viewRouter = MainViewRouter()
    @Binding var currentRoute: MainViewRouter.Route

    var body: some View {
        HStack(alignment: .top) {
            VStack {
                BookmarkButton(action: {
                    lastMarker = Date.now
                    UserDefaults.standard.set(lastMarker!.ISO8601Format(), forKey: "lastMark")
                })
                    .frame(width: 60, height: 60)
                Text("\(lastMarker?.formatted(date: .omitted, time: .shortened) ?? lastMarkerPlaceholder)")
                    .font(.system(size: 12))
                    .foregroundColor(.gray.opacity(lastMarker != nil ? 0.75 : 0.5))
            }
            
            VStack {
                RegularButton(text: "Track time", action: {
                    currentRoute = .newTask
                })
//                Text("*Productive means important to YOU")
//                    .font(.system(size: 12))
//                    .foregroundColor(.gray.opacity(0.5))
            }
            
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        .onAppear {
            let newFormatter = ISO8601DateFormatter()
            let stringMark = UserDefaults.standard.string(forKey: "lastMark")
            if stringMark != nil {
                lastMarker = newFormatter.date(from: stringMark!)
            }
        }
    }
}

struct MainTabBar_Previews: PreviewProvider {
    static var previews: some View {
        MainTabBar(
            lastMarker: Date.now,
            currentRoute: .constant(.home)
        )
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
        MainTabBar(
            lastMarker: nil,
            currentRoute: .constant(.home)
        )
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
        
    }
}
