//
//  VehicleBrandView.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 13/10/24.
//

import SwiftUI

struct VehicleBrandView: View {
    @Binding var vehicleType: VehicleType
    @Binding var vehicleBrand: VehicleBrand?
    @Binding var otherBrandsList: [String]
    @Binding var year: Int?
    @Binding var currentPage: Int
    @State var chosenVehicleBrand: VehicleBrand?
    @State var showBrandTextField: Bool = true
    @State private var showAddBrandSheet: Bool = false
    
    var isButtonEnabled: Bool {
        vehicleBrand != nil
    }

    var allBrandsList: [VehicleBrand] {
        let predefinedBrands: [VehicleBrand] = Car.allCases.map { VehicleBrand.car($0) }
        
//        switch vehicleType {
//        case .car:
//            predefinedBrands = Car.allCases.map { VehicleBrand.car($0) }
//        case .motorcycle:
//            predefinedBrands = Motorcycle.allCases.map { VehicleBrand.motorcycle($0) }
//        case .none:
//            predefinedBrands = []
//        }

        let customBrandObjects = otherBrandsList.map { VehicleBrand.custom($0) }
            return predefinedBrands + customBrandObjects
    }
    
    @ViewBuilder
    func vehicleBrandButtons(from brands: [VehicleBrand]) -> some View {
        ForEach(brands, id: \.self) { brand in
            VehicleBrandButton(
                brand: brand,
                year: year,
                isSelected: vehicleBrand == brand
            ) {
                chosenVehicleBrand = brand
                showBrandTextField = false
                showAddBrandSheet = true
            }
        }
    }
    
//    init() {
//        _chosenVehicleBrand = State(initialValue: vehicleBrand.wrappedValue)
//    }
//    
    var body: some View {
        
        VStack (alignment: .leading) {
            Text("Pilih merk kendaraan milikmu")
                .title1(.emphasized)
                .foregroundStyle(Color.neutral.shade300)
                .padding(.horizontal,16)
                .padding(.vertical, 24)
            
            ScrollView {
                vehicleBrandButtons(from: allBrandsList)
                
                ZStack(alignment: .leading) {
                    Rectangle()
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .frame(width: 361, height: 64)
                        .foregroundStyle(Color.neutral.tint100)
                        .opacity(0.5)
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
                    showBrandTextField = true
                    showAddBrandSheet = true
                }
            }
            .sheet(isPresented: $showAddBrandSheet) {
                AddBrandSheet(
                    vehicleBrand: $vehicleBrand,
                    chosenVehicleBrand: $chosenVehicleBrand,
                    otherBrandsList: $otherBrandsList,
                    year: $year,
                    showBrandTextField: $showBrandTextField,
                    allBrandsList: allBrandsList,
                    currentPage: $currentPage
                )
            }
            
            Spacer()
            
            CustomButton(
                title: "Lanjutkan",
                iconName: "lanjutkan",
                iconPosition: .right,
                buttonType: isButtonEnabled ? .primary : .disabled,
                verticalPadding: 0
            ) {
                if isButtonEnabled {
                    currentPage += 1
                }
            }
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .onAppear() {
            chosenVehicleBrand = vehicleBrand
        }
    }
}


struct AddBrandSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var vehicleBrand: VehicleBrand?
    @Binding var chosenVehicleBrand: VehicleBrand?
    @Binding var otherBrandsList: [String]
    @Binding var year: Int?
    @State var otherBrandText: String = ""
    @State var yearText: String = ""
    @State var showErrorBrand: Bool = false
    @State var showErrorYear: Bool = false
    @Binding var showBrandTextField: Bool
    var allBrandsList: [VehicleBrand]
    @Binding var currentPage: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image("close")
            }.padding(16)
            
            if showBrandTextField {
                Text("Merk kendaraanmu")
                    .headline()
                    .foregroundColor(Color.neutral.shade300)
                    .padding(.horizontal, 16)
                
                HStack {
                    Image("merk_kendaraan")
                        .foregroundColor(Color.neutral.tone200)
                    TextField("", text: $otherBrandText)
                        .foregroundColor(Color.neutral.shade300)
                        .placeholder(when: otherBrandText.isEmpty) {
                            Text("Masukkan merk kendaraan")
                                .body(.regular)
                                .foregroundColor(Color.neutral.tone100)
                        }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(showErrorBrand ? Color.persianRed.red500 : Color.neutral.tone100, lineWidth: 1)
                )
                .padding(.horizontal, 16)
                
                if showErrorBrand {
                    HStack {
                        Image("warning")
                        Text("Merk kendaraan sudah tersedia di pilihan")
                            .footnote(.regular)
                            .foregroundColor(Color.persianRed.red500)
                            .padding(.top, 2)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                } else {
                    Rectangle()
                        .foregroundStyle(.clear)
                        .frame(height: 8)
                }
            }
            
            Text("Tahun Pembuatan Kendaraan")
                .headline()
                .foregroundColor(Color.neutral.shade300)
                .padding(.horizontal, 16)
        
            TextField("", text: $yearText)
                .keyboardType(.numberPad)
                .onChange(of: yearText) {
                    if yearText.count > 4 {
                        yearText = String(yearText.prefix(4))
                    }
                    yearText = yearText.filter { $0.isNumber }
                }
                .foregroundColor(Color.neutral.shade300)
                .placeholder(when: yearText.isEmpty) {
                    Text("Contoh: 2000")
                        .body(.regular)
                        .foregroundColor(Color.neutral.tone100)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
                .overlay(
                  RoundedRectangle(cornerRadius: 8)
                    .stroke(showErrorYear ? Color.persianRed.red500 : Color.neutral.tone100, lineWidth: 1)
                )
                .padding(.horizontal, 16)
            
            if showErrorYear {
                HStack {
                    Image("warning")
                    Text("Tahun kendaraanmu melebihi tahun sekarang")
                        .footnote(.regular)
                        .foregroundColor(Color.persianRed.red500)
                        .padding(.top, 2)
                }.padding(.horizontal, 16)
            } else {
                Text("Masukkan tahun manufaktur dari kendaraanmu")
                    .footnote(.regular)
                    .foregroundColor(Color.neutral.tone100)
                    .padding(.top, 2)
                    .padding(.horizontal, 16)
            }
       
            Spacer()
            
            CustomButton(
                title: "Lanjutkan",
                iconName: "lanjutkan",
                buttonType: ((!otherBrandText.isEmpty || !showBrandTextField) && yearText.count == 4) ? .primary : .disabled
            ) {
                if showBrandTextField {
                    handleBrandAndYearInput()
                } else {
                    handleYearInputOnly()
                }
                
                
            }
        }.background(Color.background)
    }
    
    private func isBrandDuplicate(_ brand: String) -> Bool {
        return allBrandsList.contains { $0.stringValue.lowercased() == brand.lowercased() }
    }
    
    private func isYearFuture(_ year: String) -> Bool {
        let currentYear = Calendar.current.component(.year, from: Date())
        if let yearInt = Int(year) {
            return yearInt > currentYear
        }
        return false
    }
    
    private func handleBrandAndYearInput() {
        guard !otherBrandText.isEmpty, yearText.count == 4 else { return }

        let isDuplicate = isBrandDuplicate(otherBrandText)
        let isFutureYear = isYearFuture(yearText)
        
        showErrorBrand = isDuplicate
        showErrorYear = isFutureYear

        if isDuplicate || isFutureYear {
            return
        }

        // Valid inputs: proceed with the action
        otherBrandsList.append(otherBrandText)
        vehicleBrand = .custom(otherBrandText)
        year = Int(yearText)
        moveToNextPage()
    }

    private func handleYearInputOnly() {
        guard yearText.count == 4 else { return }

        if isYearFuture(yearText) {
            showErrorYear = true
            return
        }
        // Valid input: proceed with the action
        year = Int(yearText)
        vehicleBrand = chosenVehicleBrand
        moveToNextPage()
    }

    private func moveToNextPage() {
        presentationMode.wrappedValue.dismiss()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            currentPage += 1
        }
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
