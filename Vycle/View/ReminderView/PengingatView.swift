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
    @State var isHavingRecord: Bool = true
    
    init() {
        setupNavigationBarWithoutScroll()
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    if isHavingRecord {
                        ReminderHeader()
                    } else {
                        ReminderHeaderNoData()
                    }
                }
                .padding(.bottom, 40)
                .background(Color.primary.tone100)
            
                ZStack {
                    Rectangle()
                        .frame(width: .infinity , height: .infinity)
                        .clipShape(RoundedCornersShape(corners: [.topLeft, .topRight], radius: 20))
                        .foregroundStyle(.white)
                        .ignoresSafeArea()
                    
                    VStack {
                        if isHavingRecord {
                            ReminderContentNear()
                                .frame(width: 390)
                                .padding(.vertical, 8)
                            
                            SparepartReminderCard()
                        } else {
                            ReminderContentNoData()
                                .frame(width: 390)
                                .padding(.vertical, 8)
                        }
                        
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color.primary.tone100)
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Pengingat")
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        
                    }) {
                        NavigationLink(destination: AddReminderView()) {
                            Image(systemName: "plus.square.fill")
                                .foregroundColor(Color.white)
                        }
                    }
                }
            }
        }
//        .accentColor(Color.white)
    }
}

#Preview {
    PengingatView()
}
