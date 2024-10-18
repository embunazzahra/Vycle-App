//
//  VehicleBrandView.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 13/10/24.
//

import SwiftUI

struct VehicleBrandView: View {
    @Binding var vehicleType: VehicleType?
    @Binding var vehicleBrand: VehicleBrand?
    @Binding var otherBrandsList: [String]
    @State private var showAddBrandSheet: Bool = false

    var brandsList: [VehicleBrand] {
        let predefinedBrands: [VehicleBrand]
        switch vehicleType {
        case .car:
            predefinedBrands = [.honda, .suzuki, .toyota, .daihatsu, .mitsubishi]
        case .motorcycle:
            predefinedBrands = [.honda, .suzuki, .toyota]
        case .none:
            predefinedBrands = []
        }

        let customBrandObjects = otherBrandsList.map { VehicleBrand.custom($0) }
            return predefinedBrands + customBrandObjects
    }
    
    var action: () -> Void
    
    @ViewBuilder
    func vehicleBrandButtons(from brands: [VehicleBrand]) -> some View {
        ForEach(brands, id: \.self) { brand in
            VehicleBrandButton(
                brand: brand,
                isSelected: vehicleBrand == brand
            ) {
                vehicleBrand = brand
            }
        }
    }
    
    var body: some View {
        
        VStack (alignment: .leading) {
            Text("Pilih merk kendaraan milikmu")
                .title1(.emphasized)
                .foregroundStyle(Color.neutral.shade300)
                .padding(.horizontal,16)
                .padding(.vertical, 24)
            
            ScrollView {
                vehicleBrandButtons(from: brandsList)
                
                
                ZStack(alignment: .leading) {
                    Rectangle()
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .frame(width: 361, height: 64)
                        .foregroundStyle(Color.neutral.tint200)
                        .padding(.horizontal, 12)
                    
                    HStack {
                        Image("tambahkan")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .padding(.leading, 24)
                        Text("Masukkan merk lainnya")
                            .headline()
                            .foregroundStyle(Color.primary.base)
                            .padding(.leading, 4)
                    }
                }.onTapGesture {
                    showAddBrandSheet = true
                }
                .sheet(isPresented: $showAddBrandSheet) {
                    AddBrandSheet(
                        vehicleBrand: $vehicleBrand,
                        otherBrandsList: $otherBrandsList,
                        brandsList: brandsList,
                        action: action
                    )
                }
            }
            
            Spacer()
        }
    }
}


struct AddBrandSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var vehicleBrand: VehicleBrand?
    @Binding var otherBrandsList: [String]
    @State var otherBrand: String = ""
    @State var showError: Bool = false
    var brandsList: [VehicleBrand]
    var action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image("close")
            }.padding(16)
            
            Text("Merk kendaraanmu")
                .headline()
                .foregroundColor(Color.neutral.shade300)
                .padding(.horizontal, 16)

            HStack {
                Image("merk_kendaraan")
                    .foregroundColor(Color.neutral.tone200)
                TextField("", text: $otherBrand)
                    .foregroundColor(Color.neutral.shade300)
                    .placeholder(when: otherBrand.isEmpty) {
                        Text("Masukkan merk kendaraan").foregroundColor(Color.neutral.tone100)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .overlay(
              RoundedRectangle(cornerRadius: 8)
                .stroke(showError ? Color.persianRed.red500 : Color.neutral.tone100, lineWidth: 1)
            )
            .padding(.horizontal, 16)
            
            if showError {
                HStack {
                    Image("warning")
                    Text("Merk kendaraan sudah tersedia di pilihan!")
                        .footnote(.regular)
                        .foregroundColor(Color.persianRed.red500)
                        .padding(.top, 2)
                }.padding(.horizontal, 16)
            }
       
            Spacer()
            
            CustomButton(
                title: "Lanjutkan",
                iconName: "lanjutkan",
                buttonType: otherBrand.isEmpty ? .disabled : .primary
            ) {
                if !otherBrand.isEmpty {
                    if !isBrandDuplicate(otherBrand) {
                        otherBrandsList.append(otherBrand)
                        vehicleBrand = .custom(otherBrand)
                        presentationMode.wrappedValue.dismiss()
                        action()
                    } else {
                        showError = true
                    }
                }
            }
        }.background(Color.background)
    }
    
    private func isBrandDuplicate(_ brand: String) -> Bool {
        return brandsList.contains { $0.stringValue.lowercased() == brand.lowercased() }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

//#Preview {
//    VehicleBrandView()
//}
