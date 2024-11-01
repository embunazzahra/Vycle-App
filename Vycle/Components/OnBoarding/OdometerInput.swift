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
            .padding(.top,4)
            .frame(width: 32, height: 44)
            .font(.custom("Technology-Bold", size: 32))
            .foregroundStyle(Color.neutral.shade300)
            .background(Color.white.cornerRadius(8))
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.neutral.shade300, lineWidth: 2)
            )
            .onReceive(Just(field)) { _ in limitText(textLimit) }
    }
}

struct OdometerInput: View {
    @Binding var odometer: Float?
    @FocusState private var fieldFocusState: Bool
    @State var fieldOne: String = ""
    @State var fieldTwo: String = ""
    @State var fieldThree: String = ""
    @State var fieldFour: String = ""
    @State var fieldFive: String = ""
    @State var fieldSix: String = ""
    
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
                        handleInputChange(newVal) // Handle the input change
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                fieldFocusState = false
                            }.tint(Color.primary.base)
                        }
                    }
            }
            .onTapGesture {
                fieldFocusState = true
            }
            .onAppear(){
                updateFieldsFromOdometer(odometer)
            }
        }
    }
    
    // Function to handle digit entry and deletion
    private func handleInputChange(_ newValue: String) {
        print(newValue)
        guard !newValue.isEmpty else {
            // Shift all digits to the right when the last digit is deleted
            updateOdometer()
            shiftRightOnDeletion()
            if fieldSix.isEmpty {
                odometer = nil
            }
            return
        }
        
        if newValue.count > 1 {
            if !areAllFieldsFilled() {
                
                shiftLeftAndInsertLastDigit(String(newValue.last!)) // Use only the last entered digit
                // Move all digits left when a new digit is added
                updateOdometer()
            } else {
                // If all fields are filled, don't allow overwriting the sixth field
                fieldSix = String(newValue.first!)
            }
        }
        if newValue.count == 1 && fieldFive.isEmpty {
            updateOdometer()
        }
    }
    
    // Check if all fields are filled
    private func areAllFieldsFilled() -> Bool {
        return allFields.prefix(5).allSatisfy { !$0.wrappedValue.isEmpty }
    }
    
    // Shift all digits left and insert the last digit in the sixth field
    private func shiftLeftAndInsertLastDigit(_ lastDigit: String) {
        for i in 0..<5 {
            allFields[i].wrappedValue = allFields[i + 1].wrappedValue
        }
        fieldSix = lastDigit // Set the last entered digit into the sixth field
    }
    
    // Shift all digits to the right when a digit is deleted
    private func shiftRightOnDeletion() {
        for i in (1...5).reversed() {
            allFields[i].wrappedValue = allFields[i - 1].wrappedValue
        }
        allFields[0].wrappedValue = "" // Clear the first field
    }
    
    // Function to update the odometer from field values
    private func updateOdometer() {
        let odometerString = allFields.prefix(5).map { $0.wrappedValue }.joined() + fieldSix
        print("odometer string: \(odometerString)")
        if !odometerString.isEmpty {
            odometer = Float(odometerString)
            print("odometer float: \(odometer)")
        }
    }
    
    private func updateFieldsFromOdometer(_ newValue: Float?) {
        guard let newValue = newValue else {
            // If there's no value, clear all fields
            allFields.forEach { $0.wrappedValue = "" }
            return
        }

        // Convert the float to a string without scientific notation, and format with no decimals
        let odometerString = String(format: "%.0f", newValue)
        let count = odometerString.count

        // Ensure we don't exceed 6 digits
        guard count <= 6 else {
            print("Odometer value exceeds field limit.")
            return
        }

        for index in 0..<6 {
            if index < 6 - count {
                // For leading empty fields
                allFields[index].wrappedValue = ""
            } else {
                // Set the actual digits in the remaining fields
                let digitIndex = index - (6 - count) // Calculate the index for digits
                if digitIndex < count {
                    let character = odometerString[odometerString.index(odometerString.startIndex, offsetBy: digitIndex)]
                    allFields[index].wrappedValue = String(character)
                }
            }
        }
    }
}



//#Preview {
//    OdometerInput()
//}

