//
//  HistoriServisList.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 10/10/24.
//

import SwiftUI

struct HistoriServis: Identifiable {
    var id = UUID()
    var sparepart: SukuCadang
    var month: Int
    var year: Int
    var isPartChosen: Bool = false
    var isMonthYearChosen: Bool = false
}

struct HistoriServisList: View {
    @State private var items: [HistoriServis] = []
    
    var body: some View {
        VStack {
            List {
                ForEach(items.indices, id: \.self) { index in
                    HStack {
                        HStack {
                            Button(action: {
                                removeItem(at: index)
                            }) {
                                Image("minus")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            OBSparepartWheelPicker(
                                selectedValue: $items[index].sparepart,
                                isPartChosen: $items[index].isPartChosen,
                                availableParts: availableSpareparts(excluding: index)
                            )
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal, -8)
                        }
                        Spacer()
                        OBDateWheelPicker(
                            selectedMonth: $items[index].month,
                            selectedYear: $items[index].year,
                            isMonthYearChosen: $items[index].isMonthYearChosen
                        )
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal, -8)
                    }
                    .frame(height: 37)
                    .padding(.horizontal, -8)
                }
                
                HStack {
                    Button(action: {
                        addItem()
                    }) {
                        Image("plus")
                            .foregroundColor(.green)
                    }
                    Text("Tambahkan suku cadang lain")
                        .subhead(.regular)
                        .foregroundStyle(Color.accentColor)
                        .padding(.leading, 8)
                }
                .frame(height: 37)
                .padding(.horizontal, -8)
            }
        }
    }
    
    private func availableSpareparts(excluding currentIndex: Int) -> [SukuCadang] {
        let selectedParts = items.enumerated()
            .filter { $0.offset != currentIndex } // Exclude the current index
            .map { $0.element.sparepart }
        
        // Return only parts that have not been selected yet
        return SukuCadang.allCases.filter { !selectedParts.contains($0) }
    }

    
    private func addItem() {
        if let firstAvailablePart = availableSpareparts(excluding: -1).first {
            items.append(HistoriServis(sparepart: firstAvailablePart, month: 9, year: 24))
        }
    }
    
    private func removeItem(at index: Int) {
        items.remove(at: index)
    }
}


#Preview {
    HistoriServisList()
}
