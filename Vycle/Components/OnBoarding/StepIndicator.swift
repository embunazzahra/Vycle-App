//
//  SwiftUIView.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 07/10/24.
//

import SwiftUI

struct StepIndicator: View {
    @Binding var currentStep: Int
    
    let totalSteps = 4
    let stepLabels = ["Merk", "Odometer", "Histori", "Konfigurasi"]

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.primary.shade300)
                .frame(height: 1)
                .padding(.horizontal, 40)
                .padding(.bottom, 16)
            
            HStack {
                ForEach(1...totalSteps, id: \.self) { step in
                    VStack {
                        ZStack {
                            Circle()
                                .fill(self.stepColor(for: step))
                                .frame(width: 40, height: 40)

                            self.circleText(for: step)
                                .foregroundColor(self.numberColor(for: step))
                        }
                        Text(stepLabels[step - 1])
                            .caption2(.emphasized)
                            .foregroundColor(self.stepColor(for: step))
                    }
                    if step != totalSteps {
                        Spacer()
                    }
                }
            }.padding(.horizontal, 16)
        }
    }

    private func stepColor(for step: Int) -> Color {
        if step == currentStep {
            return Color.primary.tint200
        } else {
            return Color.primary.shade300
        }
    }
    
    private func numberColor(for step: Int) -> Color {
        if step == currentStep {
            return Color.primary.shade300
        } else {
            return Color.neutral.tone100
        }
    }
    
    @ViewBuilder
    private func circleText(for step: Int) -> some View {
        if step < currentStep {
            Image("check")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
        } else {
            Text("\(step)")
                .subhead(.emphasized)
        }
    }
}


struct StepIndicatorExample: View {
    @State private var currentStep = 1
    
    var body: some View {
        VStack {
            StepIndicator(currentStep: $currentStep)

            HStack {
                Button(action: {
                    if currentStep > 1 { currentStep -= 1 }
                }) {
                    Text("Previous")
                }

                Spacer()

                Button(action: {
                    if currentStep < 4 { currentStep += 1 }
                }) {
                    Text("Next")
                }
            }
            .padding()
        }
    }
}

#Preview {
    StepIndicatorExample()
}
