//
//  KilometerPicker.swift
//  Vycle
//
//  Created by Clarissa Alverina on 09/10/24.
//
import SwiftUI

struct KilometerWheelPicker: View {
    @Binding var selectedNumber: Int
    @Binding var showSheet: Bool
    @Binding var isKilometerChosen: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                showSheet.toggle()
            }) {
                Text(isKilometerChosen ? "\(selectedNumber) km" : "Atur jarak selanjutnya")
                    .subhead(.regular)
                    .padding(8)
                    .background(Color.neutral.tint200)
                    .foregroundColor(Color.neutral.shade300)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $showSheet) {
                KilometerPickerSheet(
                    selectedNumber: $selectedNumber,
                    isKilometerChosen: $isKilometerChosen
                )
                .presentationDetents([.medium])
            }
        }
        .padding()
    }
}

struct KilometerPickerSheet: View {
    @Binding var selectedNumber: Int
    @Environment(\.dismiss) var dismiss
    @Binding var isKilometerChosen: Bool
    
    private let numbers = Array(stride(from: 1000, through: 100000, by: 1000))

    var body: some View {
        VStack {
            HStack {
                Text("Kilometer")
                    .title3(.emphasized)
                    .padding(.top, 16)
                    .padding(.leading, 16)
                Spacer()
            }

            ZStack {
                Picker("Kilometer", selection: $selectedNumber) {
                    ForEach(numbers, id: \.self) { number in
                        Text("\(number) km").tag(number)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 150, height: 254)
                .clipped()

                HStack(spacing: 110) {
                    Rectangle()
                        .foregroundColor(Color.grayTint300)
                        .frame(width: 120, height: 32)
                        .cornerRadius(10)
                    Rectangle()
                        .foregroundColor(Color.grayTint300)
                        .frame(width: 120, height: 32)
                        .cornerRadius(10)
                }
            }
            
            CustomButton(title: "Pilih", buttonType: .primary) {
                isKilometerChosen = true
                dismiss()
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .onAppear {
            if selectedNumber == 0 {
                selectedNumber = numbers.first ?? 1000
            }
        }
    }
}


//struct KilometerWheelPicker: View {
//    @Binding var selectedNumber: Int
//    @Binding var showSheet: Bool
//    @Binding var isKilometerChosen: Bool
//    
//    var body: some View {
//        VStack {
//            Button(action: {
//                showSheet.toggle()
//            }) {
//                Text(isKilometerChosen ? selectedNumber.description : "Atur jarak selanjutnya")
//                    .subhead(.regular)
//                    .padding(8)
//                    .background(Color.neutral.tint200)
//                    .foregroundColor(Color.neutral.shade300)
//                    .cornerRadius(10)
//            }
//            .sheet(isPresented: $showSheet) {
//                KilometerPickerSheet(selectedNumber: $selectedNumber, isKilometerChosen: $isKilometerChosen)
//                    .presentationDetents([.medium])
//            }
//        }
//        .padding()
//    }
//}
//
//struct KilometerPickerSheet: View {
//    @Binding var selectedNumber: Int
//    @Environment(\.dismiss) var dismiss
//    @Binding var isKilometerChosen: Bool
//    
////    private let numbers = Array(stride(from: 1000, through: 100000, by: 1000))
//    
//    private let numbers = Array(stride(from: 1, through: 100, by: 1))
//    
//    var body: some View {
//        VStack {
//            HStack {
//                Text("Bulan dan tahun")
//                    .title3(.emphasized)
//                    .padding(.top, 16)
//                    .padding(.leading, 16)
//                Spacer()
//            }
//            
//            ZStack {
//                Picker("Angka", selection: $selectedNumber) {
//                    ForEach(numbers, id: \.self) { number in
//                        Text("\(number)").tag(number)
//                    }
//                }
//                .pickerStyle(.wheel)
//                .frame(width: 150, height: 254)
//                .clipped()
//                
//                HStack (spacing: 110){
//                    Rectangle()
//                        .foregroundColor(Color.grayTint300)
//                        .frame(width: 120, height: 32)
//                        .cornerRadius(10)
//                    Rectangle()
//                        .foregroundColor(Color.grayTint300)
//                        .frame(width: 120, height: 32)
//                        .cornerRadius(10)
//                }
//            }
//           
//            CustomButton(title: "Pilih", iconPosition: .left, buttonType: .primary) {
//                isKilometerChosen = true
//                dismiss()
//            }
//            .padding(.top, 10)
//            
//            Spacer()
//        }
//    }
//}

