//
//  OdometerServisTextField.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 09/10/24.
//

import SwiftUI

struct OdometerServisTextField: View {
    @Binding var text: String
    var placeholder: String
    var enable: Bool = true
    @FocusState var isInputActive: Bool
    
    
    var body: some View {
        HStack(spacing: 0){
            Image("odometer_logo_textfield")
                .resizable() // Makes the image resizable
                .scaledToFit() // Maintains the aspect ratio
                .frame(width: 18, height: 15) // Set your desired frame
                .padding(12)
            TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(Color.neutral.tone100))
                .keyboardType(.numberPad)
                .tint(.grayShade300)
                .focused($isInputActive)
                .disabled(!enable) // Disables the TextField
                .foregroundColor(.grayShade300)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(enable ? Color.white : Color.neutral.tint200) // Gray background
                    
                )
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        
                        Button(action: {
                            isInputActive = false // Dismiss the keyboard
                        }) {
                            Text("Done")
                                .foregroundStyle(Color.primary.base) // Change the button color here
                        }
                        
                    }
                }
            Image("KM_text_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 27,height: 22)
                .padding(12)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(enable ? Color.white : Color.neutral.tint200) // Gray background
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(enable ? Color.neutral.tone100 : Color.neutral.tint200, lineWidth: 1) // Adds a border around the view
        )
        
    }
}

//#Preview {
//    OdometerServisTextField(text: <#Binding<String>#>, placeholder: <#String#>)
//}
