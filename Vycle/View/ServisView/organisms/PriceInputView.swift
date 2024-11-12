//
//  PriceInputView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 12/11/24.
//

import SwiftUI

struct PriceInputView: View {
    @Binding var value: String
    @FocusState var isInputActive: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Total Biaya Servis")
                .font(.headline)
            
            HStack(spacing: 0){
                Image("Rp_icon")
                    .resizable()            .scaledToFit()
                    .frame(width: 22, height: 22)
                    .padding(.leading,12)
                    .padding(.trailing,9)
                TextField("", text: $value, prompt: Text("10.000").foregroundStyle(Color.neutral.tone100))
                    .keyboardType(.numberPad)
                    .tint(.grayShade300)
                    .focused($isInputActive)
                    .foregroundColor(.grayShade300)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill( Color.white ) // Gray background
                        
                    )
                Image("KM_text_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 27,height: 22)
                    .padding(12)
                    .opacity(0)
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill( Color.white ) // Gray background
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke( Color.neutral.tone100, lineWidth: 1)
            )
                
        }
    }
}

//#Preview {
//    PriceInputView(value: <#Binding<String>#>)
//}
