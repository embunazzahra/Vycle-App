//
//  ScrollPicker.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 09/10/24.
//

import SwiftUI

struct ScrollPicker: View {
    @Binding var selectedSparepart: Sparepart? // Bind selected sparepart to the parent view
    @State private var showSheet: Bool = false
    var availableSpareparts: [Sparepart] // Filtered spare parts available to choose from

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
        .onAppear {
            // If no sparepart is selected, set the first available spare part as the default
            if selectedSparepart == nil, let firstAvailable = availableSpareparts.first {
                selectedSparepart = firstAvailable
            }
        }
        .sheet(isPresented: $showSheet) {
            VStack(alignment: .leading) {
                Text("Suku Cadang")
                    .title3(.emphasized)
                    .foregroundStyle(Color.neutral.shade300)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                
                Picker(selection: $selectedSparepart, label: Text("Options")) {
                    ForEach(availableSpareparts, id: \.self) { option in
                        Text(option.rawValue)
                            .title3(.regular)
                            .tag(option as Sparepart?)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .padding(.horizontal, 16)
                Spacer()
            }
            .presentationDetents([.height(404)]) // Set the sheet height to 404 points
            .presentationDragIndicator(.hidden) // Adds a drag indicator for the sheet
            .background(Color.background)
        }
    }
}

struct ScrollPickerExample: View {
    @State private var reminders: [Reminder] = [] // Your list of reminders
    @State private var selectedSparepart: Sparepart? = nil

    // Filtered list of spare parts based on already-used ones
    var availableSpareparts: [Sparepart] {
        let usedSpareparts = reminders.map { $0.sparepart }
        return Sparepart.allCases.filter { !usedSpareparts.contains($0) }
    }

    var body: some View {
        ScrollPicker(selectedSparepart: $selectedSparepart, availableSpareparts: availableSpareparts)
    }
}

#Preview {
    ZStack {
        ScrollPickerExample()
    }
}

