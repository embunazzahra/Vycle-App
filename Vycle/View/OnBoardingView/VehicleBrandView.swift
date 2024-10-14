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
    @State private var showAddBrandSheet: Bool = false
    @State private var otherBrand: String = ""
    var action: () -> Void
    
    var brands: [VehicleBrand] {
        switch vehicleType {
        case .mobil:
            return [.honda, .suzuki, .toyota, .daihatsu, .mitsubishi]
        case .motor:
            return [.honda, .suzuki, .toyota]
        case .none:
            return []
        }
    }
    
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
                .padding(.top, 24)
                .padding(.bottom, 24)
            
            ScrollView {
                vehicleBrandButtons(from: brands)
                
                
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
                    AddBrandSheet(vehicleBrand: $vehicleBrand, otherBrand: $otherBrand, action: action)
                }
            }
            
            Spacer()
        }
    }
}


struct AddBrandSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var vehicleBrand: VehicleBrand?
    @Binding var otherBrand: String
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
            .padding(.vertical, 16)
            .overlay(
              RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 1)
            )
            .padding(.horizontal, 16)
       
            Spacer()
            
            CustomButton(title: "Lanjutkan", iconName: "lanjutkan", buttonType: otherBrand.isEmpty ? .disabled : .primary) {
                if !otherBrand.isEmpty {
                    vehicleBrand = .custom(otherBrand)
                    presentationMode.wrappedValue.dismiss()
                    action()
                }
            }
        }.background(Color.background)
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
