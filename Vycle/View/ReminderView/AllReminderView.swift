//
//  AllReminderView.swift
//  Vycle
//
//  Created by Clarissa Alverina on 08/10/24.
//
import SwiftUI

struct AllReminderView: View {
    let options: [String] = ["September 2025", "Oktober 2025", "November 2025", "Desember 2025"]
    @State private var selectedOption: String

    init() {
        _selectedOption = State(initialValue: options[0])
        setupNavigationBarWithoutScroll()
    }
    
    var body: some View {
        VStack {
            CustomScrollPicker(selectedOption: $selectedOption, options: options)
                .padding(.horizontal)
            
            ZStack {
                Rectangle()
                    .frame(width: .infinity , height: .infinity)
                    .clipShape(RoundedCornersShape(corners: [.topLeft, .topRight], radius: 20))
                    .foregroundStyle(.white)
                    .ignoresSafeArea()
                
                VStack {
                    VStack(alignment: .leading) {
                        Text("Suku cadang sudah menanti di Oktober! 🗓️")
                            .font(.headline)
                            .foregroundColor(Color.neutral.shade300)
                        Text("Jangan Lupa! Pengingat suku cadang sudah ada")
                            .foregroundColor(Color.neutral.tone300)
                            .font(.footnote)
                            .multilineTextAlignment(.leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    
                    ZStack {
                        Rectangle()
                            .frame(height: 80)
                            .cornerRadius(8)
                            .foregroundColor(Color.background)
                            .shadow(color: .black.opacity(0.2), radius: 2, x: 2, y: 2)
                            .padding(.horizontal, 16)
                        
                        HStack {
                            Rectangle()
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedCornersShape(corners: [.topLeft, .bottomLeft], radius: 8))
                                .foregroundColor(Color.gray)
                                .padding(.leading, 16)
                            
                            VStack (alignment: .leading) {
                                Text("Nama Sparepart")
                                    .subhead(.emphasized)
                                    .foregroundColor(Color.neutral.shade300)
                                    .padding(.bottom, 8)
                                
                                ProgressBar(currentKilometer: 13000, maxKilometer: 20000)
                                    .padding(.bottom, 3)
                            }
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                }
                
            }
        
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primary.tone100)
        .navigationTitle("Pengingat terjadwal")
        .navigationBarBackButtonHidden(false)
//        .accentColor(Color.white)
    }
}

struct CustomScrollPicker: View {
    @Binding var selectedOption: String
    let options: [String]

    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(options, id: \.self) { option in
                        VStack {
                            Text(option)
                                .subhead(.regular)
                            
                            HStack {
                                Text("0")
                                    .subhead(.emphasized)
                                Text("pengingat")
                                    .subhead(.emphasized)
                            }
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 5)
                        .foregroundColor(selectedOption == option ? .white : .white)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(selectedOption == option ? Color.primary.shade200 : Color.clear)
                                .frame(width: 132, height: 52)
                        )
                        .onTapGesture {
                            withAnimation {
                                selectedOption = option
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    AllReminderView()
}
