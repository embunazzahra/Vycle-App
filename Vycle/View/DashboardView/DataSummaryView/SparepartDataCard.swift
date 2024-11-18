//
//  SparepartDataCard.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 15/11/24.
//


import SwiftUI
import SwiftData

struct SparepartDataCard: View {
    var sparepart: Sparepart
    var count: Int
    
    private var imageName: String {
        switch sparepart {
        case .oliMesin:
            return "olimesin_twotone"
            
        case .busi:
            return "busi_twotone"

        case .filterOli:
            return "filteroli_twotone"

        case .minyakKopling:
            return "minyakkopling_twotone"

        case .minyakRem:
            return "minyakrem_twotone"
            
        case .oliTransmisi:
            return "olitransmisi_twotone"
            
        case .airCoolant:
            return "aircoolant_twotone"
            
        case .filterUdara:
            return "filterudara_twotone"
            
        case .oliGardan:
            return "oligardan_twotone"

        default:
            return ""
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.primary.tone300)
                .overlay(
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 40,maxHeight: 44, alignment: .bottomTrailing),
                    alignment: .bottomTrailing
                )
            
            HStack{
                VStack(alignment: .leading){
                    Text(sparepart.rawValue)
                        .foregroundStyle(Color.neutral.tint300)
                        .font(.footnote)
                    Spacer()
                    HStack(spacing: 3){
                        Text("\(count)")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.neutral.tint300)
                        Text("kali")
                            .font(.caption)
                            .foregroundStyle(Color.neutral.tint300)
                            .padding(.top,5)
                    }
                }
                .frame(maxWidth: 55, alignment: .leading)
                Spacer()
            }
            .frame(maxWidth: 108)
            .padding(8)
        }
        .frame(maxWidth: 108, maxHeight: 85)
    }
}

#Preview {
    SparepartDataCard(sparepart: .minyakRem, count: 10)
}
