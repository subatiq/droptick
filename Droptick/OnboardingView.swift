//
//  OnboardingView.swift
//  TodoApp
//
//  Created by Vladimir Semenov on 26.11.2022
//

import SwiftUI

struct OnboardingView: View {

    @Binding var getStartedTapped: Bool

    var body: some View {
        GeometryReader { geo in
            VStack{
                Spacer()
                Text("Track time with")
                    .font(.system(size: 22, weight: .bold))
                Text("Droptick")
                    .font(.system(size: 36, weight: .bold))

//                Text("Time tracking redesigned for humans")
//                    .font(.system(size: 18, weight: .bold))
////                    .foregroundColor(.gray)
//                    .opacity(0.2)
//                    .multilineTextAlignment(.center)
////                    .padding(.top, 1)

                Spacer()
                
                VStack {
                    HStack {
                        Image(systemName: "hourglass")
                            .foregroundColor(.secondary)
                            .font(.system(size: 30))
                        Text("Your timer is always running")
                            .font(.system(size: 22, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .padding(.top, 2)
                    }
                    Text("No need to keep in your head wheter you started or stopped it. Or what are you tracking right now.")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.top, 2)
                    HStack {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.secondary)
                            .font(.system(size: 30))
                        Text("Add new tasks easily")
                            .font(.system(size: 22, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .padding(.top, 2)
                    }
                        Text("All you need is enter the name and how much time you've spent. It's mostly just two taps away.")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.top, 2)
                    
                    HStack {
                        Image(systemName: "chart.xyaxis.line")
                            .foregroundColor(.secondary)
                            .font(.system(size: 30))
                        Text("Check your time usage")
                            .font(.system(size: 22, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .padding(.top, 2)
                    }
                    Text("Clean and simple statistics view will help you to monitor your activity.")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.top, 2)
                }
                
                

                Spacer()

                Button(action: {
                    self.getStartedTapped.toggle()
                    UserDefaults.standard.set(true, forKey: "firstTimeLogin")
                }){
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .frame(height: 60)
                        Text("Start tracking".uppercased())
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .frame(minWidth: 0, minHeight: 0, maxHeight: 50, alignment: .center)
                .foregroundColor(.secondary)

                Spacer()

            }
            .padding(.init(top: 0, leading: 30, bottom: 0, trailing: 30))
            .edgesIgnoringSafeArea(.bottom)

        }.frame(minWidth: 0, minHeight: 0)
//            .background(Color.backgroundColor)
        .edgesIgnoringSafeArea(.all)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(getStartedTapped: .constant(true))
//            .previewLayout(.device)
            .preferredColorScheme(.dark)
    }
}

