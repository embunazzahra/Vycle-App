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
    
    
    var body: some View {
        HStack(spacing: 0){
            Image("odometer_logo_textfield")
                .resizable() // Makes the image resizable
                .scaledToFit() // Maintains the aspect ratio
                .frame(width: 18, height: 15) // Set your desired frame
                .padding(12)
            TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(Color.neutral.tone100))
//                .disabled(true) // Disables the TextField
                .foregroundColor(.black)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.neutral.tint200) // Gray background
                        
                )
            Image("KM_text_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 27,height: 22)
                .padding(12)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.neutral.tint200) // Gray background
        )
        
    }
}

//#Preview {
//    OdometerServisTextField(text: <#Binding<String>#>, placeholder: <#String#>)
//}
