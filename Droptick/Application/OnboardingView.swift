//
//  OnboardingView.swift
//  TodoApp
//
//  Created by Afees Lawal on 04/08/2020.
//

import SwiftUI

struct OnboardingView: View {

    @Binding var getStartedTapped: Bool

    var body: some View {
        GeometryReader { geo in
            VStack{
                Spacer()

                Spacer()

                Text("Droptick")
                    .font(.system(size: 36, weight: .medium))
//                    .foregroundColor(.primaryTextColor)

                Text("Time tracking redesigned for humans")                   .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.top, 2)

                Spacer()

                Button(action: {
                    self.getStartedTapped.toggle()
                    UserDefaults.standard.set(true, forKey: "firstTimeLogin")
                }){
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .frame(height: 60)
                        Text("Start tracking")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50, alignment: .center)
                .foregroundColor(.red)

                Spacer()

            }
            .padding(.init(top: 0, leading: 30, bottom: 0, trailing: 30))
            .edgesIgnoringSafeArea(.bottom)

        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color.backgroundColor)
        .edgesIgnoringSafeArea(.all)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(getStartedTapped: .constant(true))
            .previewLayout(.device)
            .preferredColorScheme(.light)
    }
}
