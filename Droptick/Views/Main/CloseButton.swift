//
//  TaskCell.swift
//  TodoApp
//
//  Created by Afees Lawal on 06/08/2020.
//

import SwiftUI

struct CloseButton: View {

//    let todo: Todo
    let action: (() -> Void)
    @State private var tapped = false

//    var onToggleCompletedTask: (() -> Void)?
//    var onToggleSetReminder: (() -> Void)?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .opacity(0)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                .frame(height: 60)
            Image(systemName: "xmark")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.gray.opacity(0.3))
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

struct CloseButton_Previews: PreviewProvider {
    static var previews: some View {
        CloseButton(action: {})
//            .preferredColorScheme(.dark)
    }
}
