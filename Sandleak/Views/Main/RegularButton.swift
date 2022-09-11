//
//  TaskCell.swift
//  TodoApp
//
//  Created by Afees Lawal on 06/08/2020.
//

import SwiftUI

struct RegularButton: View {

//    let todo: Todo
    let text: String
    let action: (() -> Void)
    @State private var tapped = false

//    var onToggleCompletedTask: (() -> Void)?
//    var onToggleSetReminder: (() -> Void)?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .foregroundColor(.yellow.opacity(tapped ? 0.9 : 1))
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                .frame(width: UIScreen.main.bounds.width, height: 60)
            Text(text.uppercased())
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black.opacity(0.9))
        }
        .scaleEffect(tapped ? 0.98 : 1)
        .animation(.spring(response: 0.4, dampingFraction: 0.6))
        .onTapGesture {
            action()
            tapped = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                tapped = false
            }
            
        }
        
    }
}

struct RegularButton_Previews: PreviewProvider {
    static var previews: some View {
        RegularButton(text: "Test", action: {})
//            .preferredColorScheme(.dark)
    }
}
