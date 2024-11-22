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
    @Binding var isOverLimit: Bool
    @State private var valueWithSeparator: String = ""

    
    
    var body: some View {
        HStack(spacing: 0){
            Image("speed_icon")
                .resizable() // Makes the image resizable
                .scaledToFit() // Maintains the aspect ratio
                .frame(width: 22, height: 22) // Set your desired frame
                .padding(.leading,12)
                .padding(.trailing,9)

            TextField("", text: $valueWithSeparator, prompt: Text(placeholder).foregroundStyle(Color.neutral.tone100))
                .keyboardType(.numberPad)
                .tint(.grayShade300)
                .focused($isInputActive)
                .disabled(!enable) // Disables the TextField
                .foregroundColor(.grayShade300)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(enable ? Color.white : Color.neutral.tint200) // Gray background
                    
                )
                .onChange(of: valueWithSeparator) { newValue in
                    // Remove non-numeric characters to get the raw value
                    let rawValue = newValue.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
                    text = rawValue  // Update the raw value without the separator
                    valueWithSeparator = rawValue.thousandSeparatorFormatting()
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
                .stroke(isOverLimit ? Color.persianRed500 : (enable ? Color.neutral.tone100 : Color.neutral.tint200), lineWidth: 1)
        )
        .onAppear {
            // Initialize the valueWithSeparator with the formatted value from `value`
            valueWithSeparator = text.thousandSeparatorFormatting()
        }
        
    }
}

//#Preview {
//    OdometerServisTextField(text: <#Binding<String>#>, placeholder: <#String#>)
//}
