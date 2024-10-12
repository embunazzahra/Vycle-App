//
//  OdometerInput.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 10/10/24.
//

import SwiftUI
import Combine

struct OdometerModifier: ViewModifier {
    
    @Binding var field: String
    
    var textLimit = 1

    func limitText(_ upper: Int) {
        if field.count > upper {
            self.field = String(field.prefix(upper))
        }
    }
    
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .onReceive(Just(field)) { _ in limitText(textLimit) }
            .padding(.top,4)
            .frame(width: 32, height: 44)
            .font(.custom("Technology-Bold", size: 32))
            .foregroundStyle(Color.neutral.shade300)
            .background(Color.white.cornerRadius(8))
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.neutral.shade300, lineWidth: 2)
            )
    }
}

struct OdometerInput: View {
    @FocusState private var fieldFocusState: Bool
    @State var fieldOne: String = ""
    @State var fieldTwo: String = ""
    @State var fieldThree: String = ""
    @State var fieldFour: String = ""
    @State var fieldFive: String = ""
    @State var fieldSix: String = "" // The input field
    
    // Helper to manage all fields
    private var allFields: [Binding<String>] {
        [$fieldOne, $fieldTwo, $fieldThree, $fieldFour, $fieldFive, $fieldSix]
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 2) {
                // Display the text fields (read-only for fields 1-5)
                ForEach(0..<5) { index in
                    TextField("", text: allFields[index])
                        .modifier(OdometerModifier(field: allFields[index]))
                        .disabled(true)
                }
                
                // Sixth field for input
                TextField("", text: $fieldSix)
                    .modifier(OdometerModifier(field: $fieldSix))
                    .focused($fieldFocusState)
                    .onChange(of: fieldSix) { newVal in
                        handleInputChange(newVal)
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                fieldFocusState = false
                            }
                        }
                    }
            }
            .padding(.vertical)
            .onTapGesture {
                fieldFocusState = true
            }
        }
    }
    
    // Function to handle digit entry and deletion
    private func handleInputChange(_ newValue: String) {
        if newValue.count > 1 {
            if !areAllFieldsFilled() {
                // Move all digits left when a new digit is added
                shiftLeftAndInsertLastDigit(newValue)
            } else {
                // If all fields are filled, don't allow overwriting the sixth field
                fieldSix = String(newValue.first!)
            }
        } else if newValue.isEmpty {
            // Shift all digits to the right when the last digit is deleted
            shiftRightOnDeletion()
        }
    }
    
    // Check if all fields are filled
    private func areAllFieldsFilled() -> Bool {
        return allFields.prefix(5).allSatisfy { !$0.wrappedValue.isEmpty }
    }
    
    // Shift all digits left and insert the last digit in the sixth field
    private func shiftLeftAndInsertLastDigit(_ newValue: String) {
        for i in 0..<5 {
            allFields[i].wrappedValue = allFields[i + 1].wrappedValue
        }
        fieldSix = String(newValue.last!) // Keep the last entered digit in the sixth field
    }
    
    // Shift all digits to the right when a digit is deleted
    private func shiftRightOnDeletion() {
        for i in (1...5).reversed() {
            allFields[i].wrappedValue = allFields[i - 1].wrappedValue
        }
        allFields[0].wrappedValue = "" // Clear the first field
    }
}


#Preview {
    OdometerInput()
}

