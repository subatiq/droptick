//
//  NoTaskView.swift
//  TodoApp
//
//  Created by Afees Lawal on 05/08/2020.
//

import SwiftUI

struct NoTaskView: View {
    var body: some View {
        VStack {
//            Image("noTask")

            Text("No completed tasks yet".uppercased())
                .multilineTextAlignment(.center)
                .foregroundColor(.gray.opacity(0.3))
                .font(.system(size: 24, weight: .black))
                .frame(width: 200, height: .infinity)

//            Text(Str.Main.Home.EmptyTask.noTasksTodo)
//                .foregroundColor(.infoColor)
//                .font(.system(size: 20))
        }
    }
}

struct NoTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NoTaskView()
    }
}
