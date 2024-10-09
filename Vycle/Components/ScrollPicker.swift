//
//  ScrollPicker.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 09/10/24.
//

import SwiftUI

struct ScrollPicker: View {
    @State private var selectedOption: String = "Pilih suku cadang"
    @State private var tempSelectedOption: String = ""
    @State private var showSheet: Bool = true
    private var options = [
        "Filter udara", "Oli mesin", "Oli Gardan",
        "Oli transmisi", "Filter Oli", "Busi",
        "Minyak rem", "Minyak Kopling", "Coolant"
    ]
    
    var body: some View {
        Button(action: {
            showSheet.toggle()
        }) {
            Text(selectedOption)
                .font(.title2)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding()
        .sheet(isPresented: $showSheet) {
            VStack (alignment: .leading) {
                Text("Bulan dan tahun")
                    .title3(.emphasized)
                    .foregroundStyle(Color.neutral.shade300)
                    .padding(.horizontal,16)
                    .padding(.vertical,14)
                
                Picker(selection: $tempSelectedOption, label: Text("Options")) {
                    ForEach(options, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .padding(.horizontal, 16)
                Spacer()
                CustomButton(title: "Pilih"){
                    selectedOption = tempSelectedOption
                    showSheet = false
                }
    
            }
            .presentationDetents([.height(404)]) // Set the sheet height to 404 points
            .presentationDragIndicator(.hidden) // Adds a drag indicator for the sheet
            .background(Color.background)
        }
    }
}

struct ScrollPickerExample: View {
    var body: some View {
        ScrollPicker()
    }
}

#Preview {
    ZStack{
        Color.black.ignoresSafeArea()
        ScrollPickerExample()
    }
}
