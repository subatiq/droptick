//
//  TaskTitleView.swift
//  TodoApp
//
//  Created by Afees Lawal on 10/08/2020.
//

import SwiftUI


class HoursAndMinutesFormatter: Formatter {
    override func string(for obj: Any?) -> String? {
        guard let string = obj as? String else { return "x" }
        
        return String(string)
    }
    
    override func getObjectValue(
        _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
        for string: String,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
     
        let value: String
        if String(string).count > 4 {
            value = String(string[...String.Index(encodedOffset: 4)])
        } else {
            value = string
        }
        obj?.pointee = value as AnyObject
        return true
    }
    
    
}


struct TaskTitleView: View {

    @Binding var userInput: String
    @Binding var duration: Int
    @Binding var submitted: Bool
    
    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    enum FocusField: Hashable {
        case title, none
      }

    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        VStack(alignment: .center) {
            if !submitted {
                Text("What have you done?")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color.gray)
                    .padding(.bottom)
            }
            TextField("", text: $userInput, onEditingChanged: { (editingChanged) in
                if editingChanged {
                    // focused
                    focusedField = .title
                    submitted = false
                } else {
                    // unfocused
                    if userInput.count > 0 {
                        submitted = true
                    }
                    focusedField = TaskTitleView.FocusField.none
                }
            })
                .frame(height: 60)
                .background(Color.gray.opacity(submitted ? 0 : 0.1).cornerRadius(20))
                .font(.system(size: 26, weight: .black))
                .focused($focusedField, equals: .title)
                .multilineTextAlignment(.center)
                .padding(.leading)
                .padding(.trailing)
                .onSubmit {
                    submitted = true
                    focusedField = TaskTitleView.FocusField.none
                }
                
            if !submitted {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(["Work", "Watch TV", "Eat", "Excercise"], id: \.self) {activity  in
                            ZStack {
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .frame(height: 40)
                                    .foregroundColor(Color.gray.opacity(0.1))
                                Text(activity)
                                    .foregroundColor(.gray.opacity(0.7))
                                    .font(.system(size: 14, weight: .semibold))
                                    .multilineTextAlignment(.center)
                                    .padding(.leading)
                                    .padding(.trailing)
                            }
                            .onTapGesture {
                                userInput = activity
                                submitted = true
                                focusedField = nil
                            }
                        }
                    }
                }
                .padding()
            }
            
        }
        .onAppear {
            self.focusedField = .title
            self.submitted = false
        }
        .onDisappear {
            self.focusedField = TaskTitleView.FocusField.none
        }
    }
}


struct TaskTitleView_Previews: PreviewProvider {
    static var previews: some View {
        TaskTitleView(userInput: .constant(""), duration: .constant(0), submitted: .constant(false))
    }
}
