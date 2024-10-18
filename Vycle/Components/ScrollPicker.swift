//
//  ScrollPicker.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 09/10/24.
//

import SwiftUI



struct ScrollPicker: View {
    @State private var selectedSparepart: Sparepart? = nil
    @State private var showSheet: Bool = true
    
    var body: some View {
        Button(action: {
            showSheet.toggle()
        }) {
            Text(selectedSparepart?.rawValue ?? "Pilih suku cadang")
                .subhead(.regular)
                .padding(8)
                .foregroundStyle(showSheet ? Color.accentColor : Color.neutral.shade300)
                .background(Color.neutral.tint100)
                .cornerRadius(12)
        }
       
        .sheet(isPresented: $showSheet) {
            VStack (alignment: .leading) {
                Text("Suku Cadang")
                    .title3(.emphasized)
                    .foregroundStyle(Color.neutral.shade300)
                    .padding(.horizontal,16)
                    .padding(.vertical,14)
                
                Picker(selection: $selectedSparepart, label: Text("Options")) {
                    ForEach(Sparepart.allCases, id: \.self) { option in
                        Text(option.rawValue)
                            .title3(.regular)
                            .tag(option as Sparepart?)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .padding(.horizontal, 16)
                Spacer()
//                CustomButton(title: "Pilih"){
//                    showSheet = false
//                }
    
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
        ScrollPickerExample()
    }
}
