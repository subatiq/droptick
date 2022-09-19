//
//  Bookmark.swift
//  Sandleak
//
//  Created by Владимир Семенов on 17.09.2022.
//

import SwiftUI
import Foundation


struct BookmarkButton: View {
    @State var tapped: Bool = false
    let action: () -> Void
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(width: 60, height: 60)
                .foregroundColor(.red.opacity(0.2))
                .scaleEffect(tapped ? 2 : 1)
                .opacity(tapped ? 1 : 0)
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(width: 60, height: 60)
                .foregroundColor(tapped ? .red : .gray.opacity(0.3))
            Image(systemName: tapped ? "bookmark.fill" : "bookmark")
                .font(.system(size: 22, weight: .bold))
                .opacity(0.8)
        }
        .scaleEffect(tapped ? 1.1 : 1)
        .animation(.spring(response: 0.4, dampingFraction: 0.9))
        .onTapGesture {
            action()
            tapped = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                tapped = false
            }
            
        }

    }
}

struct BookmarkButton_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkButton(action: {})
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
