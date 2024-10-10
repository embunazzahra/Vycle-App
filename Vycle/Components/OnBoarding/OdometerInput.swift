//
//  OdometerInput.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 10/10/24.
//

import SwiftUI
import Combine

struct OdometerInput: View {
    @State private var digits: [String] = Array(repeating: "", count: 6)
    @FocusState private var focusedField: Int?

    // Computed property to check if all boxes are filled
    var isInputComplete: Bool {
       return digits.allSatisfy { $0.count == 1 }
    }

    var body: some View {
       HStack(spacing: 10) {
           ForEach(0..<6, id: \.self) { index in
               TextField("", text: Binding(
                   get: {
                       self.digits[index]
                   },
                   set: { newValue in
                       // Allow input only if it's a valid digit and the length is <= 1
                       if newValue.count <= 1 && newValue.allSatisfy({ $0.isNumber }) {
                           self.digits[index] = newValue
                           
                           // Automatically move to the next field if this field is filled
                           if newValue.count == 1 {
                               if index < 5 {
                                   focusedField = index + 1
                               }
                           }
                       }
                   }
               ))
               .frame(width: 40, height: 50)
               .multilineTextAlignment(.center)
               .keyboardType(.numberPad)
               .textFieldStyle(RoundedBorderTextFieldStyle())
               .focused($focusedField, equals: index)  // Bind the field focus
           }
       }
       .padding()
       .toolbar {
           // Add a "Done" button to the number pad
           ToolbarItemGroup(placement: .keyboard) {
               Spacer()
               Button("Done") {
                   // Dismiss the keyboard
                   focusedField = nil
               }
           }
       }
       .onAppear {
           // Set focus to the first field when the view appears
           focusedField = 0
       }
    }
}

#Preview {
    OdometerInput()
}
