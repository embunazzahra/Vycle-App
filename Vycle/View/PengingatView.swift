//
//  PengingatView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 08/10/24.
//

import SwiftUI

struct RoundedCornersShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct PengingatView: View {
    var body: some View {
        NavigationStack {
            VStack {
                //            HStack {
                //                Text("Pengingat")
                //                    .font(.system(size: 34, weight: .bold))
                //                    .frame(height: 41)
                //                    .foregroundColor(.white)
                //                Spacer()
                //                Rectangle()
                //                    .frame(width: 38 , height: 38)
                //                    .cornerRadius(12)
                //            }
                //            .padding(.horizontal, 16)
                //            .padding(.bottom, 32)
                
                VStack {
                    ReminderHeader()
                }
                .padding(.bottom, 40)
                
                ZStack {
                    Rectangle()
                        .frame(width: .infinity , height: .infinity)
                        .clipShape(RoundedCornersShape(corners: [.topLeft, .topRight], radius: 20))
                        .foregroundStyle(.white)
                        .ignoresSafeArea()
                    
                    VStack {
                        ReminderContent()
                            .frame(width: 390)
                            .padding(.vertical, 8)
                        
                        
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
                        } .padding(.bottom, 6)
                        
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
                                    
                                    ProgressBar(currentKilometer: 22000, maxKilometer: 20000)
                                        .padding(.bottom, 3)
                                }
                                
                                Spacer()
                            }
                        } .padding(.bottom, 6)
                        
                        Spacer()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.primary.tone100)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Pengingat")
                        .foregroundColor(Color.neutral.tint300)
                        .title1(.emphasized)
                }
            }
        }
    }
}


struct ProgressBar: View {
    var currentKilometer: Double
    var maxKilometer: Double
    
    private var kilometerDifference: Double {
        return maxKilometer - currentKilometer
    }
    
    private var progress: Double {
        return min(currentKilometer / maxKilometer, 1.0)
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            if progress >= 0.66 {
                Text("Sudah tiba bulannya nih!")
                    .footnote(.emphasized)
                    .foregroundColor(Color.persianRed600)
            } else {
                Text("\(Int(kilometerDifference)) Kilometer lagi")
                    .footnote(.emphasized)
                    .foregroundColor(Color.lima600)
            }
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: 265, height: 8)
                    .cornerRadius(4)
                    .foregroundColor(Color.gray.opacity(0.3))
                
                Rectangle()
                    .frame(width: CGFloat(progress) * 265, height: 8)
                    .cornerRadius(4)
                    .foregroundColor(progress >= 0.66 ? .persianRed600 : .lima600)
                    .animation(.linear, value: progress)
            }
        }
    }
}



#Preview {
    PengingatView()
}
