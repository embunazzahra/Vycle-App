//
//  NoServiceView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 08/10/24.
//

import SwiftUI
import UIKit

struct NoServiceView: View {
    
    @EnvironmentObject var routes: Routes
    @State private var showTutorial: Bool = true
    @Binding var onBoardingDataSaved: Bool
    @Binding var isShowSplash: Bool
    var body: some View {
        VStack {
            Image("service_empty_state_icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 236, height: 200)
                .foregroundStyle(.yellow)
            Text("Kamu belum pernah mencatat servis nih 🙁").font(.headline)
                .padding(.bottom,4)
            Text("Tambahkan catatan dengan tombol di bawah ini yuk").font(.footnote)
                .padding(.bottom,12)
            
            CustomButton(title: "Mulai mencatat") {
                routes.navigate(to: .AddServiceView(service: nil))
            }
            
        }
        
        
        .padding(.bottom,60)
        .navigationTitle("Servis")
    }
}

//#Preview {
//    NoServiceView()
//}

struct ChatBubbleTooltip: View {
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Triangle()
                .fill(Color.primary.tint300)
                .frame(width: 20, height: 10)
                .rotationEffect(.degrees(0))
                .offset(x: 20)// Point the tail downward
            Text(text)
                .footnote(.emphasized)
                .multilineTextAlignment(.center)
                .foregroundColor(.neutral.shade300)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.primary.tint300)
                )
            
            // Tail of the bubbl
        }.padding()
    }
}

// Simple triangular shape for the chat bubble tail
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY)) // Bottom-left
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY)) // Top-center
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY)) // Bottom-right
        path.closeSubpath()
        return path
    }
}
extension View {
    func negativeHighlight(enabled: Bool, tooltipText: String, onTap: @escaping () -> Void) -> some View {
        self
            .overlay(enabled ?
                ZStack {
                     
                        // Dimmed background
                        Color.black.opacity(0.5)
                            .reverseMask {
                                Rectangle()
                                    .fill(.red)
                                    .frame(width: .infinity, height: 380)
                                    .ignoresSafeArea()
                            }
                            .ignoresSafeArea()

                        // Chat bubble tooltip
                        VStack {
                            Spacer()
                            ChatBubbleTooltip(text: tooltipText)
                                .offset(y: 200) // Add space between the tooltip and highlighted section
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // Align to top of highlighted area
                         // Adjust position to match the highlighted section

                        // Tap gesture to dismiss
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture {
                                onTap()
                            }
                    
            } : nil
            )
            .ignoresSafeArea()
            .zIndex(enabled ? 1 : 0)
    }

    @inlinable func reverseMask<Mask: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ mask: () -> Mask
    ) -> some View {
        self.mask(
            ZStack {
                Rectangle()
                mask()
                    .blendMode(.destinationOut)
            }
            .ignoresSafeArea()
        )
    }
}





// Custom Button definition
struct CustomButtonAlternative: View {
    var title: String
    var symbolName: String? = nil // Optional symbol name
    var isEnabled: Bool = true
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(isEnabled ? Color.blue : Color.gray)
                .frame(width: 361, height: 60)
            
            HStack {
                if let symbol = symbolName {
                    Image(systemName: symbol)
                        .foregroundColor(.white)
                }
                Text(title)
                    .font(.body)
                    .foregroundColor(isEnabled ? Color.neutral.tint300 : Color.gray)
            }
        }
        .padding(.horizontal, 16)
    }
}

